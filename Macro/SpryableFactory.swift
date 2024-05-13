import SwiftSyntax
import SwiftSyntaxBuilder

struct SpryableFactory {
    static func classDeclaration(for protocolDeclaration: ProtocolDeclSyntax) throws -> ClassDeclSyntax {
        let attributes = protocolDeclaration.attributes.filterSpryable()
        let modifiers = protocolDeclaration.modifiers.trimmed + [DeclModifierSyntax(name: .keyword(.final))]
        let identifier = TokenSyntax.identifier("Fake" + protocolDeclaration.name.text)
        let genericParameterClause = constructGenericParameterClause(protocolDeclaration)
        let inheritanceClause = inheritanceFakeClause(protocolDeclaration)

        return try ClassDeclSyntax(attributes: attributes,
                                   modifiers: modifiers,
                                   name: identifier,
                                   genericParameterClause: genericParameterClause,
                                   inheritanceClause: inheritanceClause,
                                   memberBlockBuilder: {
                                       let requirements = try Requirements(protocolDeclaration)
                                       try enumBlockBuilder(requirements, isStatic: true)
                                       try enumBlockBuilder(requirements, isStatic: false).with(\.leadingTrivia, .newlines(2))
                                       try variables(requirements, isStatic: true)
                                       try variables(requirements, isStatic: false)
                                       try functions(requirements, isStatic: true)
                                       try functions(requirements, isStatic: false)
                                   })
    }

    private static func functions(_ requirements: Requirements, isStatic: Bool) throws -> MemberBlockItemListSyntax {
        let protocolModifiers = requirements.syntax.modifiers.filterPrivate().trimmed

        func implement(with function: FunctionRequirement) throws -> FunctionDeclSyntax {
            var syntax = function.syntax.with(\.modifiers, protocolModifiers)
            let parameters = syntax.signature.parameterClause.parameters.enumerated().map { idx, param in
                let name = param.secondName ?? param.firstName
                if name.text != TokenSyntax.wildcardToken().text {
                    return param
                } else {
                    return param.with(\.secondName, .identifier("arg\(idx)"))
                }
            }

            syntax = syntax.with(\.signature, syntax.signature.with(\.parameterClause, syntax.signature.parameterClause.with(\.parameters, .init(parameters))))

            let body = CodeBlockSyntax(statements: CodeBlockItemListSyntax {
                let arguments = LabeledExprListSyntax {
                    for (idx, parameter) in parameters.enumerated() {
                        let name = parameter.secondName ?? parameter.firstName
                        if idx == 0 {
                            LabeledExprSyntax(label: "arguments", expression: DeclReferenceExprSyntax(baseName: name))
                        } else {
                            LabeledExprSyntax(expression: DeclReferenceExprSyntax(baseName: name))
                        }
                    }
                }

                let funcCall = FunctionCallExprSyntax(calledExpression: DeclReferenceExprSyntax(baseName: "spryify"),
                                                      leftParen: .leftParenToken(),
                                                      arguments: arguments,
                                                      rightParen: .rightParenToken())
                ReturnStmtSyntax(expression: funcCall)
            })

            syntax = syntax.with(\.body, body)
            return syntax.with(\.leadingTrivia, .newlines(2))
        }

        return try MemberBlockItemListSyntax {
            for variable in requirements.functions.filter(isStatic: isStatic) {
                try MemberBlockItemSyntax(decl: implement(with: variable))
            }
        }
    }

    private static func variables(_ requirements: Requirements, isStatic: Bool) throws -> MemberBlockItemListSyntax {
        let modifiers = requirements.syntax.modifiers.filterPrivate()
        func implement(with variable: VariableRequirement) throws -> VariableDeclSyntax {
            var bindings: [PatternBindingSyntax] = []
            let accessorBlock: AccessorBlockSyntax
            if let setAccessor = variable.syntax.setAccessor {
                let getAccessor = try variable.syntax.getAccessor
                let accList = AccessorDeclListSyntax {
                    let getter = CodeBlockSyntax(statements: CodeBlockItemListSyntax {
                        ReturnStmtSyntax(expression: DeclReferenceExprSyntax(baseName: "stubbedValue()"))
                    })
                    getAccessor.with(\.body, getter)

                    let setter = CodeBlockSyntax(statements: CodeBlockItemListSyntax {
                        FunctionCallExprSyntax(calledExpression: DeclReferenceExprSyntax(baseName: "recordCall"),
                                               leftParen: .leftParenToken(),
                                               arguments: .init(itemsBuilder: {
                                                   LabeledExprSyntax(label: "arguments", expression: DeclReferenceExprSyntax(baseName: "newValue"))
                                               }),
                                               rightParen: .rightParenToken())
                    })
                    setAccessor.with(\.body, setter)
                }

                accessorBlock = AccessorBlockSyntax(accessors: .accessors(accList))
            } else {
                let body = CodeBlockItemListSyntax {
                    ReturnStmtSyntax(expression: DeclReferenceExprSyntax(baseName: "spryify()"))
                }
                accessorBlock = AccessorBlockSyntax(accessors: .getter(body))
            }

            try bindings.append(variable.syntax.binding.with(\.accessorBlock, accessorBlock))
            let variable = VariableDeclSyntax(attributes: variable.syntax.attributes,
                                              modifiers: modifiers,
                                              bindingSpecifier: .keyword(.var),
                                              bindings: .init(bindings))
            return variable.with(\.leadingTrivia, .newlines(2))
        }

        return try MemberBlockItemListSyntax {
            for variable in requirements.variables.filter(isStatic: isStatic) {
                try MemberBlockItemSyntax(decl: implement(with: variable))
            }
        }
    }

    private static func enumBlockBuilder(_ requirements: Requirements, isStatic: Bool) throws -> EnumDeclSyntax {
        let declarations = try enumCaseDeclarations(requirements, isStatic: isStatic)
        let members: MemberBlockItemListSyntax
        if declarations.isEmpty {
            members = MemberBlockItemListSyntax {
                let caseName: String = "_unknown_"
                let caseEl = EnumCaseElementSyntax(name: .identifier(caseName), rawValue: .init(value: StringLiteralExprSyntax(content: "'enum' must have at least one 'case'")))
                let elements: EnumCaseElementListSyntax = .init(arrayLiteral: caseEl)
                EnumCaseDeclSyntax(elements: elements)
            }
        } else {
            members = MemberBlockItemListSyntax {
                for enumCase in declarations {
                    enumCase
                }
            }
        }

        let inheritanceEnumClause = InheritanceClauseSyntax {
            InheritedTypeSyntax(type: IdentifierTypeSyntax(name: "String"))
            InheritedTypeSyntax(type: IdentifierTypeSyntax(name: "StringRepresentable"))
        }

        return EnumDeclSyntax(modifiers: requirements.syntax.modifiers.filterPrivate(),
                              name: isStatic ? "ClassFunction" : "Function",
                              inheritanceClause: inheritanceEnumClause,
                              memberBlock: MemberBlockSyntax(members: members))
    }

    private static func enumCaseDeclarations(_ requirements: Requirements, isStatic: Bool) throws -> [EnumCaseDeclSyntax] {
        var cases = [EnumCaseDeclSyntax]()
        for variable in requirements.variables {
            guard variable.syntax.modifiers.isStatic == isStatic else {
                continue
            }

            let caseName: String = try variable.syntax.binding.pattern.trimmedDescription
            let caseEl = EnumCaseElementSyntax(name: .identifier(caseName))
            let elements: EnumCaseElementListSyntax = .init(arrayLiteral: caseEl)
            let enumCase = EnumCaseDeclSyntax(elements: elements)
            cases.append(enumCase)
        }

        for function in requirements.functions {
            guard function.syntax.modifiers.isStatic == isStatic else {
                continue
            }

            let caseName = function.syntax.name.text
            let parameters: [String] = function.syntax.signature.parameterClause.parameters.enumerated().map { idx, param in
                var name: [String] = []
                if param.firstName.trimmed.text == TokenSyntax.wildcardToken().text {
                    if let secondName = param.secondName?.trimmed,
                       secondName.text != TokenSyntax.wildcardToken().text {
                        name.append(secondName.text.capitalized)
                    } else {
                        name.append("Arg\(idx)")
                    }
                } else {
                    name.append(param.firstName.trimmed.text.capitalized)
                }

                return name.joined(separator: "_")
            }
            let name = parameters.isEmpty ? caseName : caseName.description + "With" + parameters.joined(separator: "_")
            let rawValue = caseName + function.syntax.signature.parameterClause.trimmedDescription

            let caseEl: EnumCaseElementSyntax
            caseEl = EnumCaseElementSyntax(name: .identifier(name),
                                           rawValue: InitializerClauseSyntax(value: StringLiteralExprSyntax(content: rawValue)))
            let elements: EnumCaseElementListSyntax = .init(arrayLiteral: caseEl)
            let enumCase = EnumCaseDeclSyntax(elements: elements)
            cases.append(enumCase)
        }

        var uniqRawValues: Set<String> = []
        let uniq = cases.filter { enumCaseDeclSyntax in
            guard let text = enumCaseDeclSyntax.elements.first?.rawValue?.value.description else {
                // vars are without 'rawValue'
                return true
            }
            return uniqRawValues.insert(text).inserted
        }
        return uniq
    }

    private static func inheritanceFakeClause(_ protocolDeclaration: ProtocolDeclSyntax) -> InheritanceClauseSyntax {
        InheritanceClauseSyntax {
            InheritedTypeSyntax(type: IdentifierTypeSyntax(
                name: protocolDeclaration.name.trimmed
            ))
            InheritedTypeSyntax(type: IdentifierTypeSyntax(
                name: "Spryable"
            ))
        }
    }

    private static func constructGenericParameterClause(_ protocolDeclaration: ProtocolDeclSyntax) -> GenericParameterClauseSyntax? {
        let associatedtypeDeclList = protocolDeclaration.memberBlock.members.compactMap {
            $0.decl.as(AssociatedTypeDeclSyntax.self)
        }

        if associatedtypeDeclList.isEmpty {
            return nil
        }

        var genericParameterList = [GenericParameterSyntax]()
        for (idx, associatedtypeDecl) in associatedtypeDeclList.enumerated() {
            let associatedtypeName = associatedtypeDecl.name
            let typeInheritance: InheritanceClauseSyntax? = associatedtypeDecl.inheritanceClause
            let inheritedType = typeInheritance?.inheritedTypes.first?.type
            let hasTrailingComma: Bool = idx < associatedtypeDeclList.count - 1
            let genericParameter = GenericParameterSyntax(name: associatedtypeName,
                                                          colon: inheritedType != nil ? typeInheritance?.colon : nil,
                                                          inheritedType: typeInheritance?.inheritedTypes.first?.type,
                                                          trailingComma: hasTrailingComma ? .commaToken() : nil)

            genericParameterList.append(genericParameter)
        }

        return GenericParameterClauseSyntax(
            parameters: GenericParameterListSyntax(genericParameterList)
        )
    }
}

private extension AttributeListSyntax {
    func filterSpryable() -> AttributeListSyntax {
        return filter {
            switch $0 {
            case .attribute(let attribute):
                guard let id = attribute.attributeName.as(IdentifierTypeSyntax.self)?.name else {
                    return true
                }

                let result = id.text == "Spryable"
                return !result
            case .ifConfigDecl:
                return true
            }
        }.with(\.trailingTrivia, .newline)
    }
}

private extension VariableDeclSyntax {
    var getAccessor: AccessorDeclSyntax {
        get throws {
            let getAccessor = try accessors.first {
                return $0.accessorSpecifier.tokenKind == .keyword(.get)
            }
            guard let getAccessor else {
                throw SpryableDiagnostic.invalidVariableRequirement
            }
            return getAccessor
        }
    }

    var setAccessor: AccessorDeclSyntax? {
        return try? accessors.first {
            return $0.accessorSpecifier.tokenKind == .keyword(.set)
        }
    }

    var binding: PatternBindingSyntax {
        get throws {
            guard let binding = bindings.first else {
                throw SpryableDiagnostic.invalidVariableRequirement
            }
            return binding
        }
    }

    private var accessors: AccessorDeclListSyntax {
        get throws {
            guard let accessorBlock = try binding.accessorBlock,
                  case .accessors(let accessorList) = accessorBlock.accessors else {
                throw SpryableDiagnostic.invalidVariableRequirement
            }
            return accessorList
        }
    }
}

private extension [VariableRequirement] {
    func filter(isStatic: Bool) -> Self {
        return filter {
            return $0.syntax.modifiers.isStatic == isStatic
        }
    }
}

private extension [FunctionRequirement] {
    func filter(isStatic: Bool) -> Self {
        return filter {
            return $0.syntax.modifiers.isStatic == isStatic
        }
    }
}

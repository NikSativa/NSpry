import SwiftSyntax

extension DeclModifierListSyntax {
    var isStatic: Bool {
        return contains {
            return $0.name.tokenKind == .keyword(.static)
        }
    }

    func filterPrivate() -> DeclModifierListSyntax {
        return filter {
            return $0.name.tokenKind != .keyword(.private)
        }
    }
}

struct FunctionRequirement {
    let index: Int
    let syntax: FunctionDeclSyntax
}

struct VariableRequirement {
    let index: Int
    let syntax: VariableDeclSyntax
}

struct Requirements {
    let syntax: ProtocolDeclSyntax
    let functions: [FunctionRequirement]
    let variables: [VariableRequirement]

    init(_ syntax: ProtocolDeclSyntax) throws {
        self.syntax = syntax

        let members = syntax.memberBlock.members
        var functions: [FunctionRequirement] = []
        var variables: [VariableRequirement] = []
        for member in members {
            if member.decl.is(SubscriptDeclSyntax.self) {
                throw FakeifyDiagnostic.subscriptsNotSupported
            } else if let decl = member.decl.as(VariableDeclSyntax.self) {
                variables.append(VariableRequirement(index: variables.count, syntax: decl))
            } else if let decl = member.decl.as(FunctionDeclSyntax.self) {
                guard case .identifier = decl.name.tokenKind else {
                    throw FakeifyDiagnostic.operatorsNotSupported
                }
                functions.append(FunctionRequirement(index: variables.count, syntax: decl))
            }
        }

        self.variables = variables
        self.functions = functions
    }
}

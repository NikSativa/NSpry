import SwiftDiagnostics
import SwiftSyntax
import SwiftSyntaxMacros

enum Extractor {
    private static let defaultPreprocessorFlag = "FACKING"

    static func protocolDeclaration(from declaration: DeclSyntaxProtocol) throws -> ProtocolDeclSyntax {
        guard let protocolDeclaration = declaration.as(ProtocolDeclSyntax.self) else {
            throw FakeifyDiagnostic.onlyApplicableToProtocol
        }

        return protocolDeclaration
    }

    static func preprocessorFlag(from attribute: AttributeSyntax,
                                 in context: some MacroExpansionContext) throws -> String {
        guard case .argumentList(let argumentList) = attribute.arguments else {
            // No arguments are present in the attribute.
            return defaultPreprocessorFlag
        }

        let preprocessorFlagArgument = argumentList.first(where: { argument in
            argument.label?.text == "preprocessorFlag"
        })

        guard let preprocessorFlagArgument else {
            // The `preprocessorFlag` argument is missing.
            return Self.defaultPreprocessorFlag
        }

        let segments = preprocessorFlagArgument.expression
            .as(StringLiteralExprSyntax.self)?
            .segments

        guard let segments,
              segments.count == 1,
              case .stringSegment(let literalSegment)? = segments.first else {
            // The `preprocessorFlag` argument's value is not a static string literal.
            context.diagnose(
                Diagnostic(node: attribute,
                           message: FakeifyDiagnostic.preprocessorFlagArgumentRequiresStaticStringLiteral,
                           highlights: [Syntax(preprocessorFlagArgument.expression)],
                           notes: [
                               Note(node: Syntax(preprocessorFlagArgument.expression),
                                    message: FakeifyNoteMessage.preprocessorFlagArgumentRequiresStaticStringLiteral)
                           ])
            )
            return Self.defaultPreprocessorFlag
        }

        return literalSegment.content.text
    }
}

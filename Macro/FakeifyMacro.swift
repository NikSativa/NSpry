import SwiftDiagnostics
import SwiftSyntax
import SwiftSyntaxMacros

public enum FakeifyMacro: PeerMacro {
    public static func expansion(of node: AttributeSyntax,
                                 providingPeersOf declaration: some DeclSyntaxProtocol,
                                 in context: some MacroExpansionContext) throws -> [DeclSyntax] {
        let flag = try Extractor.preprocessorFlag(from: node, in: context)
        let protocolDeclaration = try Extractor.protocolDeclaration(from: declaration)
        let fakeClassDeclaration = try FakeifyFactory.classDeclaration(for: protocolDeclaration)

        let codeblock = CodeBlockItemListSyntax {
            ImportDeclSyntax(importKeyword: .keyword(.import), path: .init([.init(name: .identifier("SpryKit"))]))
                .with(\.trailingTrivia, .newlines(2))

            DeclSyntax(fakeClassDeclaration)
        }

        let ifClause = IfConfigClauseListSyntax {
            IfConfigClauseSyntax(poundKeyword: .poundIfToken(),
                                 condition: ExprSyntax(stringLiteral: flag),
                                 elements: .statements(codeblock))
        }

        return [
            DeclSyntax(
                IfConfigDeclSyntax(clauses: ifClause)
            )
        ]
    }
}

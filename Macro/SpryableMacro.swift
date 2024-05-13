import SwiftDiagnostics
import SwiftSyntax
import SwiftSyntaxMacros

public enum SpryableMacro: ExtensionMacro {
//    public static func expansion(
//        of node: AttributeSyntax,
//        providingMembersOf declaration: some DeclGroupSyntax,
//        in context: some MacroExpansionContext
//    ) throws -> [DeclSyntax] {
//        return []
//    }

//    public static func expansion(of node: AttributeSyntax,
//                                 providingPeersOf declaration: some DeclSyntaxProtocol,
//                                 in context: some MacroExpansionContext) throws -> [DeclSyntax] {
//        guard let classDeclaration = declaration.as(ClassDeclSyntax.self) else {
//            throw SpryableDiagnostic.onlyApplicableToProtocol
//        }
//
//        guard let inh = classDeclaration.inheritanceClause?.inheritedTypes.first else {
//            throw SpryableDiagnostic.onlyApplicableToProtocol
//        }
////        guard let protocolDeclaration = inh.syntaxNodeType else {
////            throw SpryableDiagnostic.onlyApplicableToProtocol
////        }
//
////        let fakeClassDeclaration = try SpryableFactory.classDeclaration(for: classDeclaration)
//
//        return [
//            DeclSyntax(stringLiteral: "\n"),
////            DeclSyntax(fakeClassDeclaration),
//            DeclSyntax(stringLiteral: "\n")
//        ]
//    }

//    public static func expansion(of node: AttributeSyntax, 
//                                 attachedTo declaration: some DeclGroupSyntax,
//                                 providingExtensionsOf type: some TypeSyntaxProtocol,
//                                 conformingTo protocols: [SwiftSyntax.TypeSyntax],
//                                 in context: some SwiftSyntaxMacros.MacroExpansionContext) throws -> [SwiftSyntax.ExtensionDeclSyntax] {
//        return []
//    }
//
//    public static func expansion(
//        of node: AttributeSyntax,
//        providingMembersOf declaration: some DeclGroupSyntax,
//        conformingTo protocols: [TypeSyntax],
//        in context: some MacroExpansionContext
//    ) throws -> [DeclSyntax] {
//        return []
//    }

    public static func expansion(of node: AttributeSyntax, attachedTo declaration: some DeclGroupSyntax, providingExtensionsOf type: some TypeSyntaxProtocol, conformingTo protocols: [TypeSyntax], in context: some MacroExpansionContext) throws -> [ExtensionDeclSyntax] {
        return []
    }
}

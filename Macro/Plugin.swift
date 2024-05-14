import SwiftCompilerPlugin
import SwiftSyntaxMacros

@main
struct SpryableCompilerPlugin: CompilerPlugin {
    let providingMacros: [Macro.Type] = [
        SpryableAccessorMacro.self,
        SpryableCodeItemMacro.self,
        SpryableDeclarationMacro.self,
        SpryableExpressionMacro.self,
        SpryableExtensionMacro.self,
        SpryableMemberAttributeMacro.self,
        SpryableMemberMacro.self,
        SpryablePeerMacro.self
    ]
}

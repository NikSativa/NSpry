import SwiftCompilerPlugin
import SwiftSyntaxMacros

@main
struct SpryableCompilerPlugin: CompilerPlugin {
    let providingMacros: [Macro.Type] = [
        SpryableMacro.self
    ]
}

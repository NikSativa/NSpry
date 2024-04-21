import SwiftCompilerPlugin
import SwiftSyntaxMacros

@main
struct FakeifyCompilerPlugin: CompilerPlugin {
    let providingMacros: [Macro.Type] = [
        FakeifyMacro.self
    ]
}

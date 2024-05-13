#if canImport(SwiftSyntax509)
import Foundation

@attached(peer)
public macro Spryable() = #externalMacro(module: "SpryableMacro", type: "SpryableMacro")
#endif

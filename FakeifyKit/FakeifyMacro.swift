#if canImport(SwiftSyntax509)
import Foundation

@attached(peer, names: prefixed(Fake))
public macro Fakeify(preprocessorFlag: String? = nil) = #externalMacro(module: "FakeifyMacro", type: "FakeifyMacro")
#endif

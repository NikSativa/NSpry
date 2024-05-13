import SpriteKit
import SwiftSyntaxMacrosTestSupport
import XCTest

@testable import SpryableMacro

final class SpryableMacroTests: XCTestCase {
    private let sut = ["Spryable": SpryableMacro.self]

    func testStaticVarMacro() {
        let protocolDeclaration =
            """
            public extension Foo {}

            public protocol Foo {
                static var barStatic: Int { get }
                static var barStaticSet: Int { get set }
                static var barStaticThrows: Int { get throws }
                static var barStaticAsyncThrows: Int { get async throws  }
            }
            """
        assertMacroExpansion("""
                             @Spryable
                             \(protocolDeclaration)
                             """,
                             expandedSource:
                             """
                             \(protocolDeclaration)
                             """,
                             macros: sut)
    }

//    func testVarMacro() {
//        let protocolDeclaration =
//            """
//            public protocol Foo {
//                var barStatic: Int { get }
//                var barStaticSet: Int { get set }
//                var barStaticThrows: Int { get throws }
//                var barStaticAsyncThrows: Int { get async throws  }
//            }
//            """
//        assertMacroExpansion("""
//                             @Spryable
//                             \(protocolDeclaration)
//                             """,
//                             expandedSource:
//                             """
//                             \(protocolDeclaration)
//
//                             #if FACKING
//                             public final class FakeFoo: Foo, Spryable {
//                                 public enum ClassFunction: String, StringRepresentable {
//                                 }
//
//                                 public enum Function: String, StringRepresentable {
//                                     case barStatic
//                                     case barStaticSet
//                                     case barStaticThrows
//                                     case barStaticAsyncThrows
//                                 }
//
//                                 public var barStatic: Int {
//                                     return spryify()
//                                 }
//
//                                 public var barStaticSet: Int {
//                                     get {
//                                         return stubbedValue()
//                                     }
//                                     set {
//                                         recordCall(arguments: newValue)
//                                     }
//                                 }
//
//                                 public var barStaticThrows: Int {
//                                     return spryify()
//                                 }
//
//                                 public var barStaticAsyncThrows: Int {
//                                     return spryify()
//                                 }
//
//                                 public var barStatic: Int {
//                                     return spryify()
//                                 }
//
//                                 public var barStaticSet: Int {
//                                     get {
//                                         return stubbedValue()
//                                     }
//                                     set {
//                                         recordCall(arguments: newValue)
//                                     }
//                                 }
//
//                                 public var barStaticThrows: Int {
//                                     return spryify()
//                                 }
//
//                                 public var barStaticAsyncThrows: Int {
//                                     return spryify()
//                                 }
//                             }
//                             #endif
//                             """,
//                             macros: sut)
//    }
//
//    func testStaticFuncMacro() {
//        let protocolDeclaration =
//            """
//            public protocol Foo {
//                static func baz()
//                static func baz(_: Int)
//                static func baq(_: Int)
//                static func baq(_: Int) -> Int
//                static func baz(_ x: Int)
//                static func baq(_ x: Int)
//                static func baq(_ x: Int) -> Int
//                static func baz(x: Int)
//                static func baq(x: Int)
//                static func baq(x: Int) -> Int
//            }
//            """
//        assertMacroExpansion("""
//                             @Spryable
//                             \(protocolDeclaration)
//                             """,
//                             expandedSource:
//                             """
//                             \(protocolDeclaration)
//
//                             #if FACKING
//                             public final class FakeFoo: Foo, Spryable {
//                                 public enum ClassFunction: String, StringRepresentable {
//                                     case baz = "baz()"
//                                     case bazWithArg0 = "baz(_: Int)"
//                                     case baqWithArg0 = "baq(_: Int)"
//                                     case bazWithX = "baz(_ x: Int)"
//                                     case baqWithX = "baq(_ x: Int)"
//                                     case bazWithX = "baz(x: Int)"
//                                     case baqWithX = "baq(x: Int)"
//                                 }
//
//                                 public enum Function: String, StringRepresentable {
//                                 }
//
//                                 static func baz() {
//                                     return spryify()
//                                 }
//
//                                 static func baz(_ arg0: Int) {
//                                     return spryify(arguments: arg0)
//                                 }
//
//                                 static func baq(_ arg0: Int) {
//                                     return spryify(arguments: arg0)
//                                 }
//
//                                 static func baq(_ arg0: Int) -> Int {
//                                     return spryify(arguments: arg0)
//                                 }
//
//                                 static func baz(_ x: Int) {
//                                     return spryify(arguments: x)
//                                 }
//
//                                 static func baq(_ x: Int) {
//                                     return spryify(arguments: x)
//                                 }
//
//                                 static func baq(_ x: Int) -> Int {
//                                     return spryify(arguments: x)
//                                 }
//
//                                 static func baz(x: Int) {
//                                     return spryify(arguments: x)
//                                 }
//
//                                 static func baq(x: Int) {
//                                     return spryify(arguments: x)
//                                 }
//
//                                 static func baq(x: Int) -> Int {
//                                     return spryify(arguments: x)
//                                 }
//
//                                 static func baz() {
//                                     return spryify()
//                                 }
//
//                                 static func baz(_ arg0: Int) {
//                                     return spryify(arguments: arg0)
//                                 }
//
//                                 static func baq(_ arg0: Int) {
//                                     return spryify(arguments: arg0)
//                                 }
//
//                                 static func baq(_ arg0: Int) -> Int {
//                                     return spryify(arguments: arg0)
//                                 }
//
//                                 static func baz(_ x: Int) {
//                                     return spryify(arguments: x)
//                                 }
//
//                                 static func baq(_ x: Int) {
//                                     return spryify(arguments: x)
//                                 }
//
//                                 static func baq(_ x: Int) -> Int {
//                                     return spryify(arguments: x)
//                                 }
//
//                                 static func baz(x: Int) {
//                                     return spryify(arguments: x)
//                                 }
//
//                                 static func baq(x: Int) {
//                                     return spryify(arguments: x)
//                                 }
//
//                                 static func baq(x: Int) -> Int {
//                                     return spryify(arguments: x)
//                                 }
//                             }
//                             #endif
//                             """,
//                             macros: sut)
//    }
//
//    func testFuncMacro() {
//        let protocolDeclaration =
//            """
//            public protocol Foo {
//                func baz()
//                func baz(_: Int)
//                func baq(_: Int)
//                func baq(_: Int) -> Int
//                func baz(_ x: Int)
//                func baq(_ x: Int)
//                func baq(_ x: Int) -> Int
//                func baz(x: Int)
//                func baq(x: Int)
//                func baq(x: Int) -> Int
//            }
//            """
//        assertMacroExpansion("""
//                             @Spryable
//                             \(protocolDeclaration)
//                             """,
//                             expandedSource:
//                             """
//                             \(protocolDeclaration)
//
//                             #if FACKING
//                             public final class FakeFoo: Foo, Spryable {
//                                 public enum ClassFunction: String, StringRepresentable {
//                                 }
//
//                                 public enum Function: String, StringRepresentable {
//                                     case baz = "baz()"
//                                     case bazWithArg0 = "baz(_: Int)"
//                                     case baqWithArg0 = "baq(_: Int)"
//                                     case bazWithX = "baz(_ x: Int)"
//                                     case baqWithX = "baq(_ x: Int)"
//                                     case bazWithX = "baz(x: Int)"
//                                     case baqWithX = "baq(x: Int)"
//                                 }
//
//                                 func baz() {
//                                     return spryify()
//                                 }
//
//                                 func baz(_ arg0: Int) {
//                                     return spryify(arguments: arg0)
//                                 }
//
//                                 func baq(_ arg0: Int) {
//                                     return spryify(arguments: arg0)
//                                 }
//
//                                 func baq(_ arg0: Int) -> Int {
//                                     return spryify(arguments: arg0)
//                                 }
//
//                                 func baz(_ x: Int) {
//                                     return spryify(arguments: x)
//                                 }
//
//                                 func baq(_ x: Int) {
//                                     return spryify(arguments: x)
//                                 }
//
//                                 func baq(_ x: Int) -> Int {
//                                     return spryify(arguments: x)
//                                 }
//
//                                 func baz(x: Int) {
//                                     return spryify(arguments: x)
//                                 }
//
//                                 func baq(x: Int) {
//                                     return spryify(arguments: x)
//                                 }
//
//                                 func baq(x: Int) -> Int {
//                                     return spryify(arguments: x)
//                                 }
//
//                                 func baz() {
//                                     return spryify()
//                                 }
//
//                                 func baz(_ arg0: Int) {
//                                     return spryify(arguments: arg0)
//                                 }
//
//                                 func baq(_ arg0: Int) {
//                                     return spryify(arguments: arg0)
//                                 }
//
//                                 func baq(_ arg0: Int) -> Int {
//                                     return spryify(arguments: arg0)
//                                 }
//
//                                 func baz(_ x: Int) {
//                                     return spryify(arguments: x)
//                                 }
//
//                                 func baq(_ x: Int) {
//                                     return spryify(arguments: x)
//                                 }
//
//                                 func baq(_ x: Int) -> Int {
//                                     return spryify(arguments: x)
//                                 }
//
//                                 func baz(x: Int) {
//                                     return spryify(arguments: x)
//                                 }
//
//                                 func baq(x: Int) {
//                                     return spryify(arguments: x)
//                                 }
//
//                                 func baq(x: Int) -> Int {
//                                     return spryify(arguments: x)
//                                 }
//                             }
//                             #endif
//                             """,
//                             macros: sut)
//    }
//
//    func testStaticFuncParamsMacro() {
//        let protocolDeclaration =
//            """
//            public protocol Foo {
//                static func baz(_: Int,_: Float)
//                static func baq(_: Int) -> Int
//                static func baq(_ x: Int, y: Float)
//                static func baq(_ x: Int, y: Float) -> Int
//                static func baq(x: Int, _: Float)
//            }
//            """
//        assertMacroExpansion("""
//                             @Spryable
//                             \(protocolDeclaration)
//                             """,
//                             expandedSource:
//                             """
//                             \(protocolDeclaration)
//
//                             #if FACKING
//                             public final class FakeFoo: Foo, Spryable {
//                                 public enum ClassFunction: String, StringRepresentable {
//                                     case bazWithArg0_Arg1 = "baz(_: Int,_: Float)"
//                                     case baqWithArg0 = "baq(_: Int)"
//                                     case baqWithX_Y = "baq(_ x: Int, y: Float)"
//                                     case baqWithX_Arg1 = "baq(x: Int, _: Float)"
//                                 }
//
//                                 public enum Function: String, StringRepresentable {
//                                 }
//
//                                 static func baz(_ arg0: Int, _ arg1: Float) {
//                                     return spryify(arguments: arg0, arg1)
//                                 }
//
//                                 static func baq(_ arg0: Int) -> Int {
//                                     return spryify(arguments: arg0)
//                                 }
//
//                                 static func baq(_ x: Int, y: Float) {
//                                     return spryify(arguments: x, y)
//                                 }
//
//                                 static func baq(_ x: Int, y: Float) -> Int {
//                                     return spryify(arguments: x, y)
//                                 }
//
//                                 static func baq(x: Int, _ arg1: Float) {
//                                     return spryify(arguments: x, arg1)
//                                 }
//
//                                 static func baz(_ arg0: Int, _ arg1: Float) {
//                                     return spryify(arguments: arg0, arg1)
//                                 }
//
//                                 static func baq(_ arg0: Int) -> Int {
//                                     return spryify(arguments: arg0)
//                                 }
//
//                                 static func baq(_ x: Int, y: Float) {
//                                     return spryify(arguments: x, y)
//                                 }
//
//                                 static func baq(_ x: Int, y: Float) -> Int {
//                                     return spryify(arguments: x, y)
//                                 }
//
//                                 static func baq(x: Int, _ arg1: Float) {
//                                     return spryify(arguments: x, arg1)
//                                 }
//                             }
//                             #endif
//                             """,
//                             macros: sut)
//    }
//
//    func testFuncParamsMacro() {
//        let protocolDeclaration =
//            """
//            public protocol Foo {
//                func baz(_: Int,_: Float)
//                func baq(_: Int) -> Int
//                func baq(_ x: Int, y: Float)
//                func baq(_ x: Int, y: Float) -> Int
//                func baq(x: Int, _: Float)
//            }
//            """
//        assertMacroExpansion("""
//                             @Spryable
//                             \(protocolDeclaration)
//                             """,
//                             expandedSource:
//                             """
//                             \(protocolDeclaration)
//
//                             #if FACKING
//                             public final class FakeFoo: Foo, Spryable {
//                                 public enum ClassFunction: String, StringRepresentable {
//                                 }
//
//                                 public enum Function: String, StringRepresentable {
//                                     case bazWithArg0_Arg1 = "baz(_: Int,_: Float)"
//                                     case baqWithArg0 = "baq(_: Int)"
//                                     case baqWithX_Y = "baq(_ x: Int, y: Float)"
//                                     case baqWithX_Arg1 = "baq(x: Int, _: Float)"
//                                 }
//
//                                 func baz(_ arg0: Int, _ arg1: Float) {
//                                     return spryify(arguments: arg0, arg1)
//                                 }
//
//                                 func baq(_ arg0: Int) -> Int {
//                                     return spryify(arguments: arg0)
//                                 }
//
//                                 func baq(_ x: Int, y: Float) {
//                                     return spryify(arguments: x, y)
//                                 }
//
//                                 func baq(_ x: Int, y: Float) -> Int {
//                                     return spryify(arguments: x, y)
//                                 }
//
//                                 func baq(x: Int, _ arg1: Float) {
//                                     return spryify(arguments: x, arg1)
//                                 }
//
//                                 func baz(_ arg0: Int, _ arg1: Float) {
//                                     return spryify(arguments: arg0, arg1)
//                                 }
//
//                                 func baq(_ arg0: Int) -> Int {
//                                     return spryify(arguments: arg0)
//                                 }
//
//                                 func baq(_ x: Int, y: Float) {
//                                     return spryify(arguments: x, y)
//                                 }
//
//                                 func baq(_ x: Int, y: Float) -> Int {
//                                     return spryify(arguments: x, y)
//                                 }
//
//                                 func baq(x: Int, _ arg1: Float) {
//                                     return spryify(arguments: x, arg1)
//                                 }
//                             }
//                             #endif
//                             """,
//                             macros: sut)
//    }
//
//    func testPrivate() {
//        let protocolDeclaration =
//            """
//            private protocol Foo {
//                static var bar: Int { get }
//                var bar: Int { get }
//                static func baz(_: Int,_: Float)
//                func baq(_: Int) -> Int
//            }
//            """
//        assertMacroExpansion("""
//                             @Spryable
//                             \(protocolDeclaration)
//                             """,
//                             expandedSource:
//                             """
//                             \(protocolDeclaration)
//
//                             #if FACKING
//                             private final class FakeFoo: Foo, Spryable {
//                                 enum ClassFunction: String, StringRepresentable {
//                                     case bar
//                                     case bazWithArg0_Arg1 = "baz(_: Int,_: Float)"
//                                 }
//
//                                 enum Function: String, StringRepresentable {
//                                     case bar
//                                     case baqWithArg0 = "baq(_: Int)"
//                                 }
//
//                                 var bar: Int {
//                                     return spryify()
//                                 }
//
//                                 var bar: Int {
//                                     return spryify()
//                                 }
//
//                                 var bar: Int {
//                                     return spryify()
//                                 }
//
//                                 var bar: Int {
//                                     return spryify()
//                                 }
//
//                                 static func baz(_ arg0: Int, _ arg1: Float) {
//                                     return spryify(arguments: arg0, arg1)
//                                 }
//
//                                 func baq(_ arg0: Int) -> Int {
//                                     return spryify(arguments: arg0)
//                                 }
//
//                                 static func baz(_ arg0: Int, _ arg1: Float) {
//                                     return spryify(arguments: arg0, arg1)
//                                 }
//
//                                 func baq(_ arg0: Int) -> Int {
//                                     return spryify(arguments: arg0)
//                                 }
//                             }
//                             #endif
//                             """,
//                             macros: sut)
//    }
//
//    func testMix() {
//        let protocolDeclaration =
//            """
//            public protocol Foo {
//                static var bar: Int { get }
//                static func bar(_: Int,_: Float)
//                var bar: Int { get }
//                func bar(_: Int) -> Int
//            }
//            """
//        assertMacroExpansion("""
//                             @Spryable
//                             \(protocolDeclaration)
//                             """,
//                             expandedSource:
//                             """
//                             \(protocolDeclaration)
//
//                             #if FACKING
//                             public final class FakeFoo: Foo, Spryable {
//                                 public enum ClassFunction: String, StringRepresentable {
//                                     case bar
//                                     case barWithArg0_Arg1 = "bar(_: Int,_: Float)"
//                                 }
//
//                                 public enum Function: String, StringRepresentable {
//                                     case bar
//                                     case barWithArg0 = "bar(_: Int)"
//                                 }
//
//                                 public var bar: Int {
//                                     return spryify()
//                                 }
//
//                                 public var bar: Int {
//                                     return spryify()
//                                 }
//
//                                 public var bar: Int {
//                                     return spryify()
//                                 }
//
//                                 public var bar: Int {
//                                     return spryify()
//                                 }
//
//                                 static func bar(_ arg0: Int, _ arg1: Float) {
//                                     return spryify(arguments: arg0, arg1)
//                                 }
//
//                                 func bar(_ arg0: Int) -> Int {
//                                     return spryify(arguments: arg0)
//                                 }
//
//                                 static func bar(_ arg0: Int, _ arg1: Float) {
//                                     return spryify(arguments: arg0, arg1)
//                                 }
//
//                                 func bar(_ arg0: Int) -> Int {
//                                     return spryify(arguments: arg0)
//                                 }
//                             }
//                             #endif
//                             """,
//                             macros: sut)
//    }
//
//    // MARK: - `preprocessorFlag` argument
//
//    func testMacroWithNoArgument() {
//        let protocolDeclaration = "public protocol MyProtocol {}"
//
//        assertMacroExpansion("""
//                             @Spryable()
//                             \(protocolDeclaration)
//                             """,
//                             expandedSource: """
//                             \(protocolDeclaration)
//
//                             #if FACKING
//                             public final class FakeMyProtocol: MyProtocol, Spryable {
//                                 public enum ClassFunction: String, StringRepresentable {
//                                 }
//
//                                 public enum Function: String, StringRepresentable {
//                                 }
//                             }
//                             #endif
//                             """,
//                             macros: sut)
//    }
//
//    func testMacroWithNopreprocessorFlagArgument() {
//        let protocolDeclaration = "protocol MyProtocol {}"
//
//        assertMacroExpansion("""
//                             @Spryable(someOtherArgument: 1)
//                             \(protocolDeclaration)
//                             """,
//                             expandedSource: """
//                             \(protocolDeclaration)
//
//                             #if FACKING
//                             final class FakeMyProtocol: MyProtocol, Spryable {
//                                 enum ClassFunction: String, StringRepresentable {
//                                 }
//
//                                 enum Function: String, StringRepresentable {
//                                 }
//                             }
//                             #endif
//                             """,
//                             macros: sut)
//    }
//
//    func testMacroWithpreprocessorFlagArgument() {
//        let protocolDeclaration = "protocol MyProtocol {}"
//
//        assertMacroExpansion("""
//                             @Spryable(preprocessorFlag: "CUSTOM")
//                             \(protocolDeclaration)
//                             """,
//                             expandedSource: """
//                             \(protocolDeclaration)
//
//                             #if CUSTOM
//                             final class FakeMyProtocol: MyProtocol, Spryable {
//                                 enum ClassFunction: String, StringRepresentable {
//                                 }
//
//                                 enum Function: String, StringRepresentable {
//                                 }
//                             }
//                             #endif
//                             """,
//                             macros: sut)
//    }
//
//    func testMacroWithpreprocessorFlagArgumentAndOtherAttributes() {
//        let protocolDeclaration = "protocol MyProtocol {}"
//
//        assertMacroExpansion("""
//                             @MainActor
//                             @Spryable(preprocessorFlag: "CUSTOM")
//                             @available(*, deprecated)
//                             \(protocolDeclaration)
//                             """,
//                             expandedSource: """
//                             @MainActor
//                             @available(*, deprecated)
//                             \(protocolDeclaration)
//
//                             #if CUSTOM
//                             @MainActor
//                             @available(*, deprecated)
//                             final class FakeMyProtocol: MyProtocol, Spryable {
//                                 enum ClassFunction: String, StringRepresentable {
//                                 }
//
//                                 enum Function: String, StringRepresentable {
//                                 }
//                             }
//                             #endif
//                             """,
//                             macros: sut)
//    }
//
//    func testMacroWithpreprocessorFlagArgumentWithInterpolation() {
//        let protocolDeclaration = "protocol MyProtocol {}"
//
//        assertMacroExpansion(#"""
//                             @Spryable(preprocessorFlag: "CUSTOM\(123)FLAG")
//                             \#(protocolDeclaration)
//                             """#,
//                             expandedSource: """
//
//                             \(protocolDeclaration)
//
//                             #if FACKING
//                             final class FakeMyProtocol: MyProtocol, Spryable {
//                                 enum ClassFunction: String, StringRepresentable {
//                                 }
//
//                                 enum Function: String, StringRepresentable {
//                                 }
//                             }
//                             #endif
//                             """,
//                             diagnostics: [
//                                 DiagnosticSpec(message: "The `preprocessorFlag` argument requires a static string literal",
//                                                line: 1,
//                                                column: 1,
//                                                notes: [
//                                                    NoteSpec(message:
//                                                        "Provide a literal string value without any dynamic expressions or interpolations to meet the static string literal requirement.",
//                                                        line: 1,
//                                                        column: 28)
//                                                ])
//                             ],
//                             macros: sut)
//    }
//
//    func testMacroWithpreprocessorFlagArgumentFromVariable() {
//        let protocolDeclaration = "public protocol MyProtocol {}"
//
//        assertMacroExpansion("""
//                             let myCustomFlag = "DEBUG"
//
//                             @Spryable(preprocessorFlag: myCustomFlag)
//                             \(protocolDeclaration)
//                             """,
//                             expandedSource: """
//                             let myCustomFlag = "DEBUG"
//                             \(protocolDeclaration)
//
//                             #if FACKING
//                             public final class FakeMyProtocol: MyProtocol, Spryable {
//                                 public enum ClassFunction: String, StringRepresentable {
//                                 }
//
//                                 public enum Function: String, StringRepresentable {
//                                 }
//                             }
//                             #endif
//                             """,
//                             diagnostics: [
//                                 DiagnosticSpec(message: "The `preprocessorFlag` argument requires a static string literal",
//                                                line: 3,
//                                                column: 1,
//                                                notes: [
//                                                    NoteSpec(message:
//                                                        "Provide a literal string value without any dynamic expressions or interpolations to meet the static string literal requirement.",
//                                                        line: 3,
//                                                        column: 28)
//                                                ])
//                             ],
//                             macros: sut)
//    }
}

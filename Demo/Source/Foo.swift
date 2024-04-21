import FakeifyKit
import Foundation

@Fakeify
public protocol Foo {
    var bar: Int { get }
    func bar(_: Int) -> Int
}

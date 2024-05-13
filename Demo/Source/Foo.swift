import Foundation
import SpryableKit

@Spryable
public protocol Foo {
    var bar: Int { get }
    func bar(_: Int) -> Int
}

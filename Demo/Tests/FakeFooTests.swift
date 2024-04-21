import DemoSpryKit
import Foundation
import SpryKit
import XCTest
import FakeifyKit

final class FakeFooTests: XCTestCase {
    func test_fake() async throws {
        let subject: FakeFoo = .init()
        subject.stub(.barStatic).andReturn(2)
        XCTAssertEqual(subject.barStatic, 2)
        XCTAssertEqual(subject.barStatic, 2)
        XCTAssertHaveReceived(subject, .barStatic, countSpecifier: .exactly(2))
    }
}

import Foundation
import SpryKit
import XCTest

final class XCTAssertThrowsErrorTests: XCTestCase {
    fileprivate enum Error: Swift.Error {
        case one
        case two
    }

    func test_errors() {
        XCTAssertThrowsError(try throwError(), Error.one)
        XCTAssertThrowsError(Error.one) {
            try throwError()
        }

        XCTAssertNoThrowError(try notThrowError())
        XCTAssertNoThrowError {
            try notThrowError()
        }
    }
}

private func throwError() throws {
    throw XCTAssertThrowsErrorTests.Error.one
}

private func notThrowError() throws {
    // nothig
}

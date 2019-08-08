import Foundation
import XCTest

extension XCUIElement {
    func assertShown() {
        XCTAssertTrue(exists)
    }

    func assertNotShown() {
        XCTAssertFalse(exists)
    }
}

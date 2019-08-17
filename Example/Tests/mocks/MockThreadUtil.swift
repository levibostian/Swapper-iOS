import Foundation
@testable import Swapper

internal class MockThreadUtil: ThreadUtil {
    var mock_isMain: Bool = true
    var mock_isMain_calls: Int = 0
    var isMain: Bool {
        mock_isMain_calls += 1
        return mock_isMain
    }

    var mock_isBackground: Bool = true
    var mock_isBackground_calls: Int = 0
    var isBackground: Bool {
        mock_isBackground_calls += 1
        return mock_isBackground
    }

    var mock_assertIsMain_calls = 0
    func assertIsMain() {
        mock_assertIsMain_calls += 1
    }
}

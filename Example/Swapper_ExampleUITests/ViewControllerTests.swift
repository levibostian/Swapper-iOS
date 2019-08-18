@testable import Pods_Swapper_Example
import XCTest

class ViewControllerTests: XCTestCase {
    var app: XCUIApplication!
    var viewController: ViewControllerPageObject!

    override func setUp() {
        continueAfterFailure = false

        app = XCUIApplication()
        app.launchArguments.append("--uitesting")

        viewController = ViewControllerPageObject(app: app)
    }

    override func tearDown() {}

    func test_coldStartSwapperViewShowingCorrectViews() {
        app.launch()

        viewController.swapperView.assertShown()
        viewController.swapButton.assertShown()
        viewController.mcKinleyImage.assertShown()

        viewController.littleHillImage.assertNotShown()
    }

    func test_swapToOtherView() {
        app.launch()

        viewController.swapButton.tap()

        viewController.mcKinleyImage.assertNotShown()
        viewController.littleHillImage.assertShown()
    }
}

class ViewControllerPageObject {
    let app: XCUIApplication

    var swapperView: XCUIElement {
        return app.otherElements[AccessibilityIdentifiers.swapperView]
    }

    var swapButton: XCUIElement {
        return app.buttons[AccessibilityIdentifiers.swapButton]
    }

    var mcKinleyImage: XCUIElement! {
        return app.images[AccessibilityIdentifiers.mcKinleyImage]
    }

    var littleHillImage: XCUIElement! {
        return app.images[AccessibilityIdentifiers.littleHillImage]
    }

    init(app: XCUIApplication) {
        self.app = app
    }
}

@testable import Swapper
import XCTest

class SwapperViewTests: XCTestCase {
    private var swapperView: SwapperView!
    private var threadUtil: MockThreadUtil!

    override func setUp() {
        super.setUp()

        threadUtil = MockThreadUtil()

        Di.instance = Di()
        Di.instance.threadUtil = threadUtil

        swapperView = SwapperView()
        SwapperView.defaultConfig.transitionAnimationDuration = 0.0
    }

    override func tearDown() {
        super.tearDown()

        Di.instance = Di()
    }

    func test_choosesInstanceConfigOverDefaultConfig() {
        let defaultBackgroundColor: UIColor = .white
        let instanceConfigBackgroundColor: UIColor = .green
        var instanceConfig: SwapperViewConfig {
            let config = SwapperViewConfig()
            config.backgroundColor = instanceConfigBackgroundColor
            return config
        }

        SwapperView.defaultConfig.backgroundColor = defaultBackgroundColor
        swapperView.config = instanceConfig

        let otherInstanceSwapperView = SwapperView()

        XCTAssertEqual(SwapperView.defaultConfig.backgroundColor, defaultBackgroundColor)
        XCTAssertEqual(swapperView.backgroundColor, instanceConfigBackgroundColor)

        XCTAssertEqual(otherInstanceSwapperView.backgroundColor, defaultBackgroundColor)
    }

    func test_swapToAnimateOldView_expectToBeCalledWhenSet() {
        let expectAnimatorToBeCalled = XCTestExpectation(description: "Expect animator to be called")
        let swappingViews = [
            ("1", UIView()),
            ("2", UIView())
        ]
        var swapConfig: SwapperViewConfig {
            let config = SwapperViewConfig()
            config.swapToAnimateOldView = { oldView in
                expectAnimatorToBeCalled.fulfill()
            }
            return config
        }
        swapperView.config = swapConfig

        swapperView.setSwappingViews(swappingViews)

        try! swapperView.swapTo(swappingViews[1].0, onComplete: nil)

        wait(for: [expectAnimatorToBeCalled], timeout: TestConfig.defaultWait)
    }

    func test_setSwappingViews_expectCallThreadUtil() {
        let swappingViews = [
            ("1", UIView())
        ]

        XCTAssertEqual(threadUtil.mock_assertIsMain_calls, 0)
        swapperView.setSwappingViews(swappingViews)
        XCTAssertGreaterThan(threadUtil.mock_assertIsMain_calls, 0)
    }

    func test_swapTo_expectCallThreadUtil() {
        let swappingViews = [
            ("1", UIView())
        ]

        swapperView.setSwappingViews(swappingViews)
        let numberCallsAssertMain = threadUtil.mock_assertIsMain_calls

        try! swapperView.swapTo(swappingViews[0].0) {
            XCTAssertEqual(self.threadUtil.mock_assertIsMain_calls, numberCallsAssertMain + 1)
        }
    }

    func test_swapToAnimateNewView_expectToBeCalledWhenSet() {
        let expectAnimatorToBeCalled = XCTestExpectation(description: "Expect animator to be called")
        let swappingViews = [
            ("1", UIView()),
            ("2", UIView())
        ]

        var swapConfig: SwapperViewConfig {
            let config = SwapperViewConfig()
            config.swapToAnimateNewView = { newView in
                expectAnimatorToBeCalled.fulfill()
            }
            return config
        }
        swapperView.config = swapConfig

        swapperView.setSwappingViews(swappingViews)

        try! swapperView.swapTo(swappingViews[1].0, onComplete: nil)

        wait(for: [expectAnimatorToBeCalled], timeout: TestConfig.defaultWait)
    }

    func test_expectNoViewShownAtFirstLoad() {
        XCTAssertTrue(swapperView.subviews.isEmpty)
        XCTAssertNil(swapperView.currentView)
    }

    func test_currentView_expectValueAfterSettingSwappableViews() {
        let swappingViews = [
            ("1", UIView()),
            ("2", UIButton())
        ]

        swapperView.setSwappingViews(swappingViews)

        XCTAssertEqual(swapperView.currentView!.0, swappingViews[0].0)
        XCTAssertEqual(swapperView.subviews[0], swappingViews[0].1)
    }

    func test_currentView_expectValueAfterSwappingView() {
        let swappingViews = [
            ("1", UIView()),
            ("2", UIButton())
        ]

        swapperView.setSwappingViews(swappingViews)
        try! swapperView.swapTo(swappingViews[1].0) {
            XCTAssertEqual(self.swapperView.currentView!.0, swappingViews[1].0)
            XCTAssertEqual(self.swapperView.subviews[0], swappingViews[1].1)
        }
    }

    func test_currentView_expectCorrectValueAfter_setSwappingViews_call() {
        let expectatation = XCTestExpectation(description: "Test should be successful")
        let swappingViews = [
            ("1", UIView()),
            ("2", UIView())
        ]

        let newSetSwappingViews = [
            ("3", UIView()),
            ("4", UIView())
        ]

        swapperView.setSwappingViews(swappingViews)
        try! swapperView.swapTo(swappingViews[1].0) {
            self.swapperView.setSwappingViews(newSetSwappingViews)

            XCTAssertEqual(self.swapperView.currentView!.0, newSetSwappingViews[0].0)
            XCTAssertEqual(self.swapperView.subviews[0], newSetSwappingViews[0].1)

            expectatation.fulfill()
        }

        wait(for: [expectatation], timeout: TestConfig.defaultWait)
    }

    func test_currentView_expectCorrectNil_setSwappingViews_callWithEmptyArray() {
        let swappingViews = [
            ("1", UIView()),
            ("2", UIView())
        ]

        swapperView.setSwappingViews(swappingViews)
        swapperView.setSwappingViews([])

        XCTAssertNil(swapperView.currentView)
        XCTAssertTrue(swapperView.subviews.isEmpty)
    }

    func test_swapTo_throwsIfIdNotFound() {
        XCTAssertThrowsError(try swapperView.swapTo("not-found", onComplete: nil))
    }
}

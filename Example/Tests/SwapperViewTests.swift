@testable import Swapper
import XCTest

class SwapperViewTests: XCTestCase {
    private var swapperView: SwapperView<String>!
    private var threadUtil: MockThreadUtil!
    private var swapperViewConfig: SwapperViewConfig! // Create a default config for testing so that animation duration is set to default

    override func setUp() {
        super.setUp()

        threadUtil = MockThreadUtil()

        Di.instance = Di()
        Di.instance.threadUtil = threadUtil

        swapperView = SwapperView()
        swapperViewConfig = SwapperViewConfig()
        swapperViewConfig.transitionAnimationDuration = TestConfig.defaultAnimationDuration
        SwapperViewConfig.shared.transitionAnimationDuration = TestConfig.defaultAnimationDuration

        UIApplication.shared.keyWindow!.addSubview(swapperView) // Must set this to make animations work.
    }

    override func tearDown() {
        super.tearDown()

        UIView.setAnimationsEnabled(true)

        swapperView.removeFromSuperview()

        Di.instance = Di()
    }

    func test_choosesInstanceConfigOverDefaultConfig() {
        let defaultAnimationDuration: Double = 1.0
        let instanceConfigAnimationDuration: Double = defaultAnimationDuration + 1
        var instanceConfig: SwapperViewConfig {
            let config = SwapperViewConfig()
            config.transitionAnimationDuration = instanceConfigAnimationDuration
            return config
        }

        SwapperViewConfig.shared.transitionAnimationDuration = defaultAnimationDuration
        swapperView.config = instanceConfig

        let otherInstanceSwapperView = SwapperView<String>()

        XCTAssertEqual(SwapperViewConfig.shared.transitionAnimationDuration, defaultAnimationDuration)
        XCTAssertEqual(swapperView.config.transitionAnimationDuration, instanceConfigAnimationDuration)

        XCTAssertEqual(otherInstanceSwapperView.config.transitionAnimationDuration, defaultAnimationDuration)
    }

    func test_swapToAnimateOldView_expectToBeCalledWhenSet() {
        let expectAnimatorToBeCalled = XCTestExpectation(description: "Expect animator to be called")
        let swappingViews = [
            ("1", UIView()),
            ("2", UIView())
        ]
        swapperViewConfig.swapToAnimateOldView = { oldView in
            expectAnimatorToBeCalled.fulfill()
        }
        swapperView.config = swapperViewConfig

        swapperView.setSwappingViews(swappingViews)

        try! swapperView.swapTo(swappingViews[0].0, onComplete: nil)
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
        swapperViewConfig.swapToAnimateNewView = { newView in
            expectAnimatorToBeCalled.fulfill()
        }
        swapperView.config = swapperViewConfig

        swapperView.setSwappingViews(swappingViews)

        try! swapperView.swapTo(swappingViews[0].0, onComplete: nil)
        try! swapperView.swapTo(swappingViews[1].0, onComplete: nil)

        wait(for: [expectAnimatorToBeCalled], timeout: TestConfig.defaultWait)
    }

    func test_swapTo_animationDuration0_expectOnCompleteNoAnimation() {
        let expectAnimateOldViewNotCalled = XCTestExpectation(description: "Expect animate old view to NOT be called")
        expectAnimateOldViewNotCalled.isInverted = true
        let expectAnimateNewViewNotCalled = XCTestExpectation(description: "Expect animate new view to NOT be called")
        expectAnimateNewViewNotCalled.isInverted = true
        let expectOnComplete = expectation(description: "Expect onComplete to be called")

        let swappingViews = [
            ("1", UIView()),
            ("2", UIView())
        ]
        swapperViewConfig.transitionAnimationDuration = 0.0
        swapperViewConfig.swapToAnimateOldView = { oldView in
            expectAnimateOldViewNotCalled.fulfill()
        }
        swapperViewConfig.swapToAnimateNewView = { newView in
            expectAnimateNewViewNotCalled.fulfill()
        }
        swapperView.config = swapperViewConfig

        swapperView.setSwappingViews(swappingViews)

        try! swapperView.swapTo(swappingViews[1].0, onComplete: {
            expectOnComplete.fulfill()
        })

        waitForExpectations(timeout: TestConfig.defaultWait, handler: nil)
    }

    func test_swapTo_disableGlobalAnimations_expectOnCompleteNoAnimation() {
        let expectAnimateOldViewNotCalled = XCTestExpectation(description: "Expect animate old view to NOT be called")
        expectAnimateOldViewNotCalled.isInverted = true
        let expectAnimateNewViewNotCalled = XCTestExpectation(description: "Expect animate new view to NOT be called")
        expectAnimateNewViewNotCalled.isInverted = true
        let expectOnComplete = expectation(description: "Expect onComplete to be called")

        let swappingViews = [
            ("1", UIView()),
            ("2", UIView())
        ]
        UIView.setAnimationsEnabled(false)
        swapperViewConfig.swapToAnimateOldView = { oldView in
            expectAnimateOldViewNotCalled.fulfill()
        }
        swapperViewConfig.swapToAnimateNewView = { newView in
            expectAnimateNewViewNotCalled.fulfill()
        }
        swapperView.config = swapperViewConfig

        swapperView.setSwappingViews(swappingViews)

        try! swapperView.swapTo(swappingViews[1].0, onComplete: {
            expectOnComplete.fulfill()
        })

        waitForExpectations(timeout: TestConfig.defaultWait, handler: nil)
    }

    func test_swapTo_ifCurrentViewIgnore() {
        let expectAnimatorToBeCalled = XCTestExpectation(description: "Expect animator to be called")
        let swappingViews = [
            ("1", UIView()),
            ("2", UIView())
        ]
        swapperViewConfig.swapToAnimateOldView = { oldView in
            expectAnimatorToBeCalled.fulfill()
        }
        swapperView.config = swapperViewConfig

        swapperView.setSwappingViews(swappingViews)

        try! swapperView.swapTo(swappingViews[0].0, onComplete: nil)
        try! swapperView.swapTo(swappingViews[1].0, onComplete: nil)

        wait(for: [expectAnimatorToBeCalled], timeout: TestConfig.defaultWait)
    }

    func test_expectNoViewShownAtFirstLoad() {
        XCTAssertTrue(swapperView.subviews.isEmpty)
        XCTAssertNil(swapperView.currentView)
    }

    func test_currentView_expectNilAfterSettingSwappableViews() {
        let swappingViews = [
            ("1", UIView()),
            ("2", UIButton())
        ]

        swapperView.setSwappingViews(swappingViews)

        XCTAssertNil(swapperView.currentView)
    }

    func test_currentView_expectValueAfterSwappingView() {
        let expectOnComplete = expectation(description: "Expect onComplete")
        let swappingViews = [
            ("1", UIView()),
            ("2", UIButton())
        ]

        swapperView.setSwappingViews(swappingViews)
        try! swapperView.swapTo(swappingViews[1].0) {
            XCTAssertEqual(self.swapperView.currentView!.0, swappingViews[1].0)
            XCTAssertEqual(self.swapperView.subviews[0], swappingViews[1].1)

            expectOnComplete.fulfill()
        }

        waitForExpectations(timeout: TestConfig.defaultWait, handler: nil)
    }

    func test_swapTo_onAlreadyShownView_expectIgnoreRequest() {
        let expectAnimatorToNotBeCalled = expectation(description: "Expect swap to new view NOT to be called")
        expectAnimatorToNotBeCalled.isInverted = true
        let swappingViews = [
            ("1", UIView()),
            ("2", UIButton())
        ]
        swapperViewConfig.swapToAnimateNewView = { newView in
            expectAnimatorToNotBeCalled.fulfill()
        }
        swapperView.config = swapperViewConfig

        swapperView.setSwappingViews(swappingViews)
        try! swapperView.swapTo(swappingViews[0].0) {
            XCTAssertEqual(self.swapperView.currentView!.0, swappingViews[0].0)
            XCTAssertEqual(self.swapperView.subviews[0], swappingViews[0].1)
        }

        waitForExpectations(timeout: TestConfig.defaultWait, handler: nil)
    }

    func test_currentView_expectCorrectNil_afterSetSwappingViews_call() {
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

            XCTAssertNil(self.swapperView.currentView) // should be nil as we just set new swapping views

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
    
    func test_swapTo_throwsIfViewGone() {
        var view: UIView? = UIView()
                
        swapperView.setSwappingViews([("1", view!)])
        
        view = nil
        
        XCTAssertThrowsError(try swapperView.swapTo("1", onComplete: nil))
    }

    func test_swapTo_cancelPreviousAnimationWhenCalledSecondTime() {
        let expectLongAnimationOnCompleteToBeCalled = expectation(description: "Expect swapTo() onComplete to be called on long animation.")
        let expectShortAnimationOnCompleteToBeCalled = expectation(description: "Expect swapTo() onComplete to be called on short animation.")
        let swappingViews = [
            ("1", UIView()),
            ("2", UIView())
        ]
        let longAnimationDuration = 1.0

        swapperViewConfig.transitionAnimationDuration = longAnimationDuration
        swapperView.setSwappingViews(swappingViews)

        try! swapperView.swapTo(swappingViews[1].0) {
            expectLongAnimationOnCompleteToBeCalled.fulfill()
        }
        swapperViewConfig.transitionAnimationDuration = TestConfig.defaultAnimationDuration
        try! swapperView.swapTo(swappingViews[0].0) {
            XCTAssertEqual(self.swapperView.currentView!.0, swappingViews[0].0)

            expectShortAnimationOnCompleteToBeCalled.fulfill()
        }

        wait(for: [expectLongAnimationOnCompleteToBeCalled, expectShortAnimationOnCompleteToBeCalled], timeout: longAnimationDuration + 1, enforceOrder: true)
    }
}

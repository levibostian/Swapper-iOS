//
//  SwapperViewConfig.swift
//  Swapper
//
//  Created by Levi Bostian on 8/6/19.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import XCTest
import Swapper

class SwapperViewConfigTests: XCTestCase {

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func test_transitionAnimationDuration_above0() {
        let config = SwapperViewConfig()

        XCTAssertTrue(config.transitionAnimationDuration > 0)
    }

}

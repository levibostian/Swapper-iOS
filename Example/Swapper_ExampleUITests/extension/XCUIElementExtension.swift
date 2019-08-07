//
//  XCUIElementExtension.swift
//  Swapper
//
//  Created by Levi Bostian on 8/6/19.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

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

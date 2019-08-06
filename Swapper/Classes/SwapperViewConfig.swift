//
//  SwapperViewDefaults.swift
//  Pods
//
//  Created by Levi Bostian on 8/6/19.
//

import Foundation

/// Configuration for `SwapperView`
public class SwapperViewConfig {

    /// Singleton access to `SwapperViewConfig`.
    public static var shared: SwapperViewConfig = SwapperViewConfig()

    internal init() {
    }

    /// The background color of `SwapperView`.
    public var backgroundColor: UIColor = .white

    /// The animation duration for swapping from an old view to the new view.
    public var transitionAnimationDuration: Double = 0.3

}

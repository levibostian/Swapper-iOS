//
//  SwapperView.swift
//  Pods
//
//  Created by Levi Bostian on 8/6/19.
//

import Foundation
import UIKit

/// Views that are swappable with `SwapperView`
public typealias SwappableView = UIView

/// View that is able to swap between 1+ child views.
public class SwapperView: UIView {

    /// Access to `SwapperViewConfig` to set defaults on all instances of `SwapperView`.
    public static let defaultConfig: SwapperViewConfig = SwapperViewConfig.shared
    /// Override `defaultConfig` for this once instance.
    public var config: SwapperViewConfig? = nil {
        didSet {
            configView()
        }
    }

    private var _config: SwapperViewConfig {
        return config ?? SwapperView.defaultConfig
    }

    convenience init() {
        self.init(frame: CGRect.zero)
    }

    /// Override the animation for old view that is getting swapped out.
    public var swapToAnimateOldView: (_ oldView: UIView) -> Void = { oldView in
        oldView.alpha = 0
    }
    /// Override the animation for new view that is getting swapped in.
    public var swapToAnimateNewView: (_ newView: UIView) -> Void = { newView in
        newView.alpha = 1
    }

    override init(frame: CGRect) {
        super.init(frame: frame)

        configView()

        self.setNeedsUpdateConstraints()
    }

    private func configView() {
        self.backgroundColor = self._config.backgroundColor
    }

    /// Remove all of the previous swapping views and set new ones. The first view in the list will be shown after this function called.
    public func setSwappingViews(_ newSwappingViews: [(String, SwappableView)]) {
        self.removeAllSubviews() // Since we are changing the views, it's ok if we instantly change up what screen is shown. No need for animation.
        self.currentView = nil
        self.swappingViews = [:]

        newSwappingViews.forEach { (newSwappingViewPair) in
            let newSwappingView = newSwappingViewPair.1

            swappingViews[newSwappingViewPair.0] = newSwappingView
        }

        if !newSwappingViews.isEmpty {
            // force_try ok here since I am setting the swappingViews.
            try! self.swapTo(newSwappingViews[0].0)
        }
    }

    /// Reference the currently shown view, if it's set.
    private(set) public var currentView: (String, SwappableView)? = nil

    /// All of the views that have been added to this `SwapperView`.
    /// - Note: See `self.setSwappingViews()` to set this.
    private(set) public var swappingViews: [String: SwappableView] = [:]

    /// Remove the old view that was shown before and show the new view to the screen.
    ///
    /// - Parameter viewIndicator: View from `self.swappingViews` to swap to.
    /// - Parameter onComplete: Optional parameter to tell you when the swap animation is complete and the new view is shown.
    /// - Throws: `SwapperError.viewToSwapToDoesNotExist` If the `viewIndicator` is not found in `self.swappingViews`.
    public func swapTo(_ viewIndicator: String, onComplete: (() -> Void)? = nil) throws {
        guard let viewToSwapTo = self.swappingViews[viewIndicator] else {
            throw SwapperError.viewToSwapToDoesNotExist(viewIndicator: viewIndicator)
        }

        let isFirstViewToShow = self.subviews.isEmpty

        func setupConstraints(on view: UIView) {
            let superviewMargins = self.layoutMarginsGuide

            view.leadingAnchor.constraint(equalTo: superviewMargins.leadingAnchor).isActive = true
            view.topAnchor.constraint(equalTo: superviewMargins.topAnchor).isActive = true
            view.trailingAnchor.constraint(equalTo: superviewMargins.trailingAnchor).isActive = true
            view.bottomAnchor.constraint(equalTo: superviewMargins.bottomAnchor).isActive = true
            view.updateConstraints()
        }

        if isFirstViewToShow {
            self.addSubview(viewToSwapTo)
            self.currentView = (viewIndicator, viewToSwapTo)
            setupConstraints(on: viewToSwapTo)
        } else {
            let oldView = self.subviews[0]

            UIView.animate(withDuration: _config.transitionAnimationDuration / 2, animations: {
                self.swapToAnimateOldView(oldView)
            }) { (_) in
                self.removeAllSubviews()
                self.addSubview(viewToSwapTo)
                setupConstraints(on: viewToSwapTo)

                UIView.animate(withDuration: self._config.transitionAnimationDuration / 2, animations: {
                    self.swapToAnimateNewView(viewToSwapTo)
                }, completion: { (_) in
                    self.currentView = (viewIndicator, viewToSwapTo)

                    onComplete?()
                })
            }
        }
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

}

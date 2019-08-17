import Foundation
import UIKit

/// Views that are swappable with `SwapperView`
public typealias SwappableView = UIView

/// View that is able to swap between 1+ child views.
public class SwapperView: UIView {
    /// Access to `SwapperViewConfig` to set defaults on all instances of `SwapperView`.
    public static let defaultConfig: SwapperViewConfig = SwapperViewConfig.shared
    /// Override `defaultConfig` for this once instance.
    public var config: SwapperViewConfig? {
        didSet {
            configView()
        }
    }

    private var thread: ThreadUtil = Di.instance.threadUtil

    private var _config: SwapperViewConfig {
        return config ?? SwapperView.defaultConfig
    }

    convenience init() {
        self.init(frame: CGRect.zero)
    }

    override init(frame: CGRect) {
        super.init(frame: frame)

        configView()

        setNeedsUpdateConstraints()
    }

    private func configView() {
        backgroundColor = _config.backgroundColor
    }

    /// Remove all of the previous swapping views and set new ones. The first view in the list will be shown after this function called.
    public func setSwappingViews(_ newSwappingViews: [(String, SwappableView)]) {
        thread.assertIsMain()

        removeAllSubviews() // Since we are changing the views, it's ok if we instantly change up what screen is shown. No need for animation.
        currentView = nil
        swappingViews = [:]

        newSwappingViews.forEach { newSwappingViewPair in
            let newSwappingView = newSwappingViewPair.1

            swappingViews[newSwappingViewPair.0] = newSwappingView
        }

        if !newSwappingViews.isEmpty {
            // force_try ok here since I am setting the swappingViews.
            // Ok to put `nil` in for onComplete because this will be the first view that we add (since we removed all other subviews), this function call will be synchronous.
            try! swapTo(newSwappingViews[0].0, onComplete: nil)
        }
    }

    /// Reference the currently shown view, if it's set.
    public private(set) var currentView: (String, SwappableView)?

    /// All of the views that have been added to this `SwapperView`.
    /// - Note: See `self.setSwappingViews()` to set this.
    public private(set) var swappingViews: [String: SwappableView] = [:]

    /// Remove the old view that was shown before and show the new view to the screen.
    ///
    /// - Parameter viewIndicator: View from `self.swappingViews` to swap to.
    /// - Parameter onComplete: Optional parameter to tell you when the swap animation is complete and the new view is shown.
    /// - Throws: `SwapperError.viewToSwapToDoesNotExist` If the `viewIndicator` is not found in `self.swappingViews`.
    public func swapTo(_ viewIndicator: String, onComplete: (() -> Void)?) throws {
        thread.assertIsMain()

        guard let viewToSwapTo = self.swappingViews[viewIndicator] else {
            throw SwapperError.viewToSwapToDoesNotExist(viewIndicator: viewIndicator)
        }

        let isFirstViewToShow = subviews.isEmpty

        func setupConstraints(on view: UIView) {
            guard _config.updateAutoLayoutConstraints else {
                return
            }

            let superviewMargins = layoutMarginsGuide

            view.translatesAutoresizingMaskIntoConstraints = false
            view.leadingAnchor.constraint(equalTo: superviewMargins.leadingAnchor).isActive = true
            view.topAnchor.constraint(equalTo: superviewMargins.topAnchor).isActive = true
            view.trailingAnchor.constraint(equalTo: superviewMargins.trailingAnchor).isActive = true
            view.bottomAnchor.constraint(equalTo: superviewMargins.bottomAnchor).isActive = true
            view.updateConstraints()
        }

        if isFirstViewToShow {
            addSubview(viewToSwapTo)
            currentView = (viewIndicator, viewToSwapTo)
            setupConstraints(on: viewToSwapTo)
        } else {
            let oldView = subviews[0]

            UIView.animate(withDuration: _config.transitionAnimationDuration, animations: {
                self._config.swapToAnimateOldView(oldView)
            }, completion: { _ in
                self.removeAllSubviews()
                self.addSubview(viewToSwapTo)
                setupConstraints(on: viewToSwapTo)

                UIView.animate(withDuration: self._config.transitionAnimationDuration / 2, animations: {
                    self._config.swapToAnimateNewView(viewToSwapTo)
                }, completion: { _ in
                    self.currentView = (viewIndicator, viewToSwapTo)

                    onComplete?()
                })
            })
        }
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}

import Foundation
import UIKit

/// Views that are swappable with `SwapperView`
public typealias SwappableView = UIView

/// View that is able to swap between 1+ child views.
public class SwapperView: UIView {
    /// Access to `SwapperViewConfig` to set defaults on all instances of `SwapperView`.
    public static let defaultConfig: SwapperViewConfig = SwapperViewConfig.shared
    /// Override `defaultConfig` for this once instance.
    public var config: SwapperViewConfig = SwapperViewConfig.shared {
        didSet {
            configView()
        }
    }

    private var thread: ThreadUtil = Di.instance.threadUtil

    convenience init() {
        self.init(frame: CGRect.zero)
    }

    override init(frame: CGRect) {
        super.init(frame: frame)

        configView()

        setNeedsUpdateConstraints()
    }

    private func configView() {}

    /// Remove all of the previous swapping views and set new ones.
    public func setSwappingViews(_ newSwappingViews: [(String, SwappableView)]) {
        thread.assertIsMain()

        removeAllSubviews() // Since we are changing the views, it's ok if we instantly change up what screen is shown. No need for animation.
        currentView = nil
        swappingViews = [:]

        newSwappingViews.forEach { newSwappingViewPair in
            let newSwappingView = newSwappingViewPair.1

            swappingViews[newSwappingViewPair.0] = SwapperWeakView(newSwappingView)
        }
    }

    /// Reference the currently shown view, if it's set.
    public private(set) var currentView: (String, SwapperWeakView)?

    /// All of the views that have been added to this `SwapperView`.
    /// - Note: See `self.setSwappingViews()` to set this.
    public private(set) var swappingViews: [String: SwapperWeakView] = [:]

    /// Remove the old view that was shown before and show the new view to the screen.
    ///
    ///
    ///
    /// - Parameter viewIndicator: View from `self.swappingViews` to swap to.
    /// - Parameter animate: To animate or not.
    /// - Parameter onComplete: Optional parameter to tell you when the swap animation is complete and the new view is shown.
    /// - Throws: `SwapperError.viewToSwapToNotAdded` If the `viewIndicator` is not found in `self.swappingViews`.
    /// - Throws: `SwapperError.viewToSwapToNoLongerExists` If the `viewIndicator` no longer exists. Probably garbage collected.
    public func swapTo(_ viewIndicator: String, animate: Bool = true, onComplete: (() -> Void)?) throws {
        thread.assertIsMain()

        if currentView?.0 == viewIndicator { // the view to swap to is already being shown. Ignore.
            return
        }

        guard let weakViewToSwapTo = self.swappingViews[viewIndicator] else {
            throw SwapperError.viewToSwapToNotAdded(viewIndicator: viewIndicator)
        }
        guard let viewToSwapTo = weakViewToSwapTo.value else {
            throw SwapperError.viewToSwapToNoLongerExists(viewIndicator: viewIndicator)
        }

        func setupConstraints(on view: UIView) {
            guard config.updateAutoLayoutConstraints else {
                return
            }

            view.translatesAutoresizingMaskIntoConstraints = false
            view.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
            view.topAnchor.constraint(equalTo: topAnchor).isActive = true
            view.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
            view.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
            view.updateConstraints()
        }

        // Set currentView now, because even though it's not the current view until after the animation is done, we rely on this variable in other places so change now as it's the intended currentView.
        currentView = (viewIndicator, weakViewToSwapTo)

        let isFirstViewToShow = subviews.isEmpty
        viewToSwapTo.layer.removeAllAnimations()
        let animationDuration = config.transitionAnimationDuration

        if isFirstViewToShow || !animate || animationDuration <= 0.0 || !UIView.areAnimationsEnabled {
            removeAllSubviews()
            addSubview(viewToSwapTo)
            setupConstraints(on: viewToSwapTo)
            onComplete?()
        } else {
            let oldView = subviews[0]
            oldView.layer.removeAllAnimations()

            UIView.animate(withDuration: animationDuration, animations: {
                self.config.swapToAnimateOldView(oldView)
            }, completion: { complete in
                if complete { // if animation didn't complete, it may have been cancelled.
                    self.removeAllSubviews()
                    self.addSubview(viewToSwapTo)
                    setupConstraints(on: viewToSwapTo)

                    UIView.animate(withDuration: animationDuration, animations: {
                        self.config.swapToAnimateNewView(viewToSwapTo)
                    }, completion: { _ in
                        onComplete?()
                    })
                } else {
                    onComplete?()
                }
            })
        }
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}

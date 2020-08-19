import Foundation
import UIKit

/// Views that are swappable with `SwapperView`
public typealias SwappableView = UIView

/// Identifier for views you want to swap to.
public typealias SwapperViewIdentifier = Hashable & CustomStringConvertible

/// View that is able to swap between 1+ child views.
public class SwapperView<ViewID: SwapperViewIdentifier>: UIView {
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
    public func setSwappingViews(_ newSwappingViews: [(ViewID, SwappableView)], swapTo: ViewID?) {
        thread.assertIsMain()
        
        let isFirstTimeCalling = self.currentView == nil

        removeAllSubviews() // Since we are changing the views, it's ok if we instantly change up what screen is shown. No need for animation.
        currentView = nil
        swappingViews = [:]

        newSwappingViews.forEach { newSwappingViewPair in
            let newSwappingView = newSwappingViewPair.1

            swappingViews[newSwappingViewPair.0] = SwapperWeakView(newSwappingView)
        }
        
        if let swapTo = swapTo, self.swappingViews[swapTo] != nil {
            let animate = !isFirstTimeCalling // we only want to not animate when you first call this.
            
            try! self.swapTo(swapTo, animate: animate, onComplete: nil)
        }
    }

    /// Reference the currently shown view, if it's set.
    public private(set) var currentView: (ViewID, SwapperWeakView)?

    /// All of the views that have been added to this `SwapperView`.
    /// - Note: See `self.setSwappingViews()` to set this.
    public private(set) var swappingViews: [ViewID: SwapperWeakView] = [:]

    /// Remove the old view that was shown before and show the new view to the screen.
    ///
    /// - Parameter viewIndicator: View from `self.swappingViews` to swap to.
    /// - Parameter animate: To animate or not.
    /// - Parameter onComplete: Optional parameter to tell you when the swap animation is complete and the new view is shown.
    /// - Throws: `SwapperError.viewToSwapToNotAdded` If the `viewIndicator` is not found in `self.swappingViews`.
    /// - Throws: `SwapperError.viewToSwapToNoLongerExists` If the `viewIndicator` no longer exists. Probably garbage collected.
    public func swapTo(_ viewIndicator: ViewID, animate: Bool = true, onComplete: (() -> Void)?) throws {
        thread.assertIsMain()

        if currentView?.0 == viewIndicator { // the view to swap to is already being shown. Ignore.
            return
        }

        guard let weakViewToSwapTo = swappingViews[viewIndicator] else {
            throw SwapperError.viewToSwapToNotAdded(viewIndicator: viewIndicator.description)
        }
        guard let viewToSwapTo = weakViewToSwapTo.value else {
            throw SwapperError.viewToSwapToNoLongerExists(viewIndicator: viewIndicator.description)
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
        
        let isFirstViewToShow = self.currentView == nil

        // Set currentView now, because even though it's not the current view until after the animation is done, we rely on this variable in other places so change now as it's the intended currentView.
        currentView = (viewIndicator, weakViewToSwapTo)

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

import Foundation

/// Configuration for `SwapperView`
public class SwapperViewConfig {
    /// Singleton access to `SwapperViewConfig`.
    public static var shared: SwapperViewConfig = SwapperViewConfig()

    /// The background color of `SwapperView`.
    public var backgroundColor: UIColor = .white

    /// Create instance of `SwapperViewConfig`
    public init() {}

    /// The animation duration for swapping from an old view to the new view.
    public var transitionAnimationDuration: Double = 0.3

    /// Automatically update the AutoLayout constraints of the children `UIView`s added to `SwapperView`. `SwapperView` will set the size of the `UIView` to the same bounds that the `SwapperView` is set for so all of the children `UIViews` are the same size as the `SwapperView`.
    public var updateAutoLayoutConstraints: Bool = true

    /// Override the animation for old view that is getting swapped out.
    public var swapToAnimateOldView: (_ oldView: UIView) -> Void = { oldView in
        oldView.alpha = 0
    }

    /// Override the animation for new view that is getting swapped in.
    public var swapToAnimateNewView: (_ newView: UIView) -> Void = { newView in
        newView.alpha = 1
    }
}

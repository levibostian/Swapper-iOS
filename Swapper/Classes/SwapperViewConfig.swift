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
}

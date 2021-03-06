import Foundation
import UIKit

/**
 Container to store Views in a weak way.
 */
public class SwapperWeakView {
    /// The value held by a weak reference.
    public weak var value: UIView?

    internal init(_ value: UIView) {
        self.value = value
    }
}

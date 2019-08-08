import Foundation
import UIKit

internal extension UIView {
    func removeAllSubviews() {
        subviews.forEach { subview in
            subview.removeFromSuperview()
        }
    }
}

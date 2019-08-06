//
//  UIViewExtension.swift
//  Pods
//
//  Created by Levi Bostian on 8/6/19.
//

import Foundation
import UIKit

internal extension UIView {

    func removeAllSubviews() {
        subviews.forEach { (subview) in
            subview.removeFromSuperview()
        }
    }

}

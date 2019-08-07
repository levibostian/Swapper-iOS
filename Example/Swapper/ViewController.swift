//
//  ViewController.swift
//  Swapper
//
//  Created by Levi Bostian on 08/06/2019.
//  Copyright (c) 2019 Levi Bostian. All rights reserved.
//

import UIKit
import Swapper

enum ViewControllerSwapViews: String {
    case mtMcKinley
    case littleHill
}

class ViewController: UIViewController {

    private var didSetupConstraints = false

    let swapperView: SwapperView = {
        let view = SwapperView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.accessibilityIdentifier = AccessibilityIdentifiers.swapperView
        return view
    }()

    let mtMcKinleyImageView: UIImageView = {
        let view = UIImageView()
        view.image = #imageLiteral(resourceName: "mt_mckinley")
        view.contentMode = .scaleAspectFit
        view.translatesAutoresizingMaskIntoConstraints = false
        view.accessibilityIdentifier = AccessibilityIdentifiers.mcKinleyImage
        return view
    }()

    let littleHillImageView: UIImageView = {
        let view = UIImageView()
        view.image = #imageLiteral(resourceName: "little_hill")
        view.contentMode = .scaleAspectFit
        view.translatesAutoresizingMaskIntoConstraints = false
        view.accessibilityIdentifier = AccessibilityIdentifiers.littleHillImage
        return view
    }()

    let swapButton: UIButton = {
        let view = UIButton()
        view.setTitle("Swap!", for: .normal)
        view.setTitleColor(.blue, for: .normal)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.accessibilityIdentifier = AccessibilityIdentifiers.swapButton
        return view
    }()

    let rootView: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.distribution = .fill
        view.alignment = .center
        view.spacing = 20
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = .white

        rootView.addArrangedSubview(swapperView)
        rootView.addArrangedSubview(swapButton)
        self.view.addSubview(rootView)

        view.setNeedsUpdateConstraints()

        self.setupViews()
    }

    private func setupViews() {
        self.swapperView.setSwappingViews([
            (ViewControllerSwapViews.mtMcKinley.rawValue, mtMcKinleyImageView),
            (ViewControllerSwapViews.littleHill.rawValue, littleHillImageView)])

        self.swapButton.addTarget(self, action: #selector(swapButtonPressed), for: .touchUpInside)
    }

    @objc func swapButtonPressed() {
        var nextSwap: ViewControllerSwapViews

        switch ViewControllerSwapViews(rawValue: self.swapperView.currentView!.0)! {
        case .mtMcKinley:
            nextSwap = .littleHill
        case .littleHill:
            nextSwap = .mtMcKinley
        }

        try! self.swapperView.swapTo(nextSwap.rawValue)
    }

    override func updateViewConstraints() {
        if !didSetupConstraints {
            swapperView.heightAnchor.constraint(equalToConstant: 200).isActive = true
            swapperView.widthAnchor.constraint(equalToConstant: 200).isActive = true

            rootView.centerYAnchor.constraint(equalTo: self.view.layoutMarginsGuide.centerYAnchor).isActive = true
            rootView.centerXAnchor.constraint(equalTo: self.view.layoutMarginsGuide.centerXAnchor).isActive = true

            didSetupConstraints = true
        }

        super.updateViewConstraints()
    }

}

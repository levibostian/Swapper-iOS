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
        return view
    }()

    let mtMcKinleyImageView: UIImageView = {
        let view = UIImageView()
        view.image = #imageLiteral(resourceName: "mt_mckinley")
        view.contentMode = .scaleAspectFit
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    let littleHillImageView: UIImageView = {
        let view = UIImageView()
        view.image = #imageLiteral(resourceName: "little_hill")
        view.contentMode = .scaleAspectFit
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    let swapButton: UIButton = {
        let view = UIButton()
        view.setTitle("Swap!", for: .normal)
        view.setTitleColor(.blue, for: .normal)
        view.translatesAutoresizingMaskIntoConstraints = false
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
        // Do any additional setup after loading the view, typically from a nib.

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

        switch self.swapperView.currentView!.0 {
        case ViewControllerSwapViews.mtMcKinley.rawValue:
            nextSwap = ViewControllerSwapViews.littleHill
        case ViewControllerSwapViews.littleHill.rawValue:
            nextSwap = ViewControllerSwapViews.mtMcKinley
        default: fatalError("missing case")
        }

        try! self.swapperView.swapTo(nextSwap.rawValue)
    }

    override func updateViewConstraints() {
        if !didSetupConstraints {
            swapperView.heightAnchor.constraint(equalToConstant: 200).isActive = true
            swapperView.widthAnchor.constraint(equalToConstant: 200).isActive = true

//            rootView.leftAnchor.constraint(equalTo: self.view.layoutMarginsGuide.leftAnchor).isActive = true
//            rootView.topAnchor.constraint(equalTo: self.view.layoutMarginsGuide.topAnchor).isActive = true
//            rootView.rightAnchor.constraint(equalTo: self.view.layoutMarginsGuide.rightAnchor).isActive = true
//            rootView.bottomAnchor.constraint(equalTo: self.view.layoutMarginsGuide.bottomAnchor).isActive = true
            rootView.centerYAnchor.constraint(equalTo: self.view.layoutMarginsGuide.centerYAnchor).isActive = true
            rootView.centerXAnchor.constraint(equalTo: self.view.layoutMarginsGuide.centerXAnchor).isActive = true

            didSetupConstraints = true
        }

        super.updateViewConstraints()
    }

}

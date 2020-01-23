import Swapper
import UIKit

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
        view.accessibilityIdentifier = AccessibilityIdentifiers.mcKinleyImage
        return view
    }()

    let littleHillImageView: UIImageView = {
        let view = UIImageView()
        view.image = #imageLiteral(resourceName: "little_hill")
        view.contentMode = .scaleAspectFit
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

        view.backgroundColor = .white

        rootView.addArrangedSubview(swapperView)
        rootView.addArrangedSubview(swapButton)
        view.addSubview(rootView)

        view.setNeedsUpdateConstraints()

        setupViews()
    }

    private func setupViews() {
        swapperView.setSwappingViews([
            (ViewControllerSwapViews.mtMcKinley.rawValue, mtMcKinleyImageView),
            (ViewControllerSwapViews.littleHill.rawValue, littleHillImageView)
        ])

        swapButton.addTarget(self, action: #selector(swapButtonPressed), for: .touchUpInside)
    }

    @objc func swapButtonPressed() {
        var nextSwap: ViewControllerSwapViews

        switch ViewControllerSwapViews(rawValue: swapperView.currentView!.0)! {
        case .mtMcKinley:
            nextSwap = .littleHill
        case .littleHill:
            nextSwap = .mtMcKinley
        }

        try! swapperView.swapTo(nextSwap.rawValue, onComplete: nil)
    }

    override func updateViewConstraints() {
        if !didSetupConstraints {
            swapperView.heightAnchor.constraint(equalToConstant: 200).isActive = true
            swapperView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
            swapperView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true

            rootView.centerYAnchor.constraint(equalTo: view.layoutMarginsGuide.centerYAnchor).isActive = true
            rootView.centerXAnchor.constraint(equalTo: view.layoutMarginsGuide.centerXAnchor).isActive = true

            didSetupConstraints = true
        }

        super.updateViewConstraints()
    }
}

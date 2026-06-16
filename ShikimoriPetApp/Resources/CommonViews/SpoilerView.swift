import UIKit
import SnapKit

final class SpoilerView: UIView {

    var onToggle: (() -> Void)?

    private let stack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 4
        stack.alignment = .fill
        return stack
    }()

    private let toggleButton: UIButton = {
        let button = UIButton(type: .system)
        button.contentHorizontalAlignment = .left
        button.titleLabel?.font = .systemFont(ofSize: 14, weight: .medium)
        button.tintColor = .systemBlue
        return button
    }()

    private let bodyLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textColor = .textColor
        label.font = .systemFont(ofSize: 14)
        label.isHidden = true
        return label
    }()

    private var isExpanded = false
    private var spoilerTitle = "Спойлер"

    init(title: String, body: String) {
        super.init(frame: .zero)
        spoilerTitle = title.isEmpty ? "Спойлер" : title
        bodyLabel.text = body
        setupUI()
        updateButton()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(title: String, body: String) {
        spoilerTitle = title.isEmpty ? "Спойлер" : title
        bodyLabel.text = body
        updateButton()
    }

    private func setupUI() {
        addSubview(stack)
        stack.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        stack.addArrangedSubview(toggleButton)
        stack.addArrangedSubview(bodyLabel)

        toggleButton.addTarget(self, action: #selector(toggle), for: .touchUpInside)
    }

    private func updateButton() {
        let arrow = isExpanded ? "▼" : "▶"
        toggleButton.setTitle("\(arrow) \(spoilerTitle)", for: .normal)
    }

    @objc private func toggle() {
        isExpanded.toggle()
        UIView.animate(withDuration: 0.2) {
            self.bodyLabel.isHidden = !self.isExpanded
        }
        updateButton()
        onToggle?()
    }
}

import UIKit
import SnapKit

class CommentInputCell: UITableViewCell {
    static let identifier = "CommentInputCell"

    var onSend: ((String, Int?) -> Void)?
    var onCancelReply: (() -> Void)?
    var onHeightChanged: (() -> Void)?

    private var replyToId: Int?

    // Reply banner
    private let replyBanner: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.alignment = .center
        stack.spacing = 8
        stack.isHidden = true
        stack.layoutMargins = UIEdgeInsets(top: 0, left: 14, bottom: 0, right: 12)
        stack.isLayoutMarginsRelativeArrangement = true
        return stack
    }()

    private let replyIndicator: UIView = {
        let view = UIView()
        view.backgroundColor = .systemBlue
        view.layer.cornerRadius = 1.5
        return view
    }()

    private let replyLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12, weight: .medium)
        label.textColor = .systemBlue
        label.setContentHuggingPriority(.defaultLow, for: .horizontal)
        return label
    }()

    private let cancelReplyButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "xmark"), for: .normal)
        button.tintColor = .secondaryLabel
        return button
    }()

    // Input row
    private let inputContainer: UIView = {
        let view = UIView()
        return view
    }()

    private let textField: UITextField = {
        let field = UITextField()
        field.placeholder = "Написать комментарий..."
        field.font = .systemFont(ofSize: 15)
        field.textColor = .textColor
        field.tintColor = .systemBlue
        field.backgroundColor = .clear
        field.returnKeyType = .send
        return field
    }()

    private let sendButton: UIButton = {
        let button = UIButton(type: .system)
        let config = UIImage.SymbolConfiguration(pointSize: 18, weight: .semibold)
        button.setImage(UIImage(systemName: "arrow.up.circle.fill", withConfiguration: config), for: .normal)
        button.tintColor = .systemBlue.withAlphaComponent(0.3)
        button.isEnabled = false
        return button
    }()

    private let divider: UIView = {
        let view = UIView()
        view.backgroundColor = .separator
        return view
    }()

    private let outerStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 0
        return stack
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
        setupTargets()
    }

    required init?(coder: NSCoder) {
        fatalError()
    }

    private func setupUI() {
        selectionStyle = .none
        backgroundColor = .bubbleBackground
        contentView.backgroundColor = .bubbleBackground

        // Reply banner subviews
        replyIndicator.snp.makeConstraints { make in
            make.width.equalTo(3)
            make.height.equalTo(16)
        }
        replyBanner.addArrangedSubview(replyIndicator)
        replyBanner.addArrangedSubview(replyLabel)
        replyBanner.addArrangedSubview(cancelReplyButton)
        cancelReplyButton.snp.makeConstraints { make in
            make.width.height.equalTo(28)
        }
        replyBanner.snp.makeConstraints { make in
            make.height.equalTo(32)
        }

        // Input row
        inputContainer.addSubview(divider)
        divider.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.height.equalTo(0.5)
        }
        inputContainer.addSubview(textField)
        inputContainer.addSubview(sendButton)
        sendButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(12)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(36)
        }
        textField.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalTo(sendButton.snp.leading).offset(-8)
            make.top.bottom.equalToSuperview()
        }
        inputContainer.snp.makeConstraints { make in
            make.height.equalTo(48)
        }

        outerStack.addArrangedSubview(replyBanner)
        outerStack.addArrangedSubview(inputContainer)
        contentView.addSubview(outerStack)
        outerStack.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }

    private func setupTargets() {
        sendButton.addTarget(self, action: #selector(didTapSend), for: .touchUpInside)
        cancelReplyButton.addTarget(self, action: #selector(didCancelReply), for: .touchUpInside)
        textField.addTarget(self, action: #selector(textChanged), for: .editingChanged)
        textField.delegate = self
    }

    func setReply(to nickname: String, commentId: Int) {
        replyToId = commentId
        replyLabel.text = "Ответ для @\(nickname)"
        replyBanner.isHidden = false
        onHeightChanged?()
        textField.becomeFirstResponder()
    }

    func clearReply() {
        replyToId = nil
        replyLabel.text = nil
        replyBanner.isHidden = true
        onHeightChanged?()
    }

    func focusInput() {
        textField.becomeFirstResponder()
    }

    @objc private func textChanged() {
        let hasText = !(textField.text?.trimmingCharacters(in: .whitespaces).isEmpty ?? true)
        sendButton.isEnabled = hasText
        sendButton.tintColor = hasText ? .systemBlue : .systemBlue.withAlphaComponent(0.3)
    }

    @objc private func didTapSend() {
        guard let text = textField.text, !text.trimmingCharacters(in: .whitespaces).isEmpty else { return }
        onSend?(text, replyToId)
        textField.text = nil
        textChanged()
        clearReply()
        textField.resignFirstResponder()
    }

    @objc private func didCancelReply() {
        clearReply()
        onCancelReply?()
    }
}

extension CommentInputCell: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        didTapSend()
        return true
    }
}

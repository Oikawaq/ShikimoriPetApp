//
//  ProfileCommentsCell.swift
//  ShikimoriPetApp
//
//  Created by Иван Илькив on 5/8/26.
//

import UIKit
import SnapKit
import Kingfisher

class UniversalCommentsCell: UITableViewCell {
    static let identifier: String = "CommentsCell"
    private var userId: Int?
    private var commentId: Int?
    var isUserTapped: ((Int) -> Void)?
    var isImageTapped: (([URL], Int) -> Void)?
    var onSpoilerToggle: (() -> Void)?
    var onYoutubeTapped: ((String) -> Void)?
    var onReplyTapped: ((Int, String) -> Void)?
    private var imageUrls: [URL] = []

    private let avatarImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.isUserInteractionEnabled = true
        iv.layer.cornerRadius = 20
        return iv
    }()

    // Header row: username + reply button
    private let headerRow: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.alignment = .center
        stack.spacing = 8
        return stack
    }()

    private let userNameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .textColor
        label.font = .systemFont(ofSize: 14, weight: .semibold)
        label.setContentHuggingPriority(.defaultLow, for: .horizontal)
        label.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        return label
    }()

    private let replyButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Ответить", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 12)
        button.tintColor = .secondaryLabel
        button.setContentHuggingPriority(.required, for: .horizontal)
        button.setContentCompressionResistancePriority(.required, for: .horizontal)
        return button
    }()

    private let contentStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 6
        stack.alignment = .fill
        return stack
    }()

    private let rightColumn: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 4
        stack.alignment = .fill
        return stack
    }()

    private let container: UIView = UIView()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
        setupTargets()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        imageUrls = []
        userId = nil
        commentId = nil
        contentStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
    }

    private func setupUI() {
        selectionStyle = .none
        backgroundColor = .bubbleBackground

        contentView.addSubview(container)
        container.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(UIEdgeInsets(top: 10, left: 14, bottom: 10, right: 14))
        }

        headerRow.addArrangedSubview(userNameLabel)
        headerRow.addArrangedSubview(replyButton)

        rightColumn.addArrangedSubview(headerRow)
        rightColumn.addArrangedSubview(contentStackView)

        container.addSubview(avatarImageView)
        container.addSubview(rightColumn)

        avatarImageView.snp.makeConstraints { make in
            make.leading.top.equalToSuperview()
            make.width.height.equalTo(40)
        }
        rightColumn.snp.makeConstraints { make in
            make.leading.equalTo(avatarImageView.snp.trailing).offset(10)
            make.top.trailing.bottom.equalToSuperview()
        }
    }

    private func setupTargets() {
        let userTap = UITapGestureRecognizer(target: self, action: #selector(onUserTapped))
        avatarImageView.addGestureRecognizer(userTap)
        replyButton.addTarget(self, action: #selector(onReplyButtonTapped), for: .touchUpInside)
    }

    @objc private func onReplyButtonTapped() {
        guard let cid = commentId else { return }
        onReplyTapped?(cid, userNameLabel.text ?? "")
    }

    @objc private func onUserTapped() {
        guard let id = userId else { return }
        isUserTapped?(id)
    }

    func configure(with comments: CommentsModel) {
        imageUrls = []
        contentStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        guard let imageUrl = comments.user.image?.x48 else { return }
        avatarImageView.kf.setImage(with: URL(string: imageUrl))
        userId = comments.user.id
        commentId = comments.id
        userNameLabel.text = comments.user.nickname

        let segments = comments.body.parseCommentSegments()
        for segment in segments {
            switch segment {
            case .text(let text):
                contentStackView.addArrangedSubview(makeTextLabel(text: text))
            case .spoiler(let title, let body):
                let spoilerView = SpoilerView(title: title, body: body)
                spoilerView.configure(title: title, body: body)
                spoilerView.onToggle = { [weak self] in self?.onSpoilerToggle?() }
                contentStackView.addArrangedSubview(spoilerView)
            case .youtube(let videoId):
                addYoutubePreview(videoId: videoId)
            case .image(let urlString):
                guard let url = URL(string: urlString) else { continue }
                let index = imageUrls.count
                imageUrls.append(url)
                addImagePreview(url: url, index: index)
            }
        }
    }

    private func addYoutubePreview(videoId: String) {
        let preview = YouTubePreviewView()
        preview.configure(videoId: videoId)
        preview.onTap = { [weak self] id in self?.onYoutubeTapped?(id) }
        contentStackView.addArrangedSubview(preview)
    }

    private func addImagePreview(url: URL, index: Int) {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.clipsToBounds = true
        iv.layer.cornerRadius = 8
        iv.isUserInteractionEnabled = true
        iv.kf.setImage(with: url)
        iv.tag = index
        let tap = UITapGestureRecognizer(target: self, action: #selector(onImageTapped(_:)))
        iv.addGestureRecognizer(tap)
        contentStackView.addArrangedSubview(iv)
        iv.snp.makeConstraints { make in
            make.height.lessThanOrEqualTo(260)
        }
    }

    @objc private func onImageTapped(_ gesture: UITapGestureRecognizer) {
        let index = gesture.view?.tag ?? 0
        isImageTapped?(imageUrls, index)
    }

    private func makeTextLabel(text: String) -> UILabel {
        let label = UILabel()
        label.text = text
        label.textColor = .textColor
        label.textAlignment = .left
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 14)
        return label
    }
}

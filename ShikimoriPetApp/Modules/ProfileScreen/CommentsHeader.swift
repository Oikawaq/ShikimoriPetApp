//
//  CommentsHeader.swift
//  ShikimoriPetApp
//
//  Created by Иван Илькив on 5/13/26.
//

import UIKit
import SnapKit

class CommentsHeader: UITableViewCell {
    static let identifier = "CommentsHeader"
    var onShowAllButtonTapped: (() -> Void)?
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        label.textColor = .textColor
        label.text = L10n.categories.comments
        return label
    }()
    private let showAllButton: UIButton = {
        let button = UIButton()
        button.setTitle("Показать больше комментариев", for: .normal)
        button.tintColor = .textColor
        button.titleLabel?.textAlignment = .left
        button.isUserInteractionEnabled = true
        button.backgroundColor = .background.withAlphaComponent(0.5)
        button.layer.cornerRadius = 8
        return button
    }()
    private let stackView: UIStackView = {
       let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 8
        return stack
    }()
    private func addTargets(){
        showAllButton.addTarget(self, action: #selector(showAllButtonTapped), for: .touchUpInside)
    }
    @objc private func showAllButtonTapped(){
        onShowAllButtonTapped?()
    }
    override func layoutSubviews() {
        separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: .greatestFiniteMagnitude)
    }
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(stackView)
        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(showAllButton)
        addTargets()
        backgroundColor = .bubbleBackground
        selectionStyle = .none
        separatorInset = .zero
        stackView.snp.makeConstraints{
            $0.edges.equalToSuperview().inset(16)
        }
    }
    func configure(canLoadMore: Bool){
        showAllButton.isHidden = !canLoadMore
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

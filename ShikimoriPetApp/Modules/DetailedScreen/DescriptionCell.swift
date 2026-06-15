//
//  DescriptionCell.swift
//  ShikimoriPetApp
//
//  Created by Иван Илькив on 4/14/26.
//

import UIKit
import SnapKit

class DescriptionCell: UITableViewCell {
    static let identifier: String = "DescriptionCell"
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.text = L10n.categories.description
        label.textColor = .textColor
        return label
    }()
    var onCharacterTapped: ((String)->Void)?

    let descriptionTextView = UITextView()
    
        //MARK: init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
        selectionStyle = .none
        descriptionTextView.isUserInteractionEnabled = true
        contentView.isUserInteractionEnabled = true
        descriptionTextView.isEditable = false
        descriptionTextView.isSelectable = true
        descriptionTextView.dataDetectorTypes = []
        descriptionTextView.delegate = self
        descriptionTextView.isScrollEnabled = false
        descriptionTextView.backgroundColor = .clear
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    private func setupUI() {
        self.selectionStyle = .none
        backgroundColor = .bubbleBackground
        contentView.addSubview(titleLabel)
        contentView.addSubview(descriptionTextView)
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(12)
            make.leading.equalToSuperview().inset(16)
        }
        descriptionTextView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(8)
            make.leading.trailing.equalToSuperview().inset(16)
            make.bottom.equalToSuperview().inset(12)
        }
    }
    func configure(with desc: NSAttributedString){
       let mutable = NSMutableAttributedString(attributedString: desc)
        let range = NSRange(location: 0, length: mutable.length)
        mutable.addAttribute(.foregroundColor, value: UIColor.textColor, range: range)
        mutable.addAttribute(.font, value: UIFont.systemFont(ofSize: 14), range: range)
        descriptionTextView.attributedText = mutable

    }
}
extension DescriptionCell: UITextViewDelegate {
    func textView(_ textView: UITextView, primaryActionFor textItem: UITextItem, defaultAction: UIAction) -> UIAction? {
        if case .link(let url) = textItem.content, url.scheme == "character" {
            let id = url.host ?? ""
            return UIAction { [weak self] _ in
                print("characterId from DescriptionCell : \(id)")
                self?.onCharacterTapped?(id)
            }
        }
        return defaultAction
    }
}

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
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textAlignment = .left
        label.textColor = .textColor
        return label
    }()
    
    
        //MARK: init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    private func setupUI() {
        self.selectionStyle = .none
        backgroundColor = .bubbleBackground
        addSubview(titleLabel)
        addSubview(descriptionLabel)
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(12)
            make.leading.equalToSuperview().inset(16)
        }
        descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(8)
            make.leading.trailing.equalToSuperview().inset(16)
            make.bottom.equalToSuperview().inset(12)
        }
    }
    func configure(with desc: String){
        descriptionLabel.text = desc
    }
}

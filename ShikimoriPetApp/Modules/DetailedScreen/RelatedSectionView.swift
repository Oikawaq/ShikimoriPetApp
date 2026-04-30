//
//  AuthorsCell.swift
//  ShikimoriPetApp
//
//  Created by Иван Илькив on 4/14/26.
//

import UIKit
import SnapKit

class RelatedCell: UITableViewCell {
    static let identifier: String = "RelatedCell"
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .textColor
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.text = L10n.categories.related
        return label
    }()
    private let relatedSectionView = ListSectionView()
    //MARK: init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    private func setupUI(){
        self.selectionStyle = .none
        backgroundColor = .bubbleBackground
        addSubview(titleLabel)
        addSubview(relatedSectionView)
        titleLabel.snp.makeConstraints { make in
            make.top.leading.equalToSuperview().inset(16)
            
        }
        relatedSectionView.snp.makeConstraints{make in
            make.top.equalTo(titleLabel.snp.bottom).offset(12)
            make.leading.trailing.equalToSuperview().inset(16)
            make.bottom.equalToSuperview().inset(12)
        }
    }
    func configure(with data: [ListSectionView.RowData]){
        relatedSectionView.configure(with: data)
    }
}

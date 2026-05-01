//
//  AuthorsCell.swift
//  ShikimoriPetApp
//
//  Created by Иван Илькив on 4/14/26.
//

import UIKit
import SnapKit

class UniversalRowDataCell: UITableViewCell {
    static let identifier: String = "RowDataCell"
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .textColor
        label.font = UIFont.boldSystemFont(ofSize: 16)
        return label
    }()
    private let authorsSectionView = ListSectionView()
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
        addSubview(authorsSectionView)
        titleLabel.snp.makeConstraints { make in
            make.top.leading.equalToSuperview().inset(16)
            
        }
        authorsSectionView.snp.makeConstraints{make in
            make.top.equalTo(titleLabel.snp.bottom).offset(12)
            make.leading.trailing.equalToSuperview().inset(16)
            make.bottom.equalToSuperview().inset(12)
        }
    }
    func configure(with data: [ListSectionView.RowData], sectionName: String){
        authorsSectionView.configure(with: data)
        titleLabel.text = sectionName
    }
}

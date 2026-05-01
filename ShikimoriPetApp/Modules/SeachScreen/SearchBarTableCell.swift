//
//  AuthorsCell.swift
//  ShikimoriPetApp
//
//  Created by Иван Илькив on 4/14/26.
//

import UIKit
import SnapKit

class SearchBarTableCell: UITableViewCell {
    static let identifier: String = "SearchBarTableCell"

    private let authorsSectionView = SectionViewSearch()
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
        addSubview(authorsSectionView)
        authorsSectionView.snp.makeConstraints{make in
            make.top.equalToSuperview().offset(12)
            make.leading.trailing.equalToSuperview().inset(16)
            make.bottom.equalToSuperview().inset(12)
        }
    }
    func configure(with data: SectionViewSearch.RowData){
        authorsSectionView.configure(with: data)
    }
}

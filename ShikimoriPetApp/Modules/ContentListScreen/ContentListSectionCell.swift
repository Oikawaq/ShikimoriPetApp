//
//  ContentListSectionCell.swift
//  ShikimoriPetApp
//
//  Created by Иван Илькив on 4/6/26.
//

import Foundation
import UIKit
import SnapKit

class ContentListSectionCell: UITableViewCell{
    static let identifier: String = "ContentListSectionCell"
        private let numberLabel = UILabel()
        private let titleLabel = UILabel()
        private let scoreLabel = UILabel()

        
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
            super.init(style: style, reuseIdentifier: reuseIdentifier)
            backgroundColor = .systemGray6
            let stack = UIStackView(arrangedSubviews: [
                numberLabel, titleLabel, scoreLabel
            ])
            stack.axis = .horizontal
            stack.distribution = .fill
            stack.spacing = 4
            stack.backgroundColor = .systemGray6
            contentView.addSubview(stack)
            stack.snp.makeConstraints {
                $0.bottom.top.equalToSuperview().inset(8)
                $0.leading.trailing.equalToSuperview().inset(16)
            }

            titleLabel.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
            numberLabel.setContentHuggingPriority(.required, for: .horizontal)
            scoreLabel.setContentHuggingPriority(.required, for: .horizontal)
        
            scoreLabel.textColor = .chalkWhite
            titleLabel.textColor = .chalkWhite
            numberLabel.textColor = .chalkWhite.withAlphaComponent(0.5)
        }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with item: UserContentListModel?,number: Int) {
        resetToDefault()
        
        numberLabel.text = "\(number)"
        titleLabel.text = item?.anime?.russian
        if item?.score == 0 {
            scoreLabel.text = ""
        }else{
            scoreLabel.text = "\(item?.score ?? 0)"
        }
        
        }
    private func resetToDefault(){
        
        numberLabel.isHidden = false
        scoreLabel.isHidden = false
        titleLabel.font = .systemFont(ofSize: 14, weight: .regular)
    }
    func configureHeader(with title: String){

        titleLabel.text = title
        titleLabel.font = .systemFont(ofSize: 20, weight: .bold)
        scoreLabel.isHidden = true
        numberLabel.isHidden = true
    }
    }

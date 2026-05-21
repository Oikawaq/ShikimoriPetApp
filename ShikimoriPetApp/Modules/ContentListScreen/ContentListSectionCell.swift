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
    private let stack : UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.distribution = .fill
        stack.spacing = 4
        stack.backgroundColor = .bubbleBackground
        return stack
    }()
    private var id: Int?
    var isStacktapped : ((Int)-> Void)?
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
            super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupTargets()

        [numberLabel,titleLabel,scoreLabel].forEach{stack.addArrangedSubview($0)}
        
        backgroundColor = .bubbleBackground
        selectionStyle = .none
            
            contentView.addSubview(stack)
            stack.snp.makeConstraints {
                $0.edges.equalToSuperview().inset(8)
            }

            titleLabel.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
            numberLabel.setContentHuggingPriority(.required, for: .horizontal)
            scoreLabel.setContentHuggingPriority(.required, for: .horizontal)
            
            titleLabel.numberOfLines = 0
            titleLabel.font = Fonts.categoriesFont.fonts()
            scoreLabel.textColor = .textColor
            titleLabel.textColor = .textColor
        numberLabel.textColor = .textColor.withAlphaComponent(0.5)
        numberLabel.font = .systemFont(ofSize: 12 )
        }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    private func setupTargets(){
        let tap = UITapGestureRecognizer(target: self, action: #selector(onStackTapped))
        stack.addGestureRecognizer(tap)
    }
    @objc private func onStackTapped(){
        guard let id = id else {return}
        isStacktapped?(id)
        print(id)
    }
    func configure(with item: UserContentListModel?,number: Int) {
        resetToDefault()
        id = item?.id
        numberLabel.text = "\(number)"
        titleLabel.text = item?.anime?.russian ?? item?.manga?.russian
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

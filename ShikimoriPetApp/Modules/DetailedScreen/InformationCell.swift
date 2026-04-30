//
//  InformationCell.swift
//  ShikimoriPetApp
//
//  Created by Иван Илькив on 4/13/26.
//


import UIKit
import SnapKit

class InformationCell: UITableViewCell {
    static let identifier = "InformationCell"
    
    private let headerLabel: UILabel = {
        let label = UILabel()
        label.font = Fonts.categoriesFont.fonts()
        label.textColor = .textColor
        label.text = L10n.categories.information
        return label
    }()
    private let infoStackView: UIStackView = {
            let stack = UIStackView()
            stack.axis = .vertical
            stack.spacing = 10
            return stack
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .bubbleBackground
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    private func setupUI(){
        self.selectionStyle = .none
        addSubview(headerLabel)
        addSubview(infoStackView)
        
        headerLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(12)
            make.leading.equalToSuperview().inset(16)
        }
        infoStackView.snp.makeConstraints { make in
            make.top.equalTo(headerLabel.snp.bottom).offset(8)
            make.bottom.equalToSuperview().inset(12)
            make.leading.equalToSuperview().offset(16)
        }
    }
    func configureInfoBlock(with details: [(key: String, value: String)]) {
         infoStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
         
         details.forEach { item in
             let row = createInfoRow(title: item.key, value: item.value)

             infoStackView.addArrangedSubview(row)
         }
     }
    private func createInfoRow(title: String, value: String?) -> UIView {
            let view = UIView()
            let keyLabel = UILabel()
            keyLabel.text = title
            keyLabel.textColor = .textColor
            keyLabel.font = .systemFont(ofSize: 14)

            let valueLabel = UILabel()
            valueLabel.text = value

            valueLabel.textColor = .textColor
            valueLabel.font = .systemFont(ofSize: 14, weight: .medium)
            valueLabel.numberOfLines = 0
            
            view.addSubview(keyLabel)
            view.addSubview(valueLabel)
            
            keyLabel.snp.makeConstraints { make in
                make.leading.top.bottom.equalToSuperview()
                make.width.equalTo(150)
            }
            
            valueLabel.snp.makeConstraints { make in
                make.leading.equalTo(keyLabel.snp.trailing).offset(8)
                make.trailing.top.bottom.equalToSuperview()
            }
            
            return view
        }
}

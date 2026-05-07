//
//  SideMenuHeader.swift
//  ShikimoriPetApp
//
//  Created by Иван Илькив on 5/6/26.
//

import UIKit
import SnapKit

final class SideMenuHeader: UITableViewCell{
    static let identifier: String = "SideMenuHeader"
    private var label: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18, weight: .bold)
        return label
    }()
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    private func setupUI(){
        contentView.addSubview(label)
        backgroundColor = .background
        label.snp.makeConstraints { make in
            make.top.equalTo(contentView)
            make.leading.trailing.equalTo(contentView).inset(4)
            make.bottom.equalTo(contentView).inset(10)
            
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func configure(with title: String) {
        label.text = title
    }
}

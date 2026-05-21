//
//  UserInfoCell.swift
//  ShikimoriPetApp
//
//  Created by Иван Илькив on 5/7/26.
//

import UIKit
import SnapKit
import Kingfisher

class UserInfoCell: UITableViewCell{
    static let identifier: String = "UserInfoCell"
    
    private let image : UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 8
        imageView.clipsToBounds = true
        imageView.backgroundColor = .clear
        return imageView
    }()
    private let userNameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 18)
        return label
    }()
    private let userAgeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        return label
    }()
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI(){
        contentView.addSubview(image)
        contentView.addSubview(userNameLabel)
        contentView.addSubview(userAgeLabel)
        
        contentView.backgroundColor = .bubbleBackground
        image.snp.makeConstraints { make in
            make.top.leading.equalToSuperview().offset(16)
            make.bottom.equalToSuperview().inset(16)
            make.height.equalTo(200).priority(999)
            make.width.equalTo(200)
        }
        userNameLabel.snp.makeConstraints { make in
            make.top.equalTo(image.snp.top)
            make.leading.equalTo(image.snp.trailing).offset(16)
            
        }
        userAgeLabel.snp.makeConstraints { make in
            make.top.equalTo(userNameLabel.snp.bottom).offset(16)
            make.leading.equalTo(userNameLabel.snp.leading)
        }
        
    }
    func configure(with userInfo: UserHeaderInfo){
        guard let url = userInfo.imageURL else {return}
        image.kf.setImage(with: url)
        
        userNameLabel.text = userInfo.userName
        userAgeLabel.text = userInfo.userAge
    }
}

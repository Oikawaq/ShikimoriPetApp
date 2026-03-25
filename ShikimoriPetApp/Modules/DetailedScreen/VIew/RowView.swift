//
//  AuthorRowView.swift
//  ShikimoriPetApp
//
//  Created by Иван Илькив on 3/10/26.
//

import UIKit
import SnapKit
import Kingfisher

final class RowView: UIView {
    private let avatarImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.layer.cornerRadius = 4
        iv.clipsToBounds = true
        iv.backgroundColor = .systemGray6
        return iv
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .bold)
        label.textColor = .basalt
        return label
    }()
    
    private let roleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12, weight: .regular)
        label.textColor = .secondaryLabel
        return label
    }()

    init(name: String, role: String, imageUrl: String?) {
        super.init(frame: .zero)
        nameLabel.text = name
        roleLabel.text = role
        if let imageUrlString = imageUrl,
           let url = URL(string: "https://shikimori.io" + imageUrlString) {
            avatarImageView.kf.setImage(
                with: url,
                placeholder: UIImage(named: "placeholder"),
                options: [
                    .transition(.fade(0.3)),
                    .cacheOriginalImage
                ]
            )
        }else{
            avatarImageView.image = nil
        }
        setupLayout()
    }

    private func setupLayout() {
        addSubview(avatarImageView)
        let textStack = UIStackView(arrangedSubviews: [nameLabel, roleLabel])
        textStack.axis = .vertical
        textStack.spacing = 2
        addSubview(textStack)
        avatarImageView.snp.makeConstraints { make in
            make.leading.top.bottom.equalToSuperview().inset(8)
            make.width.equalTo(40)
            make.height.equalTo(60) 
        }
        
        textStack.snp.makeConstraints { make in
            make.leading.equalTo(avatarImageView.snp.trailing).offset(12)
            make.top.equalTo(avatarImageView)
            make.trailing.equalToSuperview().inset(8)
        }
    }
    required init?(coder: NSCoder) { fatalError() }
}

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
        return iv
    }()
    private let scoreLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18, weight: .bold)
        label.textColor = .textColor
        label.isHidden = true
        return label
    }()
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .bold)
        label.textColor = .textColor

        return label
    }()

    private let roleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12, weight: .regular)
        label.textColor = .textColor.withAlphaComponent(0.5)
        return label
    }()

    init(name: String, role: String, imageUrl: String?, score: String? = "", isSearching: Bool = false) {
        super.init(frame: .zero)
        nameLabel.text = name
        roleLabel.text = role
        let baseUrl = "https://shikimori.io"
        var finalString = ""
        
        if let imageUrlTest = imageUrl{
            if imageUrlTest.hasPrefix("http"){
                finalString = imageUrlTest
            } else if imageUrlTest.hasPrefix("/"){
                finalString = baseUrl + imageUrlTest
            }
        }
        
           if let url = URL(string: finalString) {
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
        if isSearching{
            scoreLabel.isHidden = false
            scoreLabel.text = score
        }
        setupLayout()
    }
    
    private func setupLayout() {
        addSubview(avatarImageView)
        addSubview(scoreLabel)
        let textStack = UIStackView(arrangedSubviews: [nameLabel, roleLabel])
        textStack.axis = .vertical
        textStack.spacing = 2
        addSubview(textStack)
        avatarImageView.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().inset(8)
            make.leading.equalToSuperview()
            make.width.equalTo(48)
            make.height.equalTo(72) 
        }
        
        textStack.snp.makeConstraints { make in
            make.leading.equalTo(avatarImageView.snp.trailing).offset(12)
            make.top.equalTo(avatarImageView)
            make.trailing.equalToSuperview().inset(8)
        }
        scoreLabel.snp.makeConstraints { make in
            make.leading.equalTo(avatarImageView.snp.trailing).offset(12)
            make.bottom.equalTo(avatarImageView.snp.bottom)
        }
    }
    required init?(coder: NSCoder) { fatalError() }
}

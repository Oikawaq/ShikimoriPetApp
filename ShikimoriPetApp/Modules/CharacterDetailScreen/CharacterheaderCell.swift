//
//  PosterImageCell.swift
//  ShikimoriPetApp
//
//  Created by Иван Илькив on 4/9/26.
//


import UIKit
import SnapKit
import Kingfisher

class CharacterheaderCell: UITableViewCell {
    static let identifier = "HeaderCell"
    var onFavoriteTapped: (() -> Void)?
    private let characterName: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18, weight: .semibold)
        label.textColor = .textColor
        label.numberOfLines = 0
        return label
    }()
    let favoritesButton: UIButton = {
           let button = UIButton()
           let image = UIImage(systemName: "star")
           button.setImage(image, for: .normal)
           button.tintColor = .white
           return button
       }()
    private let image : UIImageView = {
        let imageView = UIImageView()
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 8
        return imageView
    }()


        //MARK: init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .bubbleBackground
        addsViews()
        setupUI()
        setupActions()
        self.selectionStyle = .none
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc private func favoriteTapped(){
        onFavoriteTapped?()
    }
    private func setupActions(){
        favoritesButton.addTarget(self, action: #selector(favoriteTapped), for: .touchUpInside)
    }
    private func addsViews(){
        [characterName,image,favoritesButton].forEach{
            contentView.addSubview($0)
        }
    }
    private func setupUI(){
        characterName.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(12)
            make.leading.trailing.equalToSuperview().inset(12)
        }
        image.snp.makeConstraints { make in
            make.top.equalTo(characterName.snp.bottom).offset(16)
            make.height.equalTo(450)
            make.width.equalTo(300)
            make.leading.equalToSuperview().offset(16)
            make.bottom.equalToSuperview().inset(12)
        }
        favoritesButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(16)
            make.top.equalTo(image)
        }
    }

    private func createTagLabel(text: String, color: UIColor) -> UILabel {
          let label = UILabel()
          label.text = text
          label.font = .systemFont(ofSize: 12, weight: .bold)
          label.textColor = .chalkWhite
          label.backgroundColor = color
          label.textAlignment = .center
          label.layer.cornerRadius = 6
          label.clipsToBounds = true
          
          label.snp.makeConstraints { make in
              make.width.greaterThanOrEqualTo(label.intrinsicContentSize.width + 20)
              make.height.equalTo(24)
          }
          return label
      }
        //MARK: configure
    func configure(with data: CharacterHeaderModel) {
        characterName.text = data.name
        image.kf.setImage(with: data.imageURL)

        if data.isFavorite {
            favoritesButton.setImage(UIImage(systemName: "star.fill"), for: .normal)
        }else{
            favoritesButton.setImage(UIImage(systemName: "star"), for: .normal)
        }
        
    }
}

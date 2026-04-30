//
//  PosterImageCell.swift
//  ShikimoriPetApp
//
//  Created by Иван Илькив on 4/9/26.
//


import UIKit
import SnapKit
import Kingfisher

class HeaderCell: UITableViewCell {
    static let identifier = "HeaderCell"
    var onFavoriteTapped: (() -> Void)?
    var onUserRateTapped: (() -> Void)?
    private let titleNameLabel: UILabel = {
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
    
    private let ratingBlock = RatingBlockView()
    private let tagsStackView: UIStackView = {
           let stack = UIStackView()
           stack.axis = .horizontal
           stack.spacing = 8
           stack.alignment = .leading
           stack.distribution = .fill
           return stack
       }()
    private let userRateStatusButton: UIButton = {
         let button = UIButton()
         button.backgroundColor = .background
         button.titleLabel?.font = .systemFont(ofSize: 20, weight: .bold)
         button.titleLabel?.textColor = .textColor
         button.layer.cornerRadius = 10
         return button
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
    
    @objc private func userRateTapped(){
        onUserRateTapped?()
    }
    @objc private func favoriteTapped(){
        onFavoriteTapped?()
    }
    private func setupActions(){
        userRateStatusButton.addTarget(self, action: #selector(userRateTapped), for: .touchUpInside)
        favoritesButton.addTarget(self, action: #selector(favoriteTapped), for: .touchUpInside)
    }
    private func addsViews(){
        [titleNameLabel,image,favoritesButton,ratingBlock,tagsStackView,userRateStatusButton].forEach{
            contentView.addSubview($0)
        }
    }
    private func setupUI(){
        titleNameLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(12)
            make.leading.trailing.equalToSuperview().inset(12)
        }
        image.snp.makeConstraints { make in
            make.top.equalTo(titleNameLabel.snp.bottom).offset(16)
            make.height.equalTo(450)
            make.width.equalTo(300)
            make.leading.equalToSuperview().offset(16)
            
        }
        favoritesButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(16)
            make.top.equalTo(image)
        }
        ratingBlock.snp.makeConstraints { make in
            make.top.equalTo(image.snp.bottom).offset(16)
            make.leading.equalToSuperview().offset(16)
            
        }
        tagsStackView.snp.makeConstraints{make in
            make.top.equalTo(ratingBlock.snp.bottom).offset(8)
            make.leading.equalToSuperview().offset(16)
            
        }
        userRateStatusButton.snp.makeConstraints{make  in
            make.height.equalTo(50)
            make.top.equalTo(tagsStackView.snp.bottom).offset(16)
            make.leading.trailing.equalToSuperview().inset(16)
            make.bottom.equalToSuperview().inset(16)
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
    private func configureTags(with tags: [DetailedViewModel.TagData]) {
         tagsStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
         
         tags.forEach { tag in
             let color: UIColor
             switch tag.type {
             case .released: color = .systemGreen
             case .ongoing:  color = .systemOrange
             case .year: color = .systemBlue
             }
             
             let tagLabel = createTagLabel(text: tag.text, color: color)
             tagsStackView.addArrangedSubview(tagLabel)
         }
         
         let spacer = UIView()
         tagsStackView.addArrangedSubview(spacer)
     }
        //MARK: configure
    func configure(with data: HeaderModel) {
        titleNameLabel.text = data.titleName
        image.kf.setImage(with: data.imageURL)
        ratingBlock.ratingStarsView.setRating(data.rating)
        ratingBlock.scoreNumberLabel.text = data.score
        ratingBlock.scoreTextLabel.text = data.ratingText
        configureTags(with: data.tags)
        userRateStatusButton.setTitle(data.userRateButtontext, for: .normal)
        if data.isFavorite {
            favoritesButton.setImage(UIImage(systemName: "star.fill"), for: .normal)
        }else{
            favoritesButton.setImage(UIImage(systemName: "star"), for: .normal)
        }
        
    }
}

//
//  AnimeListCells.swift
//  ShikimoriPetApp
//
//  Created by Иван Илькив on 2/21/26.
//

import UIKit
import SnapKit
import Kingfisher

class AnimeListCell: UICollectionViewCell {
    
    static let identifier: String = "AnimeListCell"
    
    private let posterImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.layer.cornerRadius = 8
        return iv
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12, weight: .semibold)
        label.numberOfLines = 2
        label.textColor = .label
        label.textColor = .basalt
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    private func setupUI(){
        contentView.addSubview(posterImageView)
        contentView.addSubview(titleLabel)
        
        posterImageView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.height.equalTo(contentView.snp.height).multipliedBy(0.9)
        }
            titleLabel.snp.makeConstraints { make in
                make.top.equalTo(posterImageView.snp.bottom).offset(8)
                make.leading.trailing.equalToSuperview().inset(4)
                make.bottom.equalToSuperview().offset(-8)
               
        }
}
    
    func configure(with anime: AnimeList){
        titleLabel.text = anime.russian ?? anime.name
        
        if let imageUrlString = anime.image.original,
           let url = URL(string: "https://shikimori.io" + imageUrlString) {
            posterImageView.kf.setImage(
                with: url,
                placeholder: UIImage(named: "placeholder"),
                options: [
                    .transition(.fade(0.3)),
                    .cacheOriginalImage
                ]
            )
        }else{
            posterImageView.image = nil
        }
    }
}

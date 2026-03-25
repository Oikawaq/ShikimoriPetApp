//
//  AnimeListCells.swift
//  ShikimoriPetApp
//
//  Created by Иван Илькив on 2/21/26.
//

import UIKit
import SnapKit
import Kingfisher

class CharactersCell: UICollectionViewCell {
    
    static let identifier: String = "CharacersCell"
    
    private let posterImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.layer.cornerRadius = 8
        iv.backgroundColor = .basalt
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
            make.bottom.equalToSuperview().multipliedBy(0.9)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(posterImageView.snp.bottom).offset(4)
            make.leading.trailing.equalToSuperview()
            make.bottom.lessThanOrEqualToSuperview()
        }
    }
    
    func configure(with characters: CharacterRole){
        titleLabel.text = characters.character?.russian
        
        if let imageUrlString = characters.character?.image?.original,
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

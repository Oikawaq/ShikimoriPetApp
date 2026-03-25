//
//  FriendsCell.swift
//  ShikimoriPetApp
//
//  Created by Иван Илькив on 3/25/26.
//


import UIKit
import Kingfisher
import SnapKit
class FriendsCell: UICollectionViewCell{
    static let identifier: String = "FriendsCell"
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 8
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupContstaints()
        
    }
    private func setupContstaints(){
        contentView.addSubview(imageView)
        imageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func configure(friends: UserFriendsModel){
        if let url = friends.image?.x160 {
            let fullpath = URL(string: url)
            imageView.kf.setImage(with: fullpath)
        }
    }
    
}

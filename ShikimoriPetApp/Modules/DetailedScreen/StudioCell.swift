//
//  StudioCell.swift
//  ShikimoriPetApp
//
//  Created by Иван Илькив on 4/13/26.
//

import UIKit
import SnapKit
import Kingfisher

class StudioCell: UITableViewCell{
    static let identifier: String = "StudioCell"
    
    private let studioImage: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.layer.compositingFilter = "multiplyBlendMode"
        iv.layer.backgroundFilters = []
        iv.layer.borderColor = UIColor.white.cgColor
        iv.layer.cornerRadius = 8
        return iv
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
        addSubview(studioImage)

        
        studioImage.snp.makeConstraints { make in
            make.height.equalTo(80)
            make.width.equalTo(220)
            make.centerX.equalToSuperview()
            make.top.bottom.equalToSuperview().inset(8)
        }
    }
    func configure(with url: URL?){
        if let url = url {
            studioImage.kf.setImage(with: url,options: [.backgroundDecode, .cacheOriginalImage])
        }
        KF.url(url)
            .fade(duration: 1)
            .blackWhite()
            .set(to: studioImage)
            
    }
}

//
//  SectionBackgroundView.swift
//  ShikimoriPetApp
//
//  Created by Иван Илькив on 4/9/26.
//


import UIKit
final class SectionBackgroundView: UICollectionReusableView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .systemGray6
        layer.cornerRadius = 12
        clipsToBounds = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

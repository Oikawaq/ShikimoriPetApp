//
//  CharacterView.swift
//  ShikimoriPetApp
//
//  Created by Иван Илькив on 3/3/26.
//

import Foundation
import UIKit
import SnapKit
class CharacterView: UIView {
    private let scrollView =  UIScrollView()
    private let stackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 16
        stack.alignment = .fill
        stack.distribution = .fill
        return stack
    }()
    let name: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.textAlignment = .left
        label.font = .systemFont(ofSize: 24, weight: .bold)
        return label
    }()
    private let imageContainer: UIView = {
        let view = UIView()
        return view
    }()
    let posterImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.clipsToBounds = true
        iv.backgroundColor = .chalkWhite
        iv.layer.cornerRadius = 4
        return iv
    }()
    private let descriptionContainer = ContainerView(title: "Описание")
    let descriptionLabel: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.textAlignment = .natural
        label.font = .systemFont(ofSize: 16, weight: .regular)
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        return label
    }()
    private let seyuContainer = ContainerView(title: "Сейю")
    let seyuStackView = ListSectionView()
    
    private let relatedAnimeContainer = ContainerView(title: "Аниме")
    let relatedAnimeStackView = ListSectionView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .chalkWhite
        addsViews()
        setupUI()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    private func addsViews(){
        
        scrollView.decelerationRate = .normal
        addSubview(scrollView)
        scrollView.addSubview(stackView)
        [name,imageContainer,descriptionContainer,descriptionLabel,seyuContainer, seyuStackView, relatedAnimeContainer, relatedAnimeStackView].forEach({ stackView.addArrangedSubview($0) })
        imageContainer.addSubview(posterImageView)
    }
    private func setupUI(){
        scrollView.snp.makeConstraints{make in
            make.edges.equalTo(safeAreaLayoutGuide)
        }
        stackView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(16)
            make.width.equalToSuperview().offset(-32)
        }
        imageContainer.snp.makeConstraints { make in
            make.height.equalTo(350)
        }
        posterImageView.snp.makeConstraints { make in
            make.leading.top.bottom.equalToSuperview()
            make.width.lessThanOrEqualTo(250)
        }
    }
}

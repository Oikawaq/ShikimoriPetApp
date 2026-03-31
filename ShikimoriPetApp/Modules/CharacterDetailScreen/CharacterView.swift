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
        label.textColor = .basalt
        label.textAlignment = .left
        label.font = .systemFont(ofSize: 24, weight: .bold)
        return label
    }()
    private let headerContainer: UIView = {
        let view = UIView()
        return view
    }()
    let posterImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.backgroundColor = .blue
        
        iv.layer.cornerRadius = 8
        return iv
    }()
    let favoriteButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "star"), for: .normal)
        button.tintColor = .basalt
        return button
    }()
    private let descriptionContainer = ContainerView(title: "Описание")
    let descriptionLabel: UILabel = {
        let label = UILabel()
        label.textColor = .basalt
        label.textAlignment = .natural
        label.font = .systemFont(ofSize: 16, weight: .regular)
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        return label
    }()
    private let seyuContainer = ContainerView(title: "Сейю")
    let seyuStackView = ListSectionView()
    
    private let relatedAnimeContainer = ContainerView(title: "Аниме")
    let relatedAnimeCollectionView : UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = .chalkWhite
        cv.register(UniversalCollectionViewCell.self, forCellWithReuseIdentifier: UniversalCollectionViewCell.identifier)
        return cv
    }()
    private let relatedMangaContainer = ContainerView(title: "Манга")
    let relatedMangaCollectionView : UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = .chalkWhite
        cv.register(UniversalCollectionViewCell.self, forCellWithReuseIdentifier: UniversalCollectionViewCell.identifier)
        return cv
    }()
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
        [name,headerContainer,descriptionContainer,descriptionLabel,seyuContainer, seyuStackView, relatedAnimeContainer, relatedAnimeCollectionView, relatedMangaContainer, relatedMangaCollectionView].forEach({ stackView.addArrangedSubview($0) })
        headerContainer.addSubview(posterImageView)
        headerContainer.addSubview(favoriteButton)
    }
    private func setupUI(){
        scrollView.snp.makeConstraints{make in
            make.edges.equalTo(safeAreaLayoutGuide)
        }
        stackView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(16)
            make.width.equalToSuperview().offset(-32)
        }
        headerContainer.snp.makeConstraints { make in
            make.height.equalTo(350)
        }
        posterImageView.snp.makeConstraints { make in
            make.leading.top.bottom.equalToSuperview()
            make.width.lessThanOrEqualTo(250)
        }
        favoriteButton.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(16)
            make.left.equalTo(posterImageView.snp.right).offset(16)
            make.trailing.equalToSuperview().inset(16)
        }
        relatedAnimeCollectionView.snp.makeConstraints { make in
            make.height.equalTo(200)
        }
        relatedMangaCollectionView.snp.makeConstraints { make in
            make.height.equalTo(200)
        }
    }
}

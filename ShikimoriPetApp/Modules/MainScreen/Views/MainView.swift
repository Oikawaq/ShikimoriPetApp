//
//  MainScreenView.swift
//  ShikimoriPetApp
//
//  Created by Иван Илькив on 1/10/26.
//

import UIKit
import SnapKit

final class MainView: UIView {
    
    // MARK: UIComponents
    let typeSelectorButton: UIButton = {
        var configuration = UIButton.Configuration.filled()
        configuration.titleAlignment = .leading
        configuration.imagePlacement = .trailing
        configuration.imagePadding = 10
        configuration.buttonSize = .medium
        configuration.baseBackgroundColor = .chalkWhite.withAlphaComponent(0.3)
        configuration.image = UIImage(systemName: "chevron.down")
        let button = UIButton(configuration: configuration)
        button.setTitle("Аниме", for: .normal)
        button.setTitleColor(.chalkWhite, for: .normal)
        button.showsMenuAsPrimaryAction = true
        return button
    }()

    let descriptionLabel: UILabel = {
        let label = UILabel()
        label.text = L10n.MainPage.description
        label.font = UIFont.systemFont(ofSize: 10)
        label.textAlignment = .left
        label.textColor = .chalkWhite
        return label
    }()
    lazy var collectionView: UICollectionView = {
       let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical

        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = .chalkWhite
        cv.register(ItemsListCell.self, forCellWithReuseIdentifier: ItemsListCell.identifier)
        cv.register(FooterView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: FooterView.identifier)
        return cv
    }()
    
    let footerView: UICollectionReusableView = {
        let view = UICollectionReusableView()
        view.backgroundColor = .chalkWhite
        return view
    }()
    
    //MARK: init
    override init(frame: CGRect){
        super.init(frame: frame)
        addsViews()
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: Setup
    
    private func addsViews(){
        [typeSelectorButton, descriptionLabel,collectionView].forEach {
            addSubview($0)
        }
    }
    private func setupUI(){
        
        backgroundColor = UIColor.basalt
        
        typeSelectorButton.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide.snp.top).offset(-40)
            make.left.equalToSuperview().offset(16)
            make.height.equalTo(50)
        }
        descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(typeSelectorButton.snp.bottom).offset(8)
            make.left.equalToSuperview().offset(16)
        }
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(descriptionLabel.snp.bottom).offset(16)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        
    }
    
}

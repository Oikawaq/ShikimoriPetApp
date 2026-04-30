//
//  CharacterCell.swift
//  ShikimoriPetApp
//
//  Created by Иван Илькив on 4/14/26.
//

import UIKit
import SnapKit

class CharacterCell: UITableViewCell {
    var onCharacterTapped: ((Int)->Void)?
    private var characters: [CharacterModel?] = []
    static let identifier: String = "CharacterCell"
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = L10n.categories.mainCharacters
        label.font = Fonts.categoriesFont.fonts()
        label.textColor = .textColor
        return label
    }()
    private let characterCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal

        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(UniversalCollectionViewCell.self, forCellWithReuseIdentifier: UniversalCollectionViewCell.identifier)
        collectionView.backgroundColor = .clear
        collectionView.isUserInteractionEnabled = true
        return collectionView
    }()
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        characterCollectionView.delegate = self
        characterCollectionView.dataSource = self
        self.selectionStyle = .none
        backgroundColor = .bubbleBackground
        setupUI()
        
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    private func setupUI() {
        contentView.addSubview(titleLabel)
        contentView.addSubview(characterCollectionView)
        
        titleLabel.snp.makeConstraints { make in
            make.top.leading.equalTo(contentView).inset(16)
        }
        characterCollectionView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(12)
            make.leading.trailing.equalTo(contentView).inset(16)
            make.height.equalTo(200).priority(.required)
            make.bottom.equalTo(contentView).inset(16)
        }
    }
    func configure(with data: [CharacterModel?]){
        self.characters = data
    }

}
extension CharacterCell: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        characters.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: UniversalCollectionViewCell.identifier, for: indexPath) as! UniversalCollectionViewCell
        let character = characters[indexPath.row]!
        cell.configure(with: character)
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let characterId = characters[indexPath.row]?.id else { return }
        onCharacterTapped?(characterId)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 100, height: 200)
    }
 
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 15
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
            return 0
    }
}

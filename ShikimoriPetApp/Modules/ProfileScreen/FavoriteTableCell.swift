//
//  FavoriteTableCell.swift
//  ShikimoriPetApp
//
//  Created by Иван Илькив on 5/8/26.
//

import UIKit
import SnapKit

class FavoriteTableCell: UITableViewCell {
    static let identifier: String = "FavoriteTableCell"
    private var favorites: [UniversalType] = []
    var isFavoriteTapped: ((Int?, FavoriteType?) -> Void)?
    private let label: UILabel = {
        let label = UILabel()
        label.text = L10n.categories.favorite
        label.font = .systemFont(ofSize: 16, weight: .semibold)
        label.textAlignment = .left
        return label
    }()
    private let favoriteCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        return collectionView
    }()
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
        setupCollectionView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func configure(with favorite: [UniversalType]){
        self.favorites = favorite
    }
    private func setupCollectionView(){
        favoriteCollectionView.delegate = self
        favoriteCollectionView.dataSource = self
        favoriteCollectionView.register(UniversalCollectionViewCell.self, forCellWithReuseIdentifier: UniversalCollectionViewCell.identifier)
    }
    private func setupUI(){
        contentView.backgroundColor = .bubbleBackground
        contentView.addSubview(label)
        contentView.addSubview(favoriteCollectionView)
        
        label.snp.makeConstraints { make in
            make.top.leading.trailing.equalTo(contentView).inset(16)
        }
        favoriteCollectionView.snp.makeConstraints { make in
            make.top.equalTo(label.snp.bottom)
            make.leading.trailing.equalTo(contentView).inset(16)
            make.bottom.equalTo(contentView)
            make.height.equalTo(220)
        }
    }
    
}
extension FavoriteTableCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return favorites.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: UniversalCollectionViewCell.identifier, for: indexPath) as! UniversalCollectionViewCell
        let favorites = favorites[indexPath.row]
        cell.configure(with: favorites)
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let item = favorites[indexPath.item]
        isFavoriteTapped?(item.id, item.type)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 100, height: 200)
    }
}

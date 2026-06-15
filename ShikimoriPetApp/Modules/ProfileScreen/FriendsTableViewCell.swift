//
//  FriendsTableViewCell.swift
//  ShikimoriPetApp
//
//  Created by Иван Илькив on 5/8/26.
//

import UIKit
import SnapKit

class FriendsTableViewCell: UITableViewCell{
    static let identifier: String = "FriendsTableViewCell"
    var friends: [UserFriendsModel] = []
    var isFriendTapped : ((Int) -> Void)?
    private let label : UILabel = {
        let label = UILabel()
        label.text = L10n.categories.friends
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.textAlignment = .left
        return label
    }()
    let friendsCollection: UICollectionView = {
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
    private func setupCollectionView(){
        friendsCollection.delegate = self
        friendsCollection.dataSource = self
        friendsCollection.register(FriendsCell.self, forCellWithReuseIdentifier: FriendsCell.identifier)
    }
    func configure(with friends: [UserFriendsModel]){
        self.friends = friends
    }
    private func setupUI(){
        contentView.addSubview(friendsCollection)
        contentView.addSubview(label)
        contentView.backgroundColor = .bubbleBackground
        label.snp.makeConstraints { make in
            make.leading.trailing.top.equalTo(contentView).offset(16)
        }
        friendsCollection.snp.makeConstraints { make in
            make.leading.trailing.equalTo(contentView).inset(16)
            make.bottom.equalTo(contentView)
            make.top.equalTo(label.snp.bottom)
            make.height.equalTo(120)
        }
    }
}
extension FriendsTableViewCell: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        friends.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FriendsCell.identifier, for: indexPath) as! FriendsCell
        cell.configure(friends: friends[indexPath.row])
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 100, height: 100)
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        isFriendTapped?(friends[indexPath.row].itemId ?? 0)
    }
}

//
//  CharacterCell.swift
//  ShikimoriPetApp
//
//  Created by Иван Илькив on 4/14/26.
//

import UIKit
import SnapKit

class UniversalTableViewWithCollection: UITableViewCell {
    var onItemTapped: ((Int)->Void)?
    private var array: [UniversalCellProtocol?] = []
    static let identifier: String = "UniversalTableViewWithCollection"
    private let label: UILabel = {
        let label = UILabel()
        label.font = Fonts.categoriesFont.fonts()
        label.textColor = .textColor
        return label
    }()
    private let collectionView: UICollectionView = {
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
        collectionView.delegate = self
        collectionView.dataSource = self
        self.selectionStyle = .none
        backgroundColor = .bubbleBackground
        setupUI()
        
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    private func setupUI() {
        contentView.addSubview(label)
        contentView.addSubview(collectionView)
        
        label.snp.makeConstraints { make in
            make.top.leading.equalTo(contentView).inset(16)
        }
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(label.snp.bottom).offset(12)
            make.leading.trailing.equalTo(contentView).inset(16)
            make.height.equalTo(200).priority(.required)
            make.bottom.equalTo(contentView).inset(16)
        }
    }
    func configure(with data: [UniversalCellProtocol?], sectionName: String){
        self.array = data
        label.text = sectionName
    }

}
extension UniversalTableViewWithCollection: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        array.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: UniversalCollectionViewCell.identifier, for: indexPath) as! UniversalCollectionViewCell
        let item = array[indexPath.row]!
        cell.configure(with: item)
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let id = array[indexPath.row]?.itemId else { return }
        onItemTapped?(id)
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

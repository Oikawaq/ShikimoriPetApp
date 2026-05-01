//
//  CharacterCell.swift
//  ShikimoriPetApp
//
//  Created by Иван Илькив on 4/14/26.
//

import UIKit
import SnapKit

class ScreenshotsTableCell: UITableViewCell {
    var onScreenshotTapped: (([URL?],Int) -> Void)?
    private var screenshots: [URL?] = []
    static let identifier: String = "ScreenshotsCell"
    private let sectionLabel: UILabel = {
        let label = UILabel()
        label.text = L10n.categories.screenshots
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.textColor = .textColor
        return label
    }()
    private let screenshotsCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.register(ScreenshotsCell.self, forCellWithReuseIdentifier: ScreenshotsCell.identifier)
        cv.backgroundColor = .clear
        cv.showsHorizontalScrollIndicator = false
        return cv
    }()
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        screenshotsCollectionView.delegate = self
        screenshotsCollectionView.dataSource = self
        self.selectionStyle = .none
        backgroundColor = .bubbleBackground
        setupUI()
        print("ScreenshotsCount: \(screenshots.count)")
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    private func setupUI() {
        contentView.addSubview(screenshotsCollectionView)
        contentView.addSubview(sectionLabel)
        sectionLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(16)
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().inset(16)
        }
        screenshotsCollectionView.snp.makeConstraints { make in
            make.top.equalTo(sectionLabel.snp.bottom).offset(12)
//            make.edges.equalTo(contentView).inset(16)
            make.leading.trailing.bottom.equalTo(contentView).inset(16)
            make.height.equalTo(215)
        }
    }
    func configure(with data: [URL]){
        self.screenshots = data
    }

}
extension ScreenshotsTableCell: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return screenshots.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ScreenshotsCell.identifier, for: indexPath) as! ScreenshotsCell
        let screenshot = screenshots[indexPath.row]
        cell.configure(with: screenshot)
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let screenshots = screenshots
        let index = indexPath.row
        onScreenshotTapped?(screenshots, index)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 180, height: 100)
    }
 
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 15
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
            return 15
    }
}

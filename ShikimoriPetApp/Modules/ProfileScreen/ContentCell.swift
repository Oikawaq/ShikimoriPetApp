//
//  ContentCell.swift
//  ShikimoriPetApp
//
//  Created by Иван Илькив on 5/8/26.
//

import UIKit
import SnapKit

final class ContentCell: UITableViewCell {
    var isContentTapped: ((ContentType) -> Void)?
    static let identifier: String = "ContentCell"
    private let label: UILabel = {
       let label = UILabel()
        label.text = "\(L10n.categories.anime) / \(L10n.categories.manga)"
        label.font = .systemFont(ofSize: 14)
        label.textAlignment = .left
        return label
    }()
    let animeBar = SegmentedBar()
    let mangaBar = SegmentedBar()
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
        setupTargets()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    private func setupTargets(){
        let animeTap = UITapGestureRecognizer(target: self, action: #selector(animeBarTapped))
        animeBar.addGestureRecognizer(animeTap)
        let mangaTap = UITapGestureRecognizer(target: self, action: #selector(mangaBarTapped))
        mangaBar.addGestureRecognizer(mangaTap)
    }
    @objc private func animeBarTapped(){
        isContentTapped?(.animes)
    }
    @objc private func mangaBarTapped(){
        isContentTapped?(.mangas)
    }
    private func setupUI(){
        contentView.backgroundColor = .bubbleBackground
        self.selectionStyle = .none
        contentView.addSubview(label)
        contentView.addSubview(animeBar)
        contentView.addSubview(mangaBar)
        
        label.snp.makeConstraints{make in
            make.top.leading.trailing.equalToSuperview().offset(16)
        }
        animeBar.snp.makeConstraints{make in
            make.top.equalTo(label.snp.bottom).offset(10)
            make.leading.trailing.equalToSuperview().inset(16)
        }
        mangaBar.snp.makeConstraints{make in
            make.top.equalTo(animeBar.snp.bottom).offset(10)
            make.leading.trailing.equalToSuperview().inset(16)
            make.bottom.equalToSuperview().inset(16).priority(999)
        }
    }
    func configure(animeSegment: [Segment], animeDescription: String, mangaSegment: [Segment], mangaDescription: String){
        animeBar.configure(with: animeSegment, description: animeDescription)
        mangaBar.configure(with: mangaSegment, description: mangaDescription)
    }
    private func handleTap()-> UITapGestureRecognizer{
        let gesture = UITapGestureRecognizer(target: self, action: #selector(animeBarTapped))
        addGestureRecognizer(gesture)
        return gesture
    }
}

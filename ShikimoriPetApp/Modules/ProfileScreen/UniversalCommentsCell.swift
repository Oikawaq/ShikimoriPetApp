//
//  ProfileCommentsCell.swift
//  ShikimoriPetApp
//
//  Created by Иван Илькив on 5/8/26.
//

import UIKit
import SnapKit
import Kingfisher
class UniversalCommentsCell: UITableViewCell {
    static let identifier: String = "CommentsCell"
    private var userId: Int?
    var isUserTapped: ((Int)-> Void)?
    var isImageTapped: (([URL])-> Void)?
    private var urls: [URL] = []
    private let commentLabel: UILabel = {
       let label = UILabel()
        label.textColor = .textColor
        label.textAlignment = .left
        label.numberOfLines = 0
        
        return label
    }()
    private let image : UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.isUserInteractionEnabled = true
        imageView.layer.cornerRadius = 4
        return imageView
    }()
    private let userNameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .textColor
        label.textAlignment = .left
        return label
    }()
    private let container: UIView = {
        let view = UIView()
        return view
    }()
    private let imageComment: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFill
        image.clipsToBounds = true
        image.isUserInteractionEnabled = true
        return image
    }()
    private let contentStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 4
        stack.alignment = .leading
        return stack
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
        setupTargets()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func prepareForReuse() {
        super.prepareForReuse()
        urls = []
        userId = nil
        
    }
    private func setupUI(){
        
        selectionStyle = .none
        backgroundColor = .bubbleBackground
        contentView.addSubview(container)
        
        container.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(16)
        }
        container.addSubview(image)
        container.addSubview(contentStackView)
 
        contentStackView.addArrangedSubview(userNameLabel)
        contentStackView.addArrangedSubview(commentLabel)
        contentStackView.addArrangedSubview(imageComment)

        image.snp.makeConstraints { make in
            make.leading.top.equalToSuperview()
            make.width.height.equalTo(48)
            
        }
        contentStackView.snp.makeConstraints { make in
            make.top.trailing.bottom.equalToSuperview()
            make.leading.equalTo(image.snp.trailing).offset(16)
        }
        imageComment.snp.makeConstraints { make in
            make.height.width.equalTo(68)
        }
        
    }
    private func setupTargets(){
        let userTap = UITapGestureRecognizer(target: self, action: #selector(onUserTapped))
        image.addGestureRecognizer(userTap)
        
        let imageTap = UITapGestureRecognizer(target: self, action: #selector(onImageTapped))
        imageComment.addGestureRecognizer(imageTap)
    }
    @objc private func onUserTapped(){
        guard let id = userId else {return}
        isUserTapped?(id)
    }
    @objc private func onImageTapped(){
        isImageTapped?(urls)
    }
    func configure(with comments: CommentsModel){
        guard let imageUrl = comments.user.image?.x48 else {return}
        image.kf.setImage(with: URL(string: imageUrl))
        userNameLabel.text = comments.user.nickname
        commentLabel.text = comments.body
        userId = comments.user.id
        
        if let image = comments.image, let url = URL(string: image){
            urls.append(url)
            imageComment.isHidden = false
            imageComment.kf.setImage(with: url)
        }else{
            imageComment.isHidden = true
        }
        
    }
}

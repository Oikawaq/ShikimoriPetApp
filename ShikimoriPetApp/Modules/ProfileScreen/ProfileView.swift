

import UIKit
import SnapKit

class ProfileView: UIView {

    // MARK: - UIComponents
    
     let profileImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "person.fill")
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
         imageView.layer.cornerRadius = 8
        return imageView
    }()
    
    let userName: UILabel = {
        let label = UILabel()
        label.text = "User Name"
        label.font = .systemFont(ofSize: 20, weight: .semibold)
        return label
    }()
    
    let userAge: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .regular)
        label.isUserInteractionEnabled = true
//        let interaction = UIContextMenuInteraction(delegate: self)
//        label.addInteraction(interaction)
        return label
    }()
    
    let anime: UILabel = {
        let label = UILabel()
        label.text = "Аниме"
        label.font = .systemFont(ofSize: 16, weight: .regular)
        return label
    }()
    let manga: UILabel = {
        let label = UILabel()
        label.text = "Манга"
        label.font = .systemFont(ofSize: 16, weight: .regular)
        return label
    }()
    
    
    // MARK: - init
    init() {
       super.init(frame: .zero)
        backgroundColor = .chalkWhite
        addViews()
        setupConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup
    
    private func addViews(){
        [profileImage, userName, userAge,anime,manga].forEach {
            addSubview($0)
        }
    }
    
    private func setupConstraints(){
        
        profileImage.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide.snp.top).offset(16)
            make.left.equalToSuperview().offset(16)
            make.width.height.equalTo(150)
        }
        
        userName.snp.makeConstraints { make in
            make.top.equalTo(profileImage.snp.top)
            make.left.equalTo(profileImage.snp.right).offset(16)
            
        }
        
        userAge.snp.makeConstraints { make in
            make.top.equalTo(userName.snp.bottom).offset(16)
            make.left.equalTo(profileImage.snp.right).offset(16)
        }
        
        anime.snp.makeConstraints { make in
            make.top.equalTo(profileImage.snp.bottom).offset(16)
            make.left.equalToSuperview().offset(16)
        }
        
        manga.snp.makeConstraints { make in
            make.top.equalTo(anime.snp.bottom).offset(16)
            make.left.equalToSuperview().offset(16)
        }
    }
    
}

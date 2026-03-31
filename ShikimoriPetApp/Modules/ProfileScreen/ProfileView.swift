

import UIKit
import SnapKit

class ProfileView: UIView {

    // MARK: - UIComponents
    private let scrollView = UIScrollView()
    private let contentStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 10
        return stack
    }()
    private let headerBlock: UIView = {
        let view = UIView()
        view.backgroundColor = .chalkWhite
        return view
    }()
     let profileImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "person.fill")
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
         imageView.layer.cornerRadius = 8
        return imageView
    }()

    lazy var userName = createLabel(title: "", size: 25, weight: .bold)
    lazy var userAge = createLabel(title: "", size: 20, weight: .medium)
    let friendsContainer = ContainerView(title: "Друзья")
    
    let friendsCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(FriendsCell.self, forCellWithReuseIdentifier: FriendsCell.identifier)
        collectionView.backgroundColor = .chalkWhite
        return collectionView
    }()
    private let favoritesContainer = ContainerView(title: "Избранное")
    let favoritesCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(UniversalCollectionViewCell.self, forCellWithReuseIdentifier: UniversalCollectionViewCell.identifier)
        collectionView.backgroundColor = .chalkWhite
        return collectionView
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
        addSubview(scrollView)
        scrollView.addSubview(contentStackView)
        [headerBlock,friendsContainer, friendsCollectionView, favoritesContainer,favoritesCollectionView].forEach {
            contentStackView.addArrangedSubview($0)
        }
        headerBlock.addSubview(profileImage)
        headerBlock.addSubview(userName)
        headerBlock.addSubview(userAge)
    }
    
    private func setupConstraints(){
        scrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        contentStackView.snp.makeConstraints { make in
            make.top.equalTo(scrollView)
            make.leading.trailing.bottom.equalTo(scrollView).offset(16)
            make.width.equalToSuperview().offset(-32)
        }
        headerBlock.snp.makeConstraints { make in
            make.height.equalTo(200)
        }
        profileImage.snp.makeConstraints { make in
            make.top.bottom.leading.equalTo(headerBlock)
            make.width.equalTo(200)
        }
        userName.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.left.equalTo(profileImage.snp.right).offset(16)
            
        }
        userAge.snp.makeConstraints { make in
            make.top.equalTo(userName.snp.bottom).offset(16)
            make.left.equalTo(profileImage.snp.right).offset(16)
        }
        friendsCollectionView.snp.makeConstraints { make in
            make.height.equalTo(100)
        }
        favoritesCollectionView.snp.makeConstraints { make in
            make.height.equalTo(200)
        }

    }
    private func createLabel(title: String, size : CGFloat = 16, weight: UIFont.Weight = .regular)-> UILabel{
        let label = UILabel()
        label.text = title
        label.font = .systemFont(ofSize: size, weight: weight)
        label.textColor = .basalt
        return label
    }
}

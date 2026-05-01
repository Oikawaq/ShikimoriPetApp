//
//  ProfileScreenVC.swift
//  ShikimoriPetApp
//
//  Created by Иван Илькив on 2/5/26.
//

import UIKit
import Kingfisher
import Combine

class ProfileViewController: UIViewController {
    private var cancellables = Set<AnyCancellable>()
    let viewModel: ProfileViewModel
    let userID = UserDefaults.standard.integer(forKey: UserDefaultsEnum.userId.value)
    //MARK: init
    init(viewModel: ProfileViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    private var profileView: ProfileView? {
           view as? ProfileView
       }
    
    override func loadView() {
           view = ProfileView()
        loadAllData()
       }
    
        //MARK: lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTargets()
        setupBindings()
        setupCollectionView()
        
    }
    override func viewWillAppear(_ animated: Bool) {
        viewModel.loadUserFriends()
        viewModel.loadUserFavorites()
    }
    func loadAllData(){
        viewModel.loadUserData()
        
    }
    private func setupBindings() {
        viewModel.$profileData
            .receive(on: DispatchQueue.main)
            .sink{[weak self] _ in
                guard let self = self else {return}
                self.updateUI()
             
            }
            .store(in: &cancellables)
        viewModel.$userFriendsList
            .receive(on: DispatchQueue.main)
            .sink { [weak self]_ in
                guard let self = self else {return}
                self.profileView?.friendsCollectionView.reloadData()
            }
            .store(in: &cancellables)
        viewModel.$userFavorites
            .receive(on: DispatchQueue.main)
            .sink { [weak self]_ in
                guard let self = self else {return}
                self.profileView?.favoritesCollectionView.reloadData()
            }
            .store(in: &cancellables)
    }

    @objc func isUserListTapped(){
        let vm = ContentListViewModel(type: .animes)
        let vc = ContentListViewController(viewModel: vm)
        navigationController?.pushViewController(vc, animated: true)
    }
    private func setupTargets(){
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(isUserListTapped))
        profileView?.animeBar.label.addGestureRecognizer(tapGesture)
        
    }
    private func updateUI(){
        guard let profileView else {return}
        profileView.userName.text = viewModel.username
        if let url = viewModel.imageURL {
            profileView.profileImage.kf.setImage(
                with: url,
                options: [
                .backgroundDecode,
                .cacheOriginalImage]
            )
        }
        profileView.userAge.text = viewModel.userAge
        
        profileView.animeBar.configure(with: viewModel.createSegmentList(list: viewModel.profileData?.stats.statuses.anime, color: .systemBlue), description: viewModel.animeBlockDescription)
        profileView.mangaBar.configure(with: viewModel.createSegmentList(list: viewModel.profileData?.stats.statuses.manga, color: .magenta), description: viewModel.mangaBlockDescription)
        
    }
   private func setupCollectionView(){
       profileView?.friendsCollectionView.delegate = self
       profileView?.friendsCollectionView.dataSource = self
       
       profileView?.favoritesCollectionView.delegate = self
       profileView?.favoritesCollectionView.dataSource = self
    }

}
    //MARK: CollectionViewSetup
extension ProfileViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return collectionView == profileView?.friendsCollectionView ? viewModel.userFriendsList.count : viewModel.favoritesList.count
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == profileView?.friendsCollectionView { guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FriendsCell.identifier, for: indexPath) as? FriendsCell else {
            return UICollectionViewCell()
        }
            
            let friend = viewModel.userFriendsList[indexPath.item]
            cell.configure(friends: friend)
            return cell
        }
        else{
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: UniversalCollectionViewCell.identifier, for: indexPath) as? UniversalCollectionViewCell else {
                return UICollectionViewCell()
            }
            let favorite = viewModel.favoritesList[indexPath.item]
            cell.configure(with: favorite)
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == profileView?.friendsCollectionView {
            guard let id = viewModel.userFriendsList[indexPath.item].id else {return }
            let vm = ProfileViewModel(userId: id)
            let vc = ProfileViewController(viewModel: vm)
            navigationController?.pushViewController(vc, animated: true)
        }else{
            let item = viewModel.favoritesList[indexPath.item]
            switch item.type {
            case .anime:
                let vc = DetailedViewController(viewModel: DetailedViewModel(itemId: item.id, contentType: .animes))
                navigationController?.pushViewController(vc, animated: true)
            case .character:
                let vc = CharacterViewController(viewModel: CharacterViewModel(characterId: item.id))
                navigationController?.pushViewController(vc, animated: true)
            case .manga:
                let vc = DetailedViewController(viewModel: DetailedViewModel(itemId: item.id, contentType: .mangas))
                navigationController?.pushViewController(vc, animated: true)
            case .ranobe:
                let vc = DetailedViewController(viewModel: DetailedViewModel(itemId: item.id, contentType: .ranobe))
                navigationController?.pushViewController(vc, animated: true)
            case .none:
                print("no favorite data")
            }
       
            
            
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return collectionView == profileView?.friendsCollectionView ? CGSize(width: 100, height: 100) : CGSize(width: 100, height: 200)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        8
    }
}

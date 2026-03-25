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
    let userID = UserDefaults.standard.integer(forKey: "current_user_id")
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
       }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadAllData()
        setupBindings()
        setupCollectionView()
    }
    func loadAllData(){
        viewModel.loadUserData()
        viewModel.loadUserFriends()
    }
    private func setupBindings() {
        viewModel.$profileData
            .receive(on: DispatchQueue.main)
            .sink{[weak self] _ in
                self?.updateUI()
            }
            .store(in: &cancellables)
        viewModel.$userFriendsList
            .receive(on: DispatchQueue.main)
            .sink { [weak self]_ in
                self?.profileView?.friendsCollectionView.reloadData()
            }
            .store(in: &cancellables)
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
        
    }
   private func setupCollectionView(){
       profileView?.friendsCollectionView.delegate = self
       profileView?.friendsCollectionView.dataSource = self
    }

}

extension ProfileViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return viewModel.userFriendsList.count
       
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FriendsCell.identifier, for: indexPath) as? FriendsCell else {
            return UICollectionViewCell()
        }
        let friend = viewModel.userFriendsList[indexPath.item]
        cell.configure(friends: friend)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let id = viewModel.userFriendsList[indexPath.item].id else {return }
        let vm = ProfileViewModel(userId: id)
        let vc = ProfileViewController(viewModel: vm)
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 80, height: 80)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        8
    }
}

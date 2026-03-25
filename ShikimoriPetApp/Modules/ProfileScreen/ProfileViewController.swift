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
        viewModel.loadUserData(id: userID)
        setupBindings()
        
    }
    private func setupBindings() {
        viewModel.$profileData
            .receive(on: DispatchQueue.main)
            .sink{[weak self] _ in
                self?.updateUI()
            }
            .store(in: &cancellables)
    }

    private func updateUI(){
        guard let profileView else {return}
        profileView.userName.text = viewModel.username
        if let url = viewModel.imageURL {
            profileView.profileImage.kf.setImage(with: url,
                                                 options: [
                                                     .backgroundDecode,
                                                     .cacheOriginalImage
                                                 ])
        }
        profileView.userAge.text = viewModel.profileData?.fullYears?.description
    }
   

}
extension ProfileViewController: UIContextMenuInteractionDelegate {
    func contextMenuInteraction(_ interaction: UIContextMenuInteraction, configurationForMenuAtLocation location: CGPoint) -> UIContextMenuConfiguration? {
        return UIContextMenuConfiguration(identifier: nil, previewProvider: nil) { _ in
            // Здесь мы создаем "меню", которое покажет полную дату
            let fullDate = "13 октября 2017 г." // Эту дату мы достали из HTML
            let action = UIAction(title: fullDate, image: UIImage(systemName: "calendar")) { _ in }
            return UIMenu(title: "Дата регистрации", children: [action])
        }
    }
}

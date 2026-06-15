//
//  ProfileViewControllerTest.swift
//  ShikimoriPetApp
//
//  Created by Иван Илькив on 5/7/26.
//

import UIKit
import Combine


class ProfileViewController: UIViewController {
    private var cancellables: Set<AnyCancellable> = []
    private let viewModel: ProfileViewModel
    private var profileView: ProfileView?{
        view as? ProfileView
    }
    override func loadView() {
        view = ProfileView()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        setupBindings()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.loadAllData()
        
    }
        //MARK: init
    init(viewModel: ProfileViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupTableView(){
        profileView?.tableView.delegate = self
        profileView?.tableView.dataSource = self
        profileView?.tableView.register(UserInfoCell.self, forCellReuseIdentifier: UserInfoCell.identifier)
        profileView?.tableView.register(ContentCell.self, forCellReuseIdentifier: ContentCell.identifier)
        profileView?.tableView.register(FriendsTableViewCell.self, forCellReuseIdentifier: FriendsTableViewCell.identifier)
        profileView?.tableView.register(FavoriteTableCell.self, forCellReuseIdentifier: FavoriteTableCell.identifier)
        profileView?.tableView.register(UniversalCommentsCell.self, forCellReuseIdentifier: UniversalCommentsCell.identifier)
        profileView?.tableView.register(CommentsHeader.self, forCellReuseIdentifier: CommentsHeader.identifier)
        profileView?.tableView.register(CommentsFooter.self, forHeaderFooterViewReuseIdentifier: CommentsFooter.identifier)
        profileView?.tableView.rowHeight = UITableView.automaticDimension
    }
    private func setupBindings(){

        Publishers.CombineLatest4(
            viewModel.$profileData,
            viewModel.$userFavorites,
            viewModel.$userFriendsList,
            viewModel.$comments
        )
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                guard let self = self else {return}
                self.profileView?.tableView.reloadData()
            }
            .store(in: &cancellables)
    }
    private func navigateTo(id: Int, contentType: ContentType){
        let vm = DetailedViewModel(itemId: id, contentType: contentType)
        let vc = DetailedViewController(viewModel: vm)
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
extension ProfileViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if viewModel.numberOfSections[section] == .comments{
            return viewModel.comments.count + 1
        }else{
            return 1
        }
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.numberOfSections.count
    }
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footer = tableView.dequeueReusableHeaderFooterView(withIdentifier: CommentsFooter.identifier)
        let currentSection = viewModel.numberOfSections[section]
        guard currentSection == .comments else {return nil}
        return footer
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        let currentSection = viewModel.numberOfSections[section]
        guard currentSection == .comments else {return 0}
        return 40
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch viewModel.numberOfSections[indexPath.section] {
            
        case .userInfo:
            let cell = tableView.dequeueReusableCell(withIdentifier: UserInfoCell.identifier, for: indexPath) as! UserInfoCell
            let data: UserHeaderInfo = UserHeaderInfo(imageURL: viewModel.imageURL, userName: viewModel.username, userAge: viewModel.userAge)
            cell.configure(with: data)
            return cell
        case .content:
            let cell = tableView.dequeueReusableCell(withIdentifier: ContentCell.identifier, for: indexPath) as! ContentCell
            let animeSegment = viewModel.createSegmentList(list: viewModel.profileData?.stats.statuses.anime, color: .systemBlue)
            let mangaSegment = viewModel.createSegmentList(list: viewModel.profileData?.stats.statuses.manga, color: .magenta)
            cell.configure(animeSegment:  animeSegment, animeDescription: viewModel.animeBlockDescription, mangaSegment: mangaSegment, mangaDescription: viewModel.mangaBlockDescription)
            cell.isContentTapped = { [weak self] type in
                guard let self = self else {return}
                let vm = ContentListViewModel(type: type, userId: viewModel.userId)
                let vc = ContentListViewController(viewModel: vm)
                self.navigationController?.pushViewController(vc, animated: true)
                print("tapped on \(type)")
            }
            return cell
        case .friend:
            let cell = tableView.dequeueReusableCell(withIdentifier: FriendsTableViewCell.identifier, for: indexPath) as! FriendsTableViewCell
            cell.configure(with: viewModel.userFriendsList)
            cell.isFriendTapped = {[weak self ] id in
                    guard let self else {return}
                let vm = ProfileViewModel(userId: id)
                let vc = ProfileViewController(viewModel: vm)
                self.navigationController?.pushViewController(vc, animated: true)
            }
            return cell
        case .favorite:
            let cell = tableView.dequeueReusableCell(withIdentifier: FavoriteTableCell.identifier, for: indexPath) as! FavoriteTableCell
            cell.configure(with: viewModel.favoritesList)
            cell.isFavoriteTapped = {[weak self ] id,type in
                guard let id = id else {return}
                guard let self = self else {return}
                switch type{
                case .anime:
                    navigateTo(id: id, contentType: .animes)
                case .manga:
                    navigateTo(id: id, contentType: .mangas)
                case .ranobe:
                    navigateTo(id: id, contentType: .ranobe)
                case .character:
                    let charId = String(id)
                    let vm = CharacterViewModel(characterId: charId)
                    let vc = CharacterViewController(viewModel: vm)
                    self.navigationController?.pushViewController(vc, animated: true)
                case .none:
                    print("No favorite data")
                }
            }
            return cell
        case .comments:
            
            if indexPath.row == 0{
                let cell = tableView.dequeueReusableCell(withIdentifier: CommentsHeader.identifier, for: indexPath) as! CommentsHeader
                cell.configure(canLoadMore: viewModel.canLoadMore)
                cell.onShowAllButtonTapped = {[weak self ] in
                    guard let self = self else {return}
                    self.viewModel.moreComments()
                }
                return cell
            }else{
                
                let cell = tableView.dequeueReusableCell(withIdentifier: UniversalCommentsCell.identifier, for: indexPath) as! UniversalCommentsCell
                let data = viewModel.comments.reversed()[indexPath.row - 1]
                cell.configure(with: data)
                cell.isUserTapped = {[weak self] id in
                    guard let self = self else {return}
                    let vm = ProfileViewModel(userId: id)
                    let vc = ProfileViewController(viewModel: vm)
                    self.navigationController?.pushViewController(vc, animated: true)
                    
                }
                cell.isImageTapped = {[weak self] array in
                    guard let self = self else {return}
                    let vc = FullScreenImagesVC(urls: array, startIndex: 0)
                    vc.modalPresentationStyle = .overFullScreen
                    vc.modalTransitionStyle = .crossDissolve
                    present(vc, animated: true)
                }
                
                return cell
            }
        }
    }
}

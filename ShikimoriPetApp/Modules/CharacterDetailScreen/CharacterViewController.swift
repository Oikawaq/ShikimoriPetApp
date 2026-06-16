//
//  CharacterViewController.swift
//  ShikimoriPetApp
//
//  Created by Иван Илькив on 4/30/26.
//

import Foundation
import UIKit
import Kingfisher
import Combine

final class CharacterViewController: UIViewController {
    private let viewModel: CharacterViewModel
    private var cancellables: Set<AnyCancellable> = []
    private weak var commentInputCell: CommentInputCell?

    private var characterView: CharacterView? {
        return view as? CharacterView
    }
    //MARK: init
    init(viewModel: CharacterViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    //MARK: lifecycle
    override func loadView() {
        view = CharacterView()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        viewModel.loadAllData()
        setupBindings()
    }
    private func setupTableView() {
        characterView?.tableView.dataSource = self
        characterView?.tableView.delegate = self
        characterView?.tableView.rowHeight = UITableView.automaticDimension
        characterView?.tableView.register(CharacterheaderCell.self, forCellReuseIdentifier: CharacterheaderCell.identifier)
        characterView?.tableView.register(DescriptionCell.self, forCellReuseIdentifier: DescriptionCell.identifier)
        characterView?.tableView.register(UniversalRowDataCell.self, forCellReuseIdentifier: UniversalRowDataCell.identifier)
        characterView?.tableView.register(UniversalTableViewWithCollection.self, forCellReuseIdentifier: UniversalTableViewWithCollection.identifier)
        characterView?.tableView.register(UniversalCommentsCell.self, forCellReuseIdentifier: UniversalCommentsCell.identifier)
        characterView?.tableView.register(CommentsHeader.self, forCellReuseIdentifier: CommentsHeader.identifier)
        characterView?.tableView.register(CommentInputCell.self, forCellReuseIdentifier: CommentInputCell.identifier)
    }
    private func setupBindings() {
        Publishers.CombineLatest4(viewModel.$isFavorite, viewModel.$fullCharacterDetails, viewModel.$character, viewModel.$comments)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.characterView?.tableView.reloadData()
            }
            .store(in: &cancellables)
    }
    private func navigateToDetails(id: Int, type: ContentType){
        let vm = DetailedViewModel(itemId: id, contentType: type)
        let vc = DetailedViewController(viewModel: vm)
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension CharacterViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.numberOfSections.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if viewModel.numberOfSections[section] == .comments {
            return viewModel.comments.count + 2
        }
        return 1
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let sections = viewModel.numberOfSections[indexPath.section]
        switch sections {
        case .header:
            let cell = tableView.dequeueReusableCell(withIdentifier: CharacterheaderCell.identifier, for: indexPath) as! CharacterheaderCell
            let headerModel = CharacterHeaderModel(
                name: viewModel.name, imageURL: viewModel.imageURL, isFavorite: viewModel.isFavorite
            )
            cell.configure(with: headerModel)
            cell.onFavoriteTapped = {[weak self] in
                self?.viewModel.toggleFavorite()
            }
            return cell
        case .description:
            let cell = tableView.dequeueReusableCell(withIdentifier: DescriptionCell.identifier, for: indexPath) as! DescriptionCell
            let string: NSAttributedString = viewModel.description
            cell.configure(with: string)
            return cell
        case .seyu:
            let cell = tableView.dequeueReusableCell(withIdentifier: UniversalRowDataCell.identifier, for: indexPath) as! UniversalRowDataCell
            cell.configure(with: viewModel.seyu, sectionName: L10n.categories.seyu)
            return cell
        case .anime:
            let cell = tableView.dequeueReusableCell(withIdentifier: UniversalTableViewWithCollection.identifier, for: indexPath) as! UniversalTableViewWithCollection
            cell.configure(with: viewModel.relatedAnimeList, sectionName: L10n.categories.anime)
            cell.onItemTapped = { [weak self] id in
                self?.navigateToDetails(id: id, type: .animes)
            }
            return cell
        case .manga:
            let cell = tableView.dequeueReusableCell(withIdentifier: UniversalTableViewWithCollection.identifier, for: indexPath) as! UniversalTableViewWithCollection
            cell.configure(with: viewModel.relatedMangaList, sectionName: L10n.categories.manga)
            cell.onItemTapped = { [weak self] id in
                self?.navigateToDetails(id: id, type: .mangas)
            }
            return cell
        case .comments:
            let lastRow = viewModel.comments.count + 1
            if indexPath.row == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: CommentsHeader.identifier, for: indexPath) as! CommentsHeader
                cell.configure(canLoadMore: viewModel.canLoadMore)
                cell.onShowAllButtonTapped = { [weak self] in
                    self?.viewModel.moreComments()
                }
                return cell
            } else if indexPath.row == lastRow {
                let cell = tableView.dequeueReusableCell(withIdentifier: CommentInputCell.identifier, for: indexPath) as! CommentInputCell
                commentInputCell = cell
                cell.onSend = { [weak self] text, replyToId in
                    self?.viewModel.sendComment(body: text, replyToId: replyToId)
                }
                cell.onCancelReply = {}
                cell.onHeightChanged = { [weak tableView] in
                    tableView?.beginUpdates()
                    tableView?.endUpdates()
                }
                return cell
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: UniversalCommentsCell.identifier, for: indexPath) as! UniversalCommentsCell
                let data = viewModel.comments.reversed()[indexPath.row - 1]
                cell.configure(with: data)
                cell.isUserTapped = { [weak self] id in
                    guard let self else { return }
                    let vm = ProfileViewModel(userId: id)
                    let vc = ProfileViewController(viewModel: vm)
                    navigationController?.pushViewController(vc, animated: true)
                }
                cell.isImageTapped = { [weak self] array, index in
                    guard let self else { return }
                    let vc = FullScreenImagesVC(urls: array, startIndex: index)
                    vc.modalPresentationStyle = .overFullScreen
                    vc.modalTransitionStyle = .crossDissolve
                    present(vc, animated: true)
                }
                cell.onSpoilerToggle = { [weak tableView] in
                    tableView?.beginUpdates()
                    tableView?.endUpdates()
                }
                cell.onYoutubeTapped = { videoId in
                    let appUrl = URL(string: "youtube://\(videoId)")!
                    let webUrl = URL(string: "https://www.youtube.com/watch?v=\(videoId)")!
                    if UIApplication.shared.canOpenURL(appUrl) {
                        UIApplication.shared.open(appUrl)
                    } else {
                        UIApplication.shared.open(webUrl)
                    }
                }
                cell.onReplyTapped = { [weak self] commentId, nickname in
                    guard let self else { return }
                    if let section = self.viewModel.numberOfSections.firstIndex(of: .comments) {
                        let inputRow = IndexPath(row: self.viewModel.comments.count + 1, section: section)
                        self.characterView?.tableView.scrollToRow(at: inputRow, at: .bottom, animated: true)
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                            self.commentInputCell?.setReply(to: nickname, commentId: commentId)
                        }
                    }
                }
                return cell
            }
        }
    }
}

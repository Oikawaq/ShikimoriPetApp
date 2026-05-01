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
        viewModel.loadData()
        setupBindings()
    }
    private func setupTableView() {
        characterView?.tableView.dataSource = self
        characterView?.tableView.delegate = self
        characterView?.tableView.register(CharacterheaderCell.self, forCellReuseIdentifier: CharacterheaderCell.identifier)
        characterView?.tableView.register(DescriptionCell.self, forCellReuseIdentifier: DescriptionCell.identifier)
        characterView?.tableView.register(UniversalRowDataCell.self, forCellReuseIdentifier: UniversalRowDataCell.identifier)
        characterView?.tableView.register(UniversalTableViewWithCollection.self, forCellReuseIdentifier: UniversalTableViewWithCollection.identifier)
    }
    private func setupBindings() {
        Publishers.CombineLatest(viewModel.$fullCharacterDetails, viewModel.$isFavorite)
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
        return 1
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let sections = viewModel.numberOfSections[indexPath.section]
        switch sections {
        case .header:
            let cell = tableView.dequeueReusableCell(withIdentifier: CharacterheaderCell.identifier, for: indexPath) as! CharacterheaderCell
            let headerModel =  CharacterHeaderModel(
                name: viewModel.name, imageURL: viewModel.imageURL, isFavorite: viewModel.isFavorite
            )
            cell.configure(with: headerModel)
            cell.onFavoriteTapped = {[weak self] in
                self?.viewModel.toggleFavorite()
            }
            return cell
        case .description:
            let cell = tableView.dequeueReusableCell(withIdentifier: DescriptionCell.identifier, for: indexPath) as! DescriptionCell
            cell.configure(with: viewModel.description)
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
        }
    }
}

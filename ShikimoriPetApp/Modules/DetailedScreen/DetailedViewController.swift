//
//  DetailedViewControllerTest.swift
//  ShikimoriPetApp
//
//  Created by Иван Илькив on 4/9/26.
//

import Foundation
import UIKit
import Kingfisher
import Combine


final class DetailedViewController: UIViewController {
    private var cancellables: Set<AnyCancellable> = []
    private let viewModel: DetailedViewModel
    private var detailView: DetailView? {
           view as? DetailView
       }

        //MARK: init
    init(viewModel: DetailedViewModel){
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
        //MARK: lifecycle
    override func loadView() {
        view = DetailView()
    }
    override func viewDidLoad() {
        setupTableView()
        setupBindings()
        Task{
            await viewModel.loadAllData()
        }
       
        
        
    }
   
    private func setupBindings(){

        Publishers.CombineLatest4(
            viewModel.$anime,
            viewModel.$authorsRowData,
            viewModel.$characters,
            viewModel.$relatedRowData
        )
        .receive(on: DispatchQueue.main)
        .sink { [weak self] _ in
            self?.detailView?.tableView.reloadData()
        }
        .store(in: &cancellables)
        viewModel.$isFavorite
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.detailView?.tableView.reloadData()
            }
            .store(in: &cancellables)
    }
    private func setupTableView(){
        detailView?.tableView.dataSource = self
        detailView?.tableView.delegate = self
        detailView?.tableView.register(DetailedHeaderCell.self, forCellReuseIdentifier: DetailedHeaderCell.identifier)
        detailView?.tableView.register(StudioCell.self, forCellReuseIdentifier: StudioCell.identifier)
        detailView?.tableView.register(InformationCell.self, forCellReuseIdentifier: InformationCell.identifier)
        detailView?.tableView.register(DescriptionCell.self, forCellReuseIdentifier: DescriptionCell.identifier)
        detailView?.tableView.register(AuthorsCell.self, forCellReuseIdentifier: AuthorsCell.identifier)
        detailView?.tableView.register(RelatedCell.self, forCellReuseIdentifier: RelatedCell.identifier)
        detailView?.tableView.register(CharacterCell.self, forCellReuseIdentifier: CharacterCell.identifier)
        detailView?.tableView.register(ScreenshotsTableCell.self, forCellReuseIdentifier: ScreenshotsTableCell.identifier)
    }
}

extension DetailedViewController: UITableViewDataSource, UITableViewDelegate{
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.NumberOfSections.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let section = viewModel.NumberOfSections[indexPath.section]
        switch section{
        case .header:
            let data = HeaderModel(
                titleName: viewModel.title,
                imageURL: viewModel.imageURL,
                rating: viewModel.numericScore,
                ratingText: viewModel.ratingText,
                score: viewModel.score,
                tags: viewModel.tagsData,
                userRateButtontext: viewModel.statusButtonText,
                isFavorite: viewModel.isFavorite
            )
            
            let cell = tableView.dequeueReusableCell(withIdentifier: DetailedHeaderCell.identifier) as! DetailedHeaderCell
            
            cell.onUserRateTapped = {[weak self] in
                guard let self = self else {return}
                let vm = viewModel.makeRateEditorVM()
                let vc = RateEditorVC(viewModel: vm)
                if let sheet = vc.sheetPresentationController {
                    sheet.detents = [.medium(), .large()]
                    sheet.prefersGrabberVisible = true
                }
                present(vc, animated: true)
            }
            cell.onFavoriteTapped = {[weak self] in
                guard let self = self else {return}
                self.viewModel.toggleFavorite()
            }
            cell.configure(with: data)
            return cell
        case .studio:
            let cell = tableView.dequeueReusableCell(withIdentifier: StudioCell.identifier) as! StudioCell
            cell.configure(with: viewModel.studiosImage)
            return cell
        case .information:
            let cell = tableView.dequeueReusableCell(withIdentifier: InformationCell.identifier) as! InformationCell
            cell.configureInfoBlock(with: viewModel.infoDetails)
            return cell
        case .description:
            let cell = tableView.dequeueReusableCell(withIdentifier: DescriptionCell.identifier) as! DescriptionCell
            cell.configure(with: viewModel.description)
            return cell
        case .related:
            let cell = tableView.dequeueReusableCell(withIdentifier: RelatedCell.identifier) as! RelatedCell
            cell.configure(with: viewModel.relatedRowData)
            return cell
        case .authors:
            let cell = tableView.dequeueReusableCell(withIdentifier: AuthorsCell.identifier) as! AuthorsCell
            cell.configure(with: viewModel.authorsRowData)
            return cell
        case .characters:
            let cell = tableView.dequeueReusableCell(withIdentifier: CharacterCell.identifier) as! CharacterCell
            let characters = viewModel.characters.map{ characters in
                let data = characters.character
                return data
            }
            
            cell.onCharacterTapped = {[weak self] id in
                guard let self = self else {return}
                let vm = CharacterViewModel(characterId: id)
                let vc = CharacterViewController(viewModel: vm)
                navigationController?.pushViewController(vc, animated: true)
            }
            cell.configure(with: characters)
            return cell
        case .posters:
            let cell = tableView.dequeueReusableCell(withIdentifier: ScreenshotsTableCell.identifier) as! ScreenshotsTableCell
            let screenshot = viewModel.screenshotsPreview
            cell.onScreenshotTapped = {[weak self] screenshots, index in
                guard let self = self else {return}
                let vc = FullScreenImagesVC(urls: viewModel.screenshotOriginal, startIndex: index)
                vc.modalPresentationStyle = .overFullScreen
                vc.modalTransitionStyle = .crossDissolve
                present(vc, animated: true)
            }
            cell.configure(with: screenshot)
            return cell
        
        }
        
    }
    
}

//
//  CharacterProfileVC.swift
//  ShikimoriPetApp
//
//  Created by Иван Илькив on 3/3/26.
//

import Foundation
import UIKit
import Kingfisher
import Combine
class CharacterProfileVC: UIViewController {
    private var cancellables = Set<AnyCancellable>()
    private let viewModel: CharacterViewModel
    private var characterView: CharacterView? {
           view as? CharacterView
       }
        //MARK: init
    init(viewModel: CharacterViewModel){
            self.viewModel = viewModel
            super.init(nibName: nil, bundle: nil)
        }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
        //MARK: lifecycle
    override func loadView() {
        self.view = CharacterView()
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        setupBindings()
        viewModel.loadData()
        setupButtonsAction()
        setupCollectionView()
    }
        //MARK: SetupUI
    
    private func setupCollectionView(){
        characterView?.relatedAnimeCollectionView.dataSource = self
        characterView?.relatedMangaCollectionView.dataSource = self
        
        characterView?.relatedAnimeCollectionView.delegate = self
        characterView?.relatedMangaCollectionView.delegate = self
        
    }
    private func setupBindings(){
        viewModel.$fullCharacterDetails
            .receive(on: DispatchQueue.main)
            .sink{[weak self] _ in
                guard let self = self else {return}
                self.updateUI()
                characterView?.relatedAnimeCollectionView.reloadData()
                characterView?.relatedMangaCollectionView.reloadData()
                
            }
            .store(in: &cancellables)
        viewModel.$isFavorite
            .receive(on: DispatchQueue.main)
            .sink{[weak self] isFavorite in
                let image = isFavorite
                ? UIImage(systemName: "star.fill")!
                : UIImage(systemName: "star")!
                self?.characterView?.favoriteButton.setImage(image, for: .normal)
            }
            .store(in: &cancellables)
    }
    private func setupButtonsAction(){
  
        characterView?.favoriteButton.addTarget(self, action: #selector(favoritesTapped), for: .touchUpInside)
    }
    @objc func favoritesTapped(){
        viewModel.toggleFavorite()
    }
    
    private func updateUI(){
        characterView?.name.text = viewModel.name
        characterView?.descriptionLabel.text = viewModel.description
        if let url = viewModel.imageURL {
            characterView?.posterImageView.kf.setImage(
                with: url,
                options: [.backgroundDecode, .cacheOriginalImage ])
        }
 
        characterView?.seyuStackView.configure(with: viewModel.seyu)
//        detailView?.relatedAnimeStackView.configure(with: viewModel.relatedAnime)
//        detailView?.relatedAnimeStackView.onItemTapped = {[weak self ] id in
//        guard let self else {return}
//            let vm = DetailedViewModel(animeID: id, type: )
//            vm.loadData()
//            let vc = DetailedViewController(viewModel: vm)
//            navigationController?.pushViewController(vc, animated: true)
//        }
    }
}

extension CharacterProfileVC: UICollectionViewDelegateFlowLayout, UICollectionViewDelegate, UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return collectionView == characterView?.relatedAnimeCollectionView ? viewModel.animesListCount :
                viewModel.mangasListCount
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == characterView?.relatedAnimeCollectionView {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: UniversalCollectionViewCell.identifier, for: indexPath) as? UniversalCollectionViewCell else{
                return UICollectionViewCell()
            }
            guard let anime = viewModel.fullCharacterDetails?.animes[indexPath.item] else { return UICollectionViewCell()}
            cell.configure(with: anime)
            return cell
        }
        else{
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: UniversalCollectionViewCell.identifier, for: indexPath) as? UniversalCollectionViewCell else { return UICollectionViewCell()}
          guard let mangas = viewModel.fullCharacterDetails?.mangas[indexPath.item] else { return UICollectionViewCell()}
            cell.configure(with: mangas)
            return cell
        }
        
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == characterView?.relatedAnimeCollectionView {
            
            let animeID = viewModel.fullCharacterDetails?.animes[indexPath.item].id ?? 0
            
            let vm = DetailedViewModel(itemId: animeID, contentType: .animes)
            let vc = DetailedViewController(viewModel: vm)
            navigationController?.pushViewController(vc, animated: true)
        }else{
            let mangaId = viewModel.fullCharacterDetails?.mangas[indexPath.item].id ?? 0
            
            let vm = DetailedViewModel(itemId: mangaId, contentType: .mangas)
            let vc = DetailedViewController(viewModel: vm)
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 15
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 100, height: 200)
    }
}

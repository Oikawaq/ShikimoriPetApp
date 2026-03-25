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
    private var detailView: CharacterView? {
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
    }
        //MARK: SetupUI
    private func setupBindings(){
        viewModel.$fullCharacterDetails
            .receive(on: DispatchQueue.main)
            .sink{[weak self] _ in
                self?.updateUI()
            }
            .store(in: &cancellables)
    }
    private func updateUI(){
        detailView?.name.text = viewModel.name
        detailView?.descriptionLabel.text = viewModel.description
        if let url = viewModel.imageURL {
            detailView?.posterImageView.kf.setImage(
                with: url,
                options: [.backgroundDecode, .cacheOriginalImage ])
        }
 
        detailView?.seyuStackView.configure(with: viewModel.seyu)
        detailView?.relatedAnimeStackView.configure(with: viewModel.relatedAnime)
        detailView?.relatedAnimeStackView.onItemTapped = {[weak self ] id in
        guard let self else {return}
            let vm = DetailedViewModel(animeID: id)
            vm.loadData()
            let vc = DetailedViewController(viewModel: vm)
            navigationController?.pushViewController(vc, animated: true)
        }
    }
}

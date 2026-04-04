//
//  MainViewModel.swift
//  ShikimoriPetApp
//
//  Created by Иван Илькив on 2/18/26.
//

import Foundation
import Combine

class MainViewModel {
    @Published var content: [ContentListModel] = []
    @Published var contentType: ContentType = .animes

    var currentPage: Int = 1
    
  

    func loadNextPage() {
        currentPage += 1
        loadTypeData(currentPage: currentPage,type: contentType)
    }

    func loadPreviousPage() {
        guard currentPage > 1 else { return }
        currentPage -= 1
        loadTypeData(currentPage: currentPage,type: contentType)
    }
    func switchContent(to type: ContentType){
        contentType = type
        content = []
        currentPage = 1
        loadContent(currentPage: currentPage, to: type)
        
    }
    private func loadContent(currentPage: Int, to Type: ContentType){
        switch contentType {
        case .animes: loadTypeData(currentPage: currentPage,type: .animes)
        case .mangas: loadTypeData(currentPage: currentPage,type: .mangas)
        case .ranobe: loadTypeData(currentPage: currentPage,type: .ranobe)
        }
    }
    private func loadTypeData(currentPage: Int,type: ContentType) {
        NetworkManager.shared.request(endpoint: .loadTypeData(page: currentPage, limit: 20, contentType: type), method: .get)
            .replaceError(with: [])
            .receive(on: DispatchQueue.main)
            .assign(to: &$content)
    }
    
}

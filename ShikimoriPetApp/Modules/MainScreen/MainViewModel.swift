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
    @Published var filters : Filters = Filters(page: 1, order: .ranked, kind: nil, status: nil)
    var currentPage: Int = 1
    
  

    func loadNextPage() {
        currentPage += 1
        loadTypeData(currentPage: currentPage,type: contentType,filters: filters)
    }

    func loadPreviousPage() {
        guard currentPage > 1 else { return }
        currentPage -= 1
        loadTypeData(currentPage: currentPage,type: contentType,filters: filters)
    }
    func switchContent(to type: ContentType, filter: Filters){
        contentType = type
//        content = []
        currentPage = 1
        loadContent(currentPage: currentPage, to: type,filters: filter)
        
    }
    private func loadContent(currentPage: Int, to Type: ContentType, filters: Filters){
        switch contentType {
        case .animes: loadTypeData(currentPage: currentPage,type: .animes,filters: filters)
        case .mangas: loadTypeData(currentPage: currentPage,type: .mangas,filters: filters)
        case .ranobe: loadTypeData(currentPage: currentPage,type: .ranobe,filters: filters)
        }
    }
    private func loadTypeData(currentPage: Int,type: ContentType, filters: Filters) {
        NetworkManager.shared.request(endpoint: .loadTypeData(page: currentPage, contentType: type, filters: filters), method: .get)
            .replaceError(with: [])
            .receive(on: DispatchQueue.main)
            .assign(to: &$content)
    }
    
}

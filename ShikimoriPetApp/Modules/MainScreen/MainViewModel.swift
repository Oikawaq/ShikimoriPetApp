//
//  MainViewModel.swift
//  ShikimoriPetApp
//
//  Created by Иван Илькив on 2/18/26.
//

import Foundation
import Combine

class MainViewModel {
    @Published var anime: [AnimeList] = []
    
    var onDataLoaded:(() -> Void)?
    var onError:(() -> Void)?
    var currentPage: Int = 1
    
    func loadNextPage() {
        currentPage += 1
        loadAnimeList(currentPage: currentPage)
    }

    func loadPreviousPage() {
        guard currentPage > 1 else { return }
        currentPage -= 1
        loadAnimeList(currentPage: currentPage)
    }
    
    func loadAnimeList(currentPage: Int) {
        NetworkManager.shared.request(endpoint: .animeList(page: currentPage, limit: 20), method: .get)
            .replaceError(with: [])
            .receive(on: DispatchQueue.main)
            .assign(to: &$anime)
    }
    
}

//
//  FavouritesManager.swift
//  ShikimoriPetApp
//
//  Created by Иван Илькив on 3/25/26.
//

import Foundation
import Combine

class FavouritesManager {
    static let shared = FavouritesManager()
    private init(){}

    private var cancellables: Set<AnyCancellable> = []

    
    @Published private(set) var isLoaded = false
    
    var store: [FavoriteType: Set<Int>] = [
         .anime: [],
         .manga: [],
         .ranobe: [],
         .character: []
     ]
    func contains(_ id : Int, type: FavoriteType)-> Bool{
        store[type]?.contains(id) ?? false
    }
    func toggleFavorite(id: Int, type: FavoriteType){
       
        if contains(id, type: type){
           
            deleteFromFavorites(id: id, type: type)
            
        } else{
            addToFavorites(id: id, type: type)
        }
    }
    
    private func addToFavorites(id: Int, type: FavoriteType){
        store[type]?.insert(id)
        NetworkManager.shared.requestVoid(endpoint: .addToFavorites(id: id, type: type), method: .post)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: {[weak self] completion in
                if case .failure = completion{
                    self?.store[type]?.remove(id)
                    print("Add favorite failed, rolling back")
                }
            }, receiveValue: {_ in
                    print("added")
            })
            .store(in: &cancellables)
    }
    
    private func deleteFromFavorites(id: Int, type: FavoriteType){
        store[type]?.remove(id)
        NetworkManager.shared.requestVoid(endpoint: .deleteFromFavorites(id: id, type: type), method: .delete)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: {[weak self] completion in
                if case .failure = completion {
                    self?.store[type]?.insert(id)
                    print("Delete favorite failed")
                }
            }, receiveValue: {_ in })
            .store(in: &cancellables)
    }
    func loadFavorites(userID: Int) {
        NetworkManager.shared.request(endpoint: .loadFavourites(id: userID), method: .get)
            .receive(on: DispatchQueue.main)
            .sink(
                receiveCompletion: { completion in
                    if case .failure(let error) = completion {
                        print("Favorites error: \(error)")
                    }
                },
                receiveValue: { [weak self] (favorites: UserFavourites) in
                    guard let self = self else { return }
                    self.store[.anime] = Set(favorites.animes.map { $0.id })
                    self.store[.manga] = Set(favorites.mangas.map { $0.id })
                    self.store[.ranobe] = Set(favorites.ranobe.map { $0.id })
                    self.store[.character] = Set(favorites.characters.map { $0.id })
                    self.isLoaded = true
                }
            )
            .store(in: &cancellables)
    }
}

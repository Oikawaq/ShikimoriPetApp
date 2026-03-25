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

    private var animeIDs: Set<Int> = []
    private var mangaIDs: Set<Int> = []
    private var characterIDs: Set<Int> = []
    private var ranobeIDs: Set<Int> = []
        
    let userID = UserDefaults.standard.integer(forKey: "current_user_id")
    
    
//    func loadFavorites() async {
//          let favorites = try? await NetworkManager.shared.fetch(endpoint: .loadFavourites(id: userID))
//          animeIDs = Set(favorites?.anime?.map { $0.id } ?? [])
//          mangaIDs = Set(favorites?.manga?.map { $0.id } ?? [])
//          characterIDs = Set(favorites?.characters?.map { $0.id } ?? [])
//          ranobeIDs = Set(favorites?.ranobe?.map { $0.id } ?? [])
//      }
    func loadFavourites1(){
        
    }
}

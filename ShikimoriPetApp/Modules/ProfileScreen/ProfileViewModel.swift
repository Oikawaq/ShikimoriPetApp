//
//  ProfileViewModel.swift
//  ShikimoriPetApp
//
//  Created by Иван Илькив on 3/7/26.
//

import Foundation
import Combine
import UIKit

class ProfileViewModel {
    var userId: Int
    @Published var profileData: ProfileUserModel?
    var favoritesList: [UniversalType]{
        guard let favorites = userFavorites else{return []}
        return favorites.animes.map { var i = $0; i.type = .anime; return i }
                 + favorites.characters.map { var i = $0; i.type = .character; return i }
                 + favorites.mangas.map { var i = $0; i.type = .manga; return i }
                 + favorites.ranobe.map { var i = $0; i.type = .ranobe; return i }
    }
    
    var animeArraySize: Int{
        if let animeArray = profileData?.stats.statuses.anime{
            let totalSize = animeArray.filter{ $0.name != "completed" && $0.name != "dropped"}
                .reduce(0){$0 + $1.size }
            return totalSize
            
        }
        return 0
    }
    var animeSegment: [Segment]{
        let animeSize: Int = profileData?.stats.statuses.anime[2].size ?? 0
 
        let segment1 = Segment(value: animeSize, color: .blue, label: "Просмотренно")
        let segment2 = Segment(value: animeArraySize, color: .red, label: "Просмотренно")
        
        if let segments = profileData?.stats.statuses.anime{
            
        }
               
        
        let array: Array = [segment1,segment2]
        return array
    }
    var userData: UserModel?
    
    var username: String? {
        return profileData?.nickname
    }
    var imageURL: URL? {
        return URL(string: profileData?.image?.x160 ?? "")
    }
    var userAge: String? {
        return profileData?.fullYears?.description
    }

    @Published var userFriendsList: [UserFriendsModel] = []
    @Published var userFavorites: UserFavourites?
        //MARK: init
    
    init(userId: Int) {
        self.userId = userId
    }
   
        //MARK: network
    func loadUserData(){
        NetworkManager.shared.request(endpoint: .userData(id: userId), method: .get)
            .replaceError(with: nil)
            .receive(on: DispatchQueue.main)
            .assign(to: &$profileData)
    }
    func loadUserFriends(){
        NetworkManager.shared.request(endpoint: .loadUserFriends(id: userId, limit: 5), method: .get)
            .replaceError(with: [])
            .receive(on: DispatchQueue.main)
            .assign(to: &$userFriendsList)
    }
    func loadUserFavorites(){
        NetworkManager.shared.request(endpoint: .loadFavourites(id: userId), method: .get)
            .replaceError(with: nil)
            .receive(on: DispatchQueue.main)
            .assign(to: &$userFavorites)
       
    }
    
}

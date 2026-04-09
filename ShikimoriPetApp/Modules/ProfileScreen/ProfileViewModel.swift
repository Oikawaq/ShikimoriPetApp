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
    var animeBlockDescription: String {
        return createDescriptionForSegmentList(
            list: createSegmentList(list: profileData?.stats.statuses.anime, color: .systemBlue)
           )
    }
    var mangaBlockDescription: String{
        return createDescriptionForSegmentList(
            list: createSegmentList(list: profileData?.stats.statuses.manga, color: .systemPink)
           )
    }
    func createDescriptionForSegmentList(list: [Segment]) -> String {
        let total = list.reduce(0) { $0 + $1.value }
        return total > 0 ? "Список: \(total)" : "Список пуст"
    }
    func createSegmentList(list: [ItemsUniversalModel]?, color: UIColor) -> [Segment] {
        guard let array = list else { return [] }
        
        var completedSize = 0
        var activeSize = 0
        var droppedSize = 0
        let color = color
        array.forEach { item in
            let status = WatchingStatus(rawValue: item.name) ?? .none
            switch status {
            case .completed:
                completedSize += item.size
            case .watching, .rewatching, .planned, .onHold:
                activeSize += item.size
            case .dropped:
                droppedSize += item.size
            case .none:
                break
            }
        }
        
             return [
                Segment(value: completedSize, color: color,  status: .completed),
                Segment(value: activeSize,    color: color.withAlphaComponent(0.5),   status: .watching),
                Segment(value: droppedSize,   color: .systemGray,  status: .dropped)
            ].filter { $0.value > 0 }
            .sorted { $0.value > $1.value }
       
        
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

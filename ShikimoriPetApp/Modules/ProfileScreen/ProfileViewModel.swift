//
//  ProfileViewModel.swift
//  ShikimoriPetApp
//
//  Created by Иван Илькив on 3/7/26.
//

import Foundation
import Combine

class ProfileViewModel {
    var userId: Int
    @Published var profileData: ProfileUserModel?
    
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
    
}

//
//  ProfileViewModel.swift
//  ShikimoriPetApp
//
//  Created by Иван Илькив on 3/7/26.
//

import Foundation
import Combine

class ProfileViewModel {
    
    @Published var profileData: ProfileUserModel?

    var userData: UserModel?
    
    var username: String? {
        return profileData?.nickname
    }
    var imageURL: URL? {
        return URL(string: profileData?.image?.x160 ?? "")
    }
    
  
    func loadUserData(id: Int){
        NetworkManager.shared.fetch(endpoint: .userData(id: id))
            .replaceError(with: nil)
            .receive(on: DispatchQueue.main)
            .assign(to: &$profileData)
    }
    
}

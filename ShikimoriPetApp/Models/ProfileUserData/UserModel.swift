//
//  UserData.swift
//  ShikimoriPetApp
//
//  Created by Иван Илькив on 3/7/26.
//

import Foundation

struct UserModel: Codable, UserRepresentable {
   
    
    let id: Int
    let nickname: String
    let fullYears: Int?
    let image: ImagesSize?
    
    var avatarURLString: String? {
        return image?.x148
    }
}



//
//  UserModel.swift
//  ShikimoriPetApp
//
//  Created by Иван Илькив on 3/7/26.
//

import Foundation

struct ProfileUserModel: Decodable, UserRepresentable{
    
    let id: Int
    let nickname: String
    let fullYears: Int?
    let image: ImagesSize?
    let stats: StatusesModel
    var avatarURLString: String?{
        return image?.x160
    }
}



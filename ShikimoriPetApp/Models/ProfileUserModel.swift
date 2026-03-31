//
//  UserModel.swift
//  ShikimoriPetApp
//
//  Created by Иван Илькив on 3/7/26.
//

import Foundation

struct ProfileUserModel: Codable, UserRepresentable{
    
    let id: Int
    let nickname: String
    let fullYears: Int?
    let image: Images?
    
    var avatarURLString: String?{
        return image?.x160
    }
}
struct Images: Codable{
    let x160: String
    let x148: String
    let x80: String
    let x48: String
    let x32: String
}
struct UserFriendsModel: Codable, UniversalCellProtocol{
    var cellTitle:String {nickname ?? "Unknown"}
    
    var cellImage: String? { image?.x160 ?? ""}
    
    let id: Int?
    let nickname: String?
    let image: Images?
}

//
//  UserFriendsModel.swift
//  ShikimoriPetApp
//
//  Created by Иван Илькив on 4/4/26.
//


struct UserFriendsModel: Codable, UniversalCellProtocol{
    var cellTitle:String {nickname ?? "Unknown"}
    
    var cellImage: String? { image?.x160 ?? ""}
    
    let id: Int?
    let nickname: String?
    let image: ImagesSize?
}
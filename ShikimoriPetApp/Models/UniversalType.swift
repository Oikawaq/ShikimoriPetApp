//
//  UniversalType.swift
//  ShikimoriPetApp
//
//  Created by Иван Илькив on 3/31/26.
//


import Foundation
struct UniversalType: Decodable, UniversalCellProtocol{
    var itemId: Int { id } 
    
    var cellTitle: String { russian ?? name }
    
    var cellImage: String? { image?.replacingOccurrences(of: "/x64/", with: "/original/") }
    

    let id: Int
    let name: String
    let russian: String?
    let image: String?
    var type: FavoriteType?
}
struct test: Decodable, UniversalCellProtocol{
    var itemId: Int { id }
    
    var cellTitle: String { russian ?? name }
    
    var cellImage: String? { image?.original}
    

    let id: Int
    let name: String
    let russian: String?
    let image: DefaultImageModel?
    var type: FavoriteType?
}

//
//  UniversalType.swift
//  ShikimoriPetApp
//
//  Created by Иван Илькив on 3/31/26.
//


import Foundation
struct UniversalType: Decodable, UniversalCellProtocol{
    var cellTitle: String { russian ?? name }
    
    var cellImage: String? { image?.replacingOccurrences(of: "/x64/", with: "/original/") }
    

    let id: Int
    let name: String
    let russian: String?
    let image: String?
    var type: FavoriteType?
}

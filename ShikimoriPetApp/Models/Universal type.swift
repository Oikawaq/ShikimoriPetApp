//
//  Universal type.swift
//  ShikimoriPetApp
//
//  Created by Иван Илькив on 3/25/26.
//

import Foundation
enum FavoriteType: String, Decodable {
    case anime = "Anime"
    case manga = "Manga"
    case character = "Character"
    case ranobe = "Ranobe"
}

struct UniversalType: Decodable, UniversalCellProtocol{
    var cellTitle: String { russian ?? name }
    
    var cellImage: String? { image?.replacingOccurrences(of: "/x64/", with: "/original/") }
    

    let id: Int
    let name: String
    let russian: String?
    let image: String?
    var type: FavoriteType?
}


//
//  RelatedAnime.swift
//  ShikimoriPetApp
//
//  Created by Иван Илькив on 3/12/26.
//

import Foundation

struct RelatedAnime : Decodable {
    let relation: String
    let relationRussian: String
    let anime: universalType?
    let manga: universalType?
    
}

struct universalType: Decodable, UniversalCellProtocol {
    var cellTitle: String { russian ?? name }
    
    var cellImage: String? {image?.original}
    
    let id: Int
    let name: String
    let russian: String?
    let image: CharacterImage?
    var type: FavoriteType?
}

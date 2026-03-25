//
//  RelatedAnime.swift
//  ShikimoriPetApp
//
//  Created by Иван Илькив on 3/12/26.
//

import Foundation

struct RelatedAnime : Codable {
    let relation: String
    let relationRussian: String
    let anime: universalType?
    let manga: universalType?
    
}

struct universalType: Codable {
    let id: Int
    let name: String
    let russian: String
    let image: CharacterImage?
}

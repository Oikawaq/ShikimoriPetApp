//
//  CharacterDetail.swift
//  ShikimoriPetApp
//
//  Created by Иван Илькив on 3/3/26.
//

import Foundation


struct CharacterDetail: Decodable {
    let id: Int
    let name: String
    let russian: String
    let description: String?
    let image: CharacterImage?
    let seyu: [Seyu]?
    let animes: [universalType]
    let mangas: [universalType]
}

struct Seyu: Decodable{
    let id: Int
    let name: String?
    let russian: String?
    let image: CharacterImage?
}

struct Animes: Decodable{
    let id: Int?
    let name: String?
    let russian: String?
    let image: CharacterImage?
    
}

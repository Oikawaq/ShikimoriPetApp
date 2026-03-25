//
//  CharacterDetail.swift
//  ShikimoriPetApp
//
//  Created by Иван Илькив on 3/3/26.
//

import Foundation


struct CharacterDetail: Codable {
    let id: Int
    let name: String
    let russian: String
    let description: String?
    let image: CharacterImage?
    let seyu: [Seyu]?
    let animes: [Animes]
}

struct Seyu: Codable{
    let id: Int
    let name: String?
    let russian: String?
    let image: CharacterImage?
}

struct Animes: Codable{
    let id: Int?
    let name: String?
    let russian: String?
    let image: CharacterImage?
    
}

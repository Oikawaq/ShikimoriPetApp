//
//  CharacterDetail.swift
//  ShikimoriPetApp
//
//  Created by Иван Илькив on 3/3/26.
//

import Foundation


struct CharacterDetailModel: Decodable {
    let id: Int
    let name: String
    let russian: String
    let description: String?
    let image: DefaultImageModel?
    let seyu: [SeyuModel]?
    let animes: [universalType]
    let mangas: [universalType]
}



struct Animes: Decodable{
    let id: Int?
    let name: String?
    let russian: String?
    let image: DefaultImageModel?
    
}

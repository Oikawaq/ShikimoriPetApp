//
//  AnimeModel.swift
//  ShikimoriPetApp
//
//  Created by Иван Илькив on 4/6/26.
//

struct AnimeModel: Decodable{
    
    let id: Int
    let name: String
    let russian: String?
    let image: DefaultImageModel
    let kind: String
    let score: String?
    let episodes: Int?
    let episodesAired: Int?
    let status: String
    
}

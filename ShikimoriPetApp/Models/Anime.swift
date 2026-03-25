//
//  Anime.swift
//  ShikimoriPetApp
//
//  Created by Иван Илькив on 2/28/26.
//

import Foundation

struct Anime: Codable{
    let id: Int
    let description: String?
    let duration: Int?
    let kind : String?
    let status: String?
    let episodes: Int?
    let episodesAired: Int?
    let ongoing: Bool?
    let name:String?
    let russian: String?
    let image: CharacterImage?
    let airedOn: String?
    let score: String?
    let studios: [Studios]
    let nextEpisodeAt: String?
}
struct CharacterRole: Codable{
    let character: Character?
    let roles: [String]
}
struct Character: Codable{
    let id: Int
    let name: String
    let russian: String?
    let image: CharacterImage?
    
}
struct CharacterImage: Codable {
    let original: String?
    let preview: String?
}
struct Studios: Codable{
    let id: Int?
    let name: String?
    let filteredName: String?
    let image: String?
}

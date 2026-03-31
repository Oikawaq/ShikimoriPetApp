//
//  Anime.swift
//  ShikimoriPetApp
//
//  Created by Иван Илькив on 2/28/26.
//

import Foundation

struct contentItem: Decodable{
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
    let studios: [Studios]?
    let nextEpisodeAt: String?
    let volumes: Int?
    let chapters: Int?
}
struct CharacterRole: Decodable{
    let character: Character?
    let roles: [String]
}
struct Character: Decodable, UniversalCellProtocol{
    
    var cellTitle: String { russian ?? name }
    
    var cellImage: String? {image?.original ?? image?.preview ?? "" }
    
    let id: Int
    let name: String
    let russian: String?
    let image: CharacterImage?
    
}
struct CharacterImage: Decodable {
    let original: String?
    let preview: String?
}
struct Studios: Codable{
    let id: Int?
    let name: String?
    let filteredName: String?
    let image: String?
}

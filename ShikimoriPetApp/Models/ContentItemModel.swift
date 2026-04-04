//
//  Anime.swift
//  ShikimoriPetApp
//
//  Created by Иван Илькив on 2/28/26.
//

import Foundation

struct ContentItemModel: Decodable{
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
    let image: DefaultImageModel?
    let airedOn: String?
    let score: String?
    let studios: [StudiosModel]?
    let nextEpisodeAt: String?
    let volumes: Int?
    let chapters: Int?
}





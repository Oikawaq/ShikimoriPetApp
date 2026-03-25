//
//  Anime.swift
//  ShikimoriPetApp
//
//  Created by Иван Илькив on 2/18/26.
//

import Foundation

struct AnimeList: Codable {
    let id: Int
    let name: String?
    let russian: String?
    let image: animeImage
    let url: String
    let score: String?
    let episodes: Int?
    let episodesAired: Int?
    let releasedOn: String?
    let status: String?
    let airedOn: String?
}
struct animeImage: Codable {
    let original: String?
    let preview: String?
}

//
//  Anime.swift
//  ShikimoriPetApp
//
//  Created by Иван Илькив on 2/18/26.
//

import Foundation

struct ContentList: Codable {
    let id: Int
    let name: String?
    let russian: String?
    let image: contentImage
    let score: String?
    let episodes: Int?
    let episodesAired: Int?
    let releasedOn: String?
    let status: String?
    let airedOn: String?
}
struct contentImage: Codable {
    let original: String?
    let preview: String?
}

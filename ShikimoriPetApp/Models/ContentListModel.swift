//
//  Anime.swift
//  ShikimoriPetApp
//
//  Created by Иван Илькив on 2/18/26.
//

import Foundation

struct ContentListModel: Decodable {
    let id: String
    let name: String?
    let russian: String?
    let image: String?
    let score: Double?
}
extension ContentListModel {
    init(anime: ShikimoriSchema.GetAnimeListQuery.Data.Anime) {
        self.russian = anime.russian
        self.score = anime.score
        self.id = anime.id
        self.name = anime.name
        self.image = anime.poster?.originalUrl
    }
    init(manga: ShikimoriSchema.GetMangaListQuery.Data.Manga) {
        self.russian = manga.russian
        self.score = manga.score
        self.id = manga.id
        self.name = manga.name
        self.image = manga.poster?.originalUrl
    }
}

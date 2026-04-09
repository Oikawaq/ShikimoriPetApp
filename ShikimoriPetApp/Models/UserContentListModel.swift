//
//  UserContentListModel.swift
//  ShikimoriPetApp
//
//  Created by Иван Илькив on 4/6/26.
//

import Foundation

struct UserContentListModel: Decodable{
    let id: Int
    let score: Int?
    let status: WatchingStatus
    let episodes: Int?
    let chapters: Int?
    let volumes: Int?
    let rewatches: Int?
    let anime: AnimeModel?
}

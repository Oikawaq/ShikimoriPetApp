//
//  UserContentListModel.swift
//  ShikimoriPetApp
//
//  Created by Иван Илькив on 4/6/26.
//

import Foundation

struct UserContentListModel: Decodable{
    let id: Int
    var score: Int?
    var status: WatchingStatus
    var episodes: Int?
    var chapters: Int?
    let volumes: Int?
    let rewatches: Int?
    let anime: ContentItemModel?
    let manga: ContentItemModel?
}

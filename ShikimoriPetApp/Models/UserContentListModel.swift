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
    let anime: ListItemModel?
    let manga: ListItemModel?
}
struct ListItemModel: Decodable{
    let id : Int
    let russian: String
    let name: String
    let episodesAired: Int
}

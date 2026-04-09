//
//  UniversalSectionModel.swift
//  ShikimoriPetApp
//
//  Created by Иван Илькив on 4/7/26.
//

import Foundation

struct UniversalSectionModel: Decodable{
    let status: WatchingStatus
    let anime: [UserContentListModel]
}

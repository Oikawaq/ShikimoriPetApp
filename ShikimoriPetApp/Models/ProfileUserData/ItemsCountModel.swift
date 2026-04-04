//
//  ItemsCountModel.swift
//  ShikimoriPetApp
//
//  Created by Иван Илькив on 4/4/26.
//

import Foundation

struct ItemsCountModel: Decodable {
    let anime: [ItemsUniversalModel]
    let manga: [ItemsUniversalModel]
}

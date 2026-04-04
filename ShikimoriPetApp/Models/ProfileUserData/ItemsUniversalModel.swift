//
//  ItemsUniversalModel.swift
//  ShikimoriPetApp
//
//  Created by Иван Илькив on 4/4/26.
//

import Foundation

struct ItemsUniversalModel: Decodable {
    let id: Int
    let groupedId: String
    let name: String
    let size: Int
    let type: String
    
}

//
//  CharacterHeaderModel.swift
//  ShikimoriPetApp
//
//  Created by Иван Илькив on 4/30/26.
//

import Foundation

struct CharacterHeaderModel: Codable {
    let name: String
    let imageURL: URL?
    let isFavorite: Bool
    
}

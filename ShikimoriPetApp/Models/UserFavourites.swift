//
//  UserFavouritesx.swift
//  ShikimoriPetApp
//
//  Created by Иван Илькив on 3/25/26.
//

import Foundation
struct UserFavourites: Decodable {
    let characters: [UniversalType]
    let animes: [UniversalType]
    let mangas: [UniversalType]
    let ranobe: [UniversalType]
}



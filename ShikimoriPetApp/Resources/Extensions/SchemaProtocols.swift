//
//  SchemaProtocols.swift
//  ShikimoriPetApp
//
//  Created by Иван Илькив on 5/24/26.
//

import Foundation
extension ShikimoriSchema.GetAnimeInfoQuery.Data.Anime.CharacterRole: UniversalCellProtocol{
    var cellTitle: String {
        character.russian ?? character.name
    }
    
    var cellImage: String? {
        character.poster?.originalUrl
    }
    
    var itemId: Int? {
        Int(character.id) ?? 0
    }
    
    
}

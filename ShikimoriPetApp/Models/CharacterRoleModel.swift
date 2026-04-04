//
//  CharacterRole.swift
//  ShikimoriPetApp
//
//  Created by Иван Илькив on 3/31/26.
//


struct CharacterRoleModel: Decodable{
    let character: CharacterModel?
    let roles: [String]
}

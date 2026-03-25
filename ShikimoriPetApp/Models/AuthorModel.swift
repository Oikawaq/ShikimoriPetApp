//
//  AuthorModel.swift
//  ShikimoriPetApp
//
//  Created by Иван Илькив on 3/10/26.
//

import Foundation

struct AuthorModel: Codable {
    let roles: [String]
    let rolesRussian: [String]
    let person: Person?
}
struct Person: Codable {
    let id: Int
    let name: String
    let russian: String
    let image: CharacterImage?
}

//
//  AuthorModel.swift
//  ShikimoriPetApp
//
//  Created by Иван Илькив on 3/10/26.
//

import Foundation

struct AuthorModel: Decodable {
    let roles: [String]
    let rolesRussian: [String]
    let person: Person?
    
}
struct Person: Decodable {
    let id: Int
    let name: String
    let russian: String
    let image: DefaultImageModel?
}

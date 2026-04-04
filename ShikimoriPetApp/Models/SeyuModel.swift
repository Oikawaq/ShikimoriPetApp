//
//  SeyuModel.swift
//  ShikimoriPetApp
//
//  Created by Иван Илькив on 3/31/26.
//


struct SeyuModel: Decodable{
    let id: Int
    let name: String?
    let russian: String?
    let image: DefaultImageModel?
}

//
//  HeaderModel.swift
//  ShikimoriPetApp
//
//  Created by Иван Илькив on 4/9/26.
//

import Foundation

struct HeaderModel{
    let titleName: String
    let imageURL: URL?
    let rating : Double
    let ratingText: String
    let score : String
    let tags: [DetailedViewModel.TagData]
    let userRateButtontext: String
    let isFavorite: Bool
}

//
//  WeatherModel.swift
//  ShikimoriPetApp
//
//  Created by Иван Илькив on 1/6/26.
//

import UIKit

struct TokenResponse: nonisolated Decodable {
    let accessToken: String
    let refreshToken: String
    let expiresIn: Int
    
    enum CodingKeys: String, CodingKey {
        case accessToken = "access_token"
        case refreshToken = "refresh_token"
        case expiresIn = "expires_in"
    }
}

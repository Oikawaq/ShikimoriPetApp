//
//  ShikimoriEndpoint.swift
//  ShikimoriPetApp
//
//  Created by Иван Илькив on 2/18/26.
//

import Foundation

enum ShikimoriEndpoint {
    case animeList(page: Int, limit: Int)
    case animeDetails(id: Int)
    case animeMainCharacters(id: Int)
    case characterDetails(id: Int)
    case screenshots(id: Int)
    case whoami
    case userData(id: Int)
    case authors(id: Int)
    case related(id: Int)
    case checkUserRates(userID: Int, targetID: Int)
    case userRateUpdate(linkID: Int)
    case deleteUserRate(linkID: Int)
    case createUserRate
    case favorites(id: Int)
    case loadFavourites(id: Int)
    case loadUserFriends(id: Int,limit: Int)
    var url: URL? {
        var components = URLComponents(string: "https://shikimori.io/api")
        switch self {
        case .animeList(let page, let limit):
            components?.path += "/animes"
            components?.queryItems = [
                URLQueryItem(name: "page", value: "\(page)"),
                URLQueryItem(name: "limit", value: "\(limit)"),
                URLQueryItem(name: "order", value: "ranked")
            ]
        case .animeDetails(let id):
            components?.path += "/animes/\(id)"
        case .animeMainCharacters(let id):
            components?.path += "/animes/\(id)/roles"
        case .characterDetails(let id):
            components?.path += "/characters/\(id)"
        case .screenshots(let id):
            components?.path += "/animes/\(id)/screenshots"
        case .whoami:
            components?.path += "/users/whoami"
        case .userData(let id):
            components?.path += "/users/\(id)"
        case .authors(let id):
            components?.path += "/animes/\(id)/roles"
        case .related(let id):
            components?.path += "/animes/\(id)/related"
        case .checkUserRates(let userID, let targetID):
            components?.path += "/v2/user_rates"
            components?.queryItems = [
                URLQueryItem(name: "user_id", value: "\(userID)"),
                URLQueryItem(name: "target_id", value: "\(targetID)"),
                URLQueryItem(name: "target_type", value: "Anime")
            ]
        case .userRateUpdate(let linkID):
            components?.path += "/v2/user_rates/\(linkID)"
        case .deleteUserRate(let linkID):
            components?.path += "/v2/user_rates/\(linkID)"
        case .createUserRate:
            components?.path += "/v2/user_rates/"
        case .favorites(let id):
            components?.path += "/favorites/Anime/\(id)"
        case .loadFavourites(let id):
            components?.path += "/users/\(id)/favourites/"
            
        case .loadUserFriends(let id, let limit):
            components?.path += "/users/\(id)/friends"
            components?.queryItems = [
                URLQueryItem(name: "limit", value: "\(limit)")
            ]
        }
        return components?.url
    }
}

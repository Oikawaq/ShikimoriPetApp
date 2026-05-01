//
//  ShikimoriEndpoint.swift
//  ShikimoriPetApp
//
//  Created by Иван Илькив on 2/18/26.
//

import Foundation

enum ShikimoriEndpoint {
    case loadTypeData(page: Int, limit: Int,contentType: ContentType)
    case contentDetails(id: Int,contentType: ContentType)
    case itemMainCharacters(id: Int,contentType: ContentType)
    case characterDetails(id: Int)
    case screenshots(id: Int, сontentType: ContentType)
    case whoami
    case userData(id: Int)
    case authors(id: Int,contentType: ContentType)
    case related(id: Int,contentType: ContentType)
    case checkUserRates(userID: Int, targetID: Int, contentType: ContentType)
    case userRateUpdate(linkID: Int)
    case deleteUserRate(linkID: Int)
    case createUserRate
    case loadFavourites(id: Int)
    case loadUserFriends(id: Int,limit: Int)
    case addToFavorites(id: Int, type: FavoriteType)
    case deleteFromFavorites(id: Int, type: FavoriteType)
    case userRatesList(id: Int,limit: Int = 5000)
    case search(limit:Int = 50, query: String, contentType: ContentType, order: String = "ranked")
    var url: URL? {
        var components = URLComponents(string: "https://shikimori.io/api")
        switch self {
        case .loadTypeData(let page, let limit,let contentType):
            components?.path += "/\(contentType)"
            components?.queryItems = [
                URLQueryItem(name: "page", value: "\(page)"),
                URLQueryItem(name: "limit", value: "\(limit)"),
                URLQueryItem(name: "order", value: "ranked")
            ]
        case .contentDetails(let id, let contentType):
            components?.path += "/\(contentType)/\(id)"
        case .itemMainCharacters(let id,let contentType):
            components?.path += "/\(contentType)/\(id)/roles"
        case .characterDetails(let id):
            components?.path += "/characters/\(id)"
        case .screenshots(let id, let contentType):
            components?.path += "/\(contentType)/\(id)/screenshots"
        case .whoami:
            components?.path += "/users/whoami"
        case .userData(let id):
            components?.path += "/users/\(id)"
        case .authors(let id,let contentType):
            components?.path += "/\(contentType)/\(id)/roles"
        case .related(let id, let contentType):
            components?.path += "/\(contentType)/\(id)/related"
        case .checkUserRates(let userID, let targetID,let contentType):
            components?.path += "/v2/user_rates"
            components?.queryItems = [
                URLQueryItem(name: "user_id", value: "\(userID)"),
                URLQueryItem(name: "target_id", value: "\(targetID)"),
                URLQueryItem(name: "target_type", value: "\(contentType.apiPath)")
            ]
        case .userRateUpdate(let linkID):
            components?.path += "/v2/user_rates/\(linkID)"
        case .deleteUserRate(let linkID):
            components?.path += "/v2/user_rates/\(linkID)"
        case .createUserRate:
            components?.path += "/v2/user_rates/"
        case .loadFavourites(let id):
            components?.path += "/users/\(id)/favourites"
            
        case .loadUserFriends(let id, let limit):
            components?.path += "/users/\(id)/friends"
            components?.queryItems = [
                URLQueryItem(name: "limit", value: "\(limit)")
            ]
        case .addToFavorites(let id,let type):
            components?.path += "/favorites/\(type.rawValue)/\(id)"
        case .deleteFromFavorites(let id,let type):
            components?.path += "/favorites/\(type.rawValue)/\(id)"
            
        case .userRatesList(let id,let limit):
            components?.path += "/users/\(id)/anime_rates"
            components?.queryItems = [
                URLQueryItem(name: "limit", value: "\(limit)")
            ]
        case .search(let limit, let query, let contentType, let order):
            components?.path += "/\(contentType)/"
            components?.queryItems = [
                URLQueryItem(name: "search", value: query),
                URLQueryItem(name: "limit", value: "\(limit)"),
                URLQueryItem(name: "order", value: "\(order)"),
            ]
        }
        return components?.url
    }
}

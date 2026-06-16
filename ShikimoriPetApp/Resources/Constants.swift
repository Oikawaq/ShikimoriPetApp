//
//  Constants.swift
//  ShikimoriPetApp
//
//  Created by Иван Илькив on 1/11/26.
//

import Foundation

struct Constants {

    static let baseURL = "https://shikimori.io"
    static let token = "/oauth/token"
    static let userCheckURL = "/api/users/whoami"

    static let clientId: String = {
        guard let value = Bundle.main.object(forInfoDictionaryKey: "ShikimoriClientId") as? String, !value.isEmpty else {
            fatalError("ShikimoriClientId не задан в Info.plist / Secrets.xcconfig")
        }
        return value
    }()

    static let clientSecret: String = {
        guard let value = Bundle.main.object(forInfoDictionaryKey: "ShikimoriClientSecret") as? String, !value.isEmpty else {
            fatalError("ShikimoriClientSecret не задан в Info.plist / Secrets.xcconfig")
        }
        return value
    }()

    static var redirectURL: String {
        "/oauth/authorize?client_id=\(clientId)&redirect_uri=urn%3Aietf%3Awg%3Aoauth%3A2.0%3Aoob&response_type=code&scope=user_rates+comments"
    }
}



//
//  UserDefaultsEnum.swift
//  ShikimoriPetApp
//
//  Created by Иван Илькив on 4/6/26.
//

import Foundation

enum UserDefaultsEnum: String, Codable {
    case userId = "current_user_id"
    case nickname = "current_user_nickname"
    
    var value: String{
        switch self {
        case .userId:
            return "current_user_id"
        case .nickname:
            return "current_user_nickname"
        }
    }
}

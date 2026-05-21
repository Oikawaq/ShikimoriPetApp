//
//  CommentableType.swift
//  ShikimoriPetApp
//
//  Created by Иван Илькив on 5/18/26.
//

import Foundation

enum CommentableType: String{
    case user
    case topic
    
    var apiPath: String{
        switch self{
            
        case .user:
            return "User"
        case .topic:
            return "Topic"
        }
    }
}

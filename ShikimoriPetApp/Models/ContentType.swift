//
//  ContentType.swift
//  ShikimoriPetApp
//
//  Created by Иван Илькив on 3/28/26.
//

import Foundation

enum ContentType: String{
    case animes
    case mangas
    case ranobe
    
    var apiPath: String{
        switch self{
        case .animes: return "Anime"
        case .mangas: return "Manga"
        case .ranobe: return "Ranob"
        }
    }
    var title: String{
        switch self{
        case .animes: return "Аниме"
        case .mangas: return "Манга"
        case .ranobe: return "Ранобэ"
        }
    }
}

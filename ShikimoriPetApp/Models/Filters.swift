//
//  Filters.swift
//  ShikimoriPetApp
//
//  Created by Иван Илькив on 5/5/26.
//

import Foundation

struct Filters: Codable {
    let page: Int?
    var order: Order? 
    var kind: Kind?
    var status: Status?
}
enum Kind: String, Codable {
    case tv = "tv"
    case movie = "movie"
    case ova = "ova"
    case ona = "ona"
    case special = "special"
    case tv_special = "tv_special"
    case music = "music"
    case manga = "manga"
    case manhwa = "manhwa"
    case manhua = "manhua"
    case light_novel = "light_novel"
    case novel = "novel"
    case one_shot = "one_shot"
    case doujin = "doujin"
    
    var localized: String {
        switch self{
        case .music:
            return L10n.sideMenuKind.music.localized
        case .movie:
            return L10n.sideMenuKind.movie.localized
        case .ova:
            return L10n.sideMenuKind.ova.localized
        case .ona:
            return L10n.sideMenuKind.ona.localized
        case .tv:
            return L10n.sideMenuKind.tv.localized
        case .special:
            return L10n.sideMenuKind.special.localized
        case .tv_special:
            return L10n.sideMenuKind.tv_special.localized
        case .manga:
            return L10n.sideMenuKind.manga.localized
        case .manhwa:
            return L10n.sideMenuKind.manhwa.localized
        case .manhua:
            return L10n.sideMenuKind.manhua.localized
        case .light_novel:
            return L10n.sideMenuKind.light_novel.localized
        case .novel:
            return L10n.sideMenuKind.novel.localized
        case .one_shot:
            return L10n.sideMenuKind.one_shot.localized
        case .doujin:
            return L10n.sideMenuKind.doujin.localized
        }
    }
}
enum Order: String, Codable {
    case ranked = "ranked"
    case name = "name"
    case popularity = "popularity"
    case aired_on = "aired_on"
    
    var localized: String {
        switch self{
        case .aired_on:
            return L10n.sideMenuOrder.aired_on.localized
        case .name:
            return L10n.sideMenuOrder.name.localized
        case .popularity:
            return L10n.sideMenuOrder.popularity.localized
        case .ranked:
            return L10n.sideMenuOrder.ranked.localized
        }
    }
}
enum Status : String, Codable {
    case anons = "anons"
    case ongoing = "ongoing"
    case released = "released"
    case paused = "paused"
    case discontinued = "discontinued"
    var localized: String {
        switch self{
        case .anons:
            return L10n.sideMenuStatus.anons.localized
        case .ongoing:
            return L10n.sideMenuStatus.ongoing.localized
        case .released:
            return L10n.sideMenuStatus.released.localized
        case .paused:
            return L10n.sideMenuStatus.paused.localized
        case .discontinued:
            return L10n.sideMenuStatus.discontinued.localized
        }
        
    }
}

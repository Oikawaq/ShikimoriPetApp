//
//  WatchingStatus.swift
//  ShikimoriPetApp
//
//  Created by Иван Илькив on 4/4/26.
//


    enum WatchingStatus: String,CaseIterable, Decodable {
        case planned, watching, rewatching, completed, dropped
        case onHold = "on_hold"
        case none = ""
        var ruDescription: String {
            switch self {
            case .planned:    return "Запланировано"
            case .watching:   return "Смотрю"
            case .rewatching: return "Пересматриваю"
            case .completed:  return "Завершено"
            case .onHold:     return "На паузе"
            case .dropped:    return "Брошено"
            case .none:       return "Добавить в список"
            }
        }
    }

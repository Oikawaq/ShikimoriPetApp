//
//  Anime.swift
//  ShikimoriPetApp
//
//  Created by Иван Илькив on 2/28/26.
//

import Foundation

struct ContentItemModel{
    let id: Int
    let description: String?
    let duration: Int?
    let kind : kindEnum?
    let status: statusEnum?
    let episodes: Int?
    let episodesAired: Int?
    let name:String?
    let russian: String?
    let image: String?
    let airedOn: Int?
    let score: Double?
    let studios: String?
    let nextEpisodeAt: String?
    let volumes: Int?
    let chapters: Int?
    let genres: [GenresModel]?
    let topic: Int
    let screenshots: [ScreenshotsModel]?
    let personRoles: [PersonProtocol]?
    let related: [RelatedModel]?
    let characters: [PersonProtocol]?
}
enum UniversalKind: String {
    // Аниме
    case cm = "cm"
    case tv = "tv"
    case movie = "movie"
    case ova = "ova"
    case ona = "ona"
    case special = "special"
    case tvSpecial = "tv_special" 
    case music = "music"
    case pv = "pv"

    case manga = "manga"
    case lightNovel = "light_novel"
    case novel = "novel"
    case oneShot = "one_shot"
    case doujin = "doujin"
    case manhwa = "manhwa"
    case manhua = "manhua"
}
struct kindEnum {

    let value: UniversalKind?

    init(kind: String?) {
        self.value = UniversalKind(rawValue: kind ?? "")
    }

}
struct CharactersGraphQLModel: DetailedPersonProtocol, UniversalCellProtocol{
    var cellTitle: String
    
    var cellImage: String?
    
    var itemId: Int?
    
    var id: String?
    var name: String?
    var russian: String?
    var poster: String?
    init(id: String?, name: String?,russian: String?, poster: String?){
        self.id = id
        self.name = name
        self.russian = russian
        self.poster = poster
        self.itemId = Int("\(String(describing: id))")
        self.cellTitle = russian ?? name ?? ""
        self.cellImage = poster
    }
}
enum UniversalStatus: String {
    case anons = "anons"
    case ongoing = "ongoing"
    case released = "released"
    case paused = "paused"
    case discontinued = "discontinued"
}
struct statusEnum {
    let value: UniversalStatus?
    
    init(rawValue: String?) {
        self.value = UniversalStatus(rawValue: rawValue ?? "")
    }
}
struct RelatedModel{
    let id : String?
    let anime: RelatedItemModel?
    let manga: RelatedItemModel?
    let relationText: String?
    init(anime: ShikimoriSchema.GetAnimeInfoQuery.Data.Anime.Related){
        self.anime = anime.anime.map{ RelatedItemModel(id: $0.id, name: $0.name, russian: $0.russian ?? "", poster: $0.poster?.originalUrl ?? "")}
        self.id = anime.id
        self.relationText = anime.relationText
        self.manga = anime.manga.map{
            RelatedItemModel(id: $0.id, name: $0.name, russian: $0.russian ?? "", poster: $0.poster?.originalUrl ?? "")
        }
    }
    init(manga: ShikimoriSchema.GetMangaInfoQuery.Data.Manga.Related){
        self.manga = manga.manga.map{ RelatedItemModel(id: $0.id, name: $0.name, russian: $0.russian ?? "", poster: $0.poster?.originalUrl ?? "")}
        self.anime = manga.anime.map{ RelatedItemModel(id: $0.id, name: $0.name, russian: $0.russian ?? "", poster: $0.poster?.originalUrl ?? "")}
        self.id = manga.id
        self.relationText = manga.relationText
    }

    
}

struct RelatedItemModel{
    let id: String?
    let name: String?
    let russian: String?
    let poster: String?

    init(id: String, name: String, russian: String, poster: String){
        self.id = id
        self.name = name
        self.russian = russian
        self.poster = poster
    }
}
struct PersonModel: PersonProtocol{

    var id: String?
    let rolesEn: [String]?
    let rolesRu: [String]?
    let person: DetailedPersonProtocol
    
    init(rolesRU: [String], rolesEn: [String], person: DetailedPersonProtocol){
        self.rolesRu = rolesRU
        self.rolesEn = rolesEn
        self.person = person
    }
}
struct PersonGraphQLModel: DetailedPersonProtocol{
    var cellTitle: String
    
    var cellImage: String?
    
    var itemId: Int?
    
    let id : String?
    let name: String?
    let russian: String?
    let poster: String?

    init(id: String?, name: String?, russian: String?, poster: String?){
        self.id = id
        self.name = name
        self.russian = russian
        self.poster = poster
        self.cellTitle = russian ?? name ?? ""
        self.cellImage = poster
    }
}
struct ScreenshotsModel{
    let original: String
    let preview: String
    
    init(screenshot: ShikimoriSchema.GetAnimeInfoQuery.Data.Anime.Screenshot){
        self.original = screenshot.originalUrl
        self.preview = screenshot.x332Url
    }

}
struct GenresModel{
    let russian: String
    let kind: ShikimoriSchema.GenreKindEnum?
    
    init(genre: ShikimoriSchema.GetAnimeInfoQuery.Data.Anime.Genre){
        self.russian = genre.russian
        self.kind = genre.kind.value
    }
    init(genre: ShikimoriSchema.GetMangaInfoQuery.Data.Manga.Genre){
        self.russian = genre.russian
        self.kind = genre.kind.value
    }
    
}

extension ContentItemModel{
    init(anime: ShikimoriSchema.GetAnimeInfoQuery.Data.Anime){
        self.id = Int(anime.id) ?? 0
        self.description = anime.description
        self.name = anime.name
        self.russian = anime.russian
        self.kind = kindEnum(kind: anime.kind?.value?.rawValue)
        self.image = anime.poster?.originalUrl
        self.status = statusEnum(rawValue: anime.status?.rawValue)
        self.episodes = anime.episodes
        self.episodesAired = anime.episodesAired
        self.airedOn = anime.airedOn?.year
        self.nextEpisodeAt = anime.nextEpisodeAt
        self.duration = anime.duration
        self.studios = anime.studios.first?.imageUrl
        self.volumes = nil
        self.chapters = nil
        self.score = anime.score
        self.genres = anime.genres?.compactMap{ GenresModel(genre: $0) }
        self.topic = Int(anime.topic?.id ?? "0") ?? 0
        self.screenshots = anime.screenshots.compactMap{
            ScreenshotsModel(screenshot: $0)
        }
        self.personRoles = anime.personRoles?.compactMap{PersonModel(rolesRU: $0.rolesRu, rolesEn: $0.rolesEn, person: PersonGraphQLModel(id: $0.id, name: $0.person.name, russian: $0.person.russian, poster: $0.person.poster?.originalUrl))}
        self.related = anime.related?.compactMap{ RelatedModel(anime: $0) }
        self.characters = anime.characterRoles?.compactMap{
            PersonModel(rolesRU: $0.rolesRu, rolesEn: $0.rolesEn, person: CharactersGraphQLModel(id: $0.character.id, name: $0.character.name, russian: $0.character.russian, poster: $0.character.poster?.originalUrl))
        }
    }
    init(manga: ShikimoriSchema.GetMangaInfoQuery.Data.Manga){
        self.id = Int(manga.id) ?? 0
        self.description = manga.description
        self.name = manga.name
        self.russian = manga.russian
        self.kind = kindEnum(kind: manga.kind?.value?.rawValue)
        self.image = manga.poster?.originalUrl
        self.status = statusEnum(rawValue: manga.status?.rawValue)
        self.episodes = nil
        self.episodesAired = nil
        self.airedOn = manga.airedOn?.year
        self.nextEpisodeAt = nil
        self.duration = nil
        self.studios = nil
        self.volumes = manga.volumes
        self.chapters = manga.chapters
        self.score = manga.score
        self.genres = manga.genres?.compactMap{ GenresModel(genre: $0) }
        self.topic = Int(manga.topic?.id ?? "0") ?? 0
        self.screenshots = []
        self.personRoles = manga.personRoles?.compactMap{PersonModel(rolesRU: $0.rolesRu, rolesEn: $0.rolesEn, person: PersonGraphQLModel(id: $0.id, name: $0.person.name, russian: $0.person.russian ?? "", poster: $0.person.poster?.originalUrl ?? ""))}
        self.related = manga.related?.compactMap{ RelatedModel(manga: $0) }
        self.characters = manga.characterRoles?.compactMap{
            PersonModel(rolesRU: $0.rolesRu, rolesEn: $0.rolesEn, person: CharactersGraphQLModel(id: $0.character.id, name: $0.character.name, russian: $0.character.russian, poster: $0.character.poster?.originalUrl))
        }
    }
}

protocol DetailedPersonProtocol : UniversalCellProtocol{
    var id: String? { get }
    var name: String? { get }
    var russian: String? { get }
    var poster: String? { get }
}
protocol PersonProtocol{
    var rolesRu: [String]? { get }
    var rolesEn: [String]? { get }
    var person: DetailedPersonProtocol { get }
    var id: String? { get }
}

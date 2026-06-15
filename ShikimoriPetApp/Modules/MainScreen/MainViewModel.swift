//
//  MainViewModel.swift
//  ShikimoriPetApp
//
//  Created by Иван Илькив on 2/18/26.
//

import Foundation
import Combine
import Apollo
import ApolloAPI

class MainViewModel {
    typealias AnimeQuery = ShikimoriSchema.GetAnimeListQuery
    typealias MangaQuery = ShikimoriSchema.GetMangaListQuery
    typealias AnimeModel = ShikimoriSchema.GetAnimeListQuery.Data.Anime
    typealias MangaModel = ShikimoriSchema.GetMangaListQuery.Data.Manga
 
    
     var content: [ContentListModel] {
        switch contentType {
        case .animes:
            return animeContent
        case .mangas:
            return mangaContent
        case .ranobe:
            return mangaContent
        }
    }
    @Published var animeContent: [ContentListModel] = []
    @Published var mangaContent: [ContentListModel] = []
    @Published var contentType: ContentType = .animes
    @Published var filters : Filters = Filters(order: .ranked, kind: nil, status: nil)
    var currentPage: Int = 1

    func loadNextPage() {
        currentPage += 1
        fetchAnimeList(currentPage: currentPage, filters: filters)
    }

    func loadPreviousPage() {
        guard currentPage > 1 else { return }
        currentPage -= 1
        fetchAnimeList(currentPage: currentPage, filters: filters)
    }
    func switchContent(to type: ContentType, filter: Filters){
        contentType = type
        currentPage = 1
        switch type{
            
        case .animes:
            fetchAnimeList(currentPage: currentPage, filters: filter)
        case .mangas:
            fetchMangaList(currentPage: currentPage, filters: filter)
        case .ranobe:
            fetchMangaList(currentPage: currentPage, filters: filter)

        }
        
        
    }
    private func loadContent(currentPage: Int, to Type: ContentType, filters: Filters){
        switch contentType {
        case .animes: fetchAnimeList(currentPage: currentPage, filters: filters)
        case .mangas: fetchMangaList(currentPage: currentPage, filters: filters)
        case .ranobe: fetchMangaList(currentPage: currentPage, filters: filters)
        }
    }
    func fetchAnimeList(currentPage: Int ,filters: Filters){
        Task{ [weak self ] in
            guard let self = self else {return}
            do{
                let response = try await ApolloService.shared.client.fetch(
                    query: AnimeQuery(
                        page: .init(integerLiteral: currentPage),
                        limit: .init(integerLiteral: 20),
                        order: filters.order.map{ .some(GraphQLEnum($0))} ?? .init(.ranked),
                        status: filters.status.map{ .some($0.rawValue)} ?? .none,
                        kind: filters.kind.map{ .some($0.rawValue)} ?? .none)
                )
                self.animeContent = response.data?.animes.map{ ContentListModel(anime: $0)
                } ?? []
            }catch{
                print("Fetch error: \(error)")
            }
        }
        
    }
    func fetchMangaList(currentPage: Int ,filters: Filters){
        print("MANGA REQUEST: page=\(currentPage) order=\(filters.order?.rawValue ?? "nil")")
        Task{ [weak self ] in
            guard let self = self else {return}
            do{
                let response = try await ApolloService.shared.client.fetch(
                    query: MangaQuery(
                        page: .init(integerLiteral: currentPage),
                        limit: .init(integerLiteral: 20),
                        order: filters.order.map{ .some(GraphQLEnum($0))} ?? .init(.ranked),
                        status: filters.status.map{ .some($0.rawValue)} ?? .none,
                        kind: filters.kind.map{ .some($0.rawValue)} ?? .none)
                )
                self.mangaContent = response.data?.mangas.map{ ContentListModel(manga: $0)
                } ?? []
            }catch{
                    print("Fetch error: \(error)")
            }
        }
        
    }
}

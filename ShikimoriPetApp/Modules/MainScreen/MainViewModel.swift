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
    typealias AnimeModel = ShikimoriSchema.GetAnimeListQuery.Data.Anime
    private lazy var apolloClient: ApolloClient = {
        let url = URL(string: "https://shikimori.io/api/graphql")!
        
        let config = URLSessionConfiguration.default
        let urlSession = URLSession(configuration: config)
        let store = ApolloStore()
        let transport = RequestChainNetworkTransport(urlSession: urlSession, interceptorProvider: DefaultInterceptorProvider.shared, store: store, endpointURL: url)
        
        return ApolloClient(networkTransport: transport, store: ApolloStore())
        
    }()
    var test: [AnimeModel] = []
    
    @Published var content: [ContentListModel] = []
    @Published var contentType: ContentType = .animes
    @Published var filters : Filters = Filters(page: 1, order: .ranked, kind: nil, status: nil)
    var currentPage: Int = 1
    
  

    func loadNextPage() {
        currentPage += 1
        loadTypeData(currentPage: currentPage,type: contentType,filters: filters)
    }

    func loadPreviousPage() {
        guard currentPage > 1 else { return }
        currentPage -= 1
        loadTypeData(currentPage: currentPage,type: contentType,filters: filters)
    }
    func switchContent(to type: ContentType, filter: Filters){
        contentType = type
        currentPage = 1
        loadContent(currentPage: currentPage, to: type,filters: filter)
        
    }
    private func loadContent(currentPage: Int, to Type: ContentType, filters: Filters){
        switch contentType {
        case .animes: loadTypeData(currentPage: currentPage,type: .animes,filters: filters)
        case .mangas: loadTypeData(currentPage: currentPage,type: .mangas,filters: filters)
        case .ranobe: loadTypeData(currentPage: currentPage,type: .ranobe,filters: filters)
        }
    }
    private func loadTypeData(currentPage: Int,type: ContentType, filters: Filters) {
        NetworkManager.shared.request(endpoint: .loadTypeData(page: currentPage, contentType: type, filters: filters), method: .get)
            .replaceError(with: [])
            .receive(on: DispatchQueue.main)
            .assign(to: &$content)
    }
    func fetchAnimeList(){
        Task{
            do{
                let response = try await apolloClient.fetch(query: AnimeQuery(page: 1, limit: 15, order: .init(.ranked)))
                let test = response.data?.animes.compactMap{ $0}
                self.test = test ?? []
            }catch{
                print("Fetch error: \(error)")
            }
        }
        
    }
}

//
//  ApolloService.swift
//  ShikimoriPetApp
//
//  Created by Иван Илькив on 5/24/26.
//
import Apollo
import ApolloAPI
import Foundation
final class ApolloService{
    static let shared = ApolloService()
    private init() {}
    
    lazy var client: ApolloClient = {
        let url = URL(string: "https://shikimori.io/api/graphql")!
        
        let config = URLSessionConfiguration.default
        let urlSession = URLSession(configuration: config)
        let store = ApolloStore()
        let transport = RequestChainNetworkTransport(urlSession: urlSession, interceptorProvider: DefaultInterceptorProvider.shared, store: store, endpointURL: url)
        return ApolloClient(networkTransport: transport, store: ApolloStore())
        
    }()
}

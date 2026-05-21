//
//  Apollo.swift
//  ShikimoriPetApp
//
//  Created by Иван Илькив on 5/19/26.
//

import Foundation
import Apollo

class Network{
    static let shared = Network()
    
    private(set) lazy var apollo: ApolloClient = {
        let url = URL(string: "https://shikimori.one/api/graphql")!
        return ApolloClient(url: url)
    }()
}

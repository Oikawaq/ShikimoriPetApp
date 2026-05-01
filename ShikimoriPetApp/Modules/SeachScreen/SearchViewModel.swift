//
//  SearchViewModel.swift
//  ShikimoriPetApp
//
//  Created by Иван Илькив on 5/1/26.
//

import Foundation
import Combine
class SearchViewModel {
    private var cancellables: Set<AnyCancellable> = []
    @Published var searchResult: [SectionViewSearch.RowData] = []
    init (type: ContentType) {
        
    }
    
    func makeSearch(text: String){
        NetworkManager.shared.request(endpoint: .search(query: text, contentType: .animes), method: .get)
            .map{ [weak self] (response: [test])-> [SectionViewSearch.RowData] in
                return response.compactMap{ item in
                    return SectionViewSearch.RowData(title: item.cellTitle, subtitle: item.name, imageUrl: item.cellImage, id: item.id, score: 4.5)
                    
                }
                
            }
            .replaceError(with: [])
            .receive(on: DispatchQueue.main)
            .assign(to: &$searchResult)
    }
}

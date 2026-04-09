//
//  AnimeListViewModel.swift
//  ShikimoriPetApp
//
//  Created by Иван Илькив on 4/6/26.
//

import Foundation
import Combine

class ContentListViewModel {
    @Published var list: [UserContentListModel] = []
    @Published var sections: [UniversalSectionModel] = []
    private var cancellables: Set<AnyCancellable> = []
    private let userId = UserDefaults.standard.integer(forKey: UserDefaultsEnum.userId.value)
    private var type: ContentType
    init (type: ContentType) {
        self.type = type
    }
    
    
    
    
        //MARK: Network
//    func loadList(status: WatchingStatus){
//        NetworkManager.shared.request(endpoint: .userRatesList(id: userId), method: .get)
//            .map{ (items: [UserContentListModel]) in
//                let filtered = items.filter{item in
//                    return item.status?.contains(status.rawValue) ?? false
//                    
//                    }
//               return filtered
//            }
//            .replaceError(with: [])
//            .receive(on: DispatchQueue.main)
//            .assign(to: &$list)
//    }
    func loadUserList() {
        NetworkManager.shared.request(endpoint: .userRatesList(id: userId), method: .get)
            .replaceError(with: []) // Если ошибка — пустой массив
            .map { (items: [UserContentListModel])->[UniversalSectionModel] in
    
                WatchingStatus.allCases.compactMap { status in
                    let filtered = items.filter { $0.status.rawValue == status.rawValue }
                    guard !filtered.isEmpty else { return nil }
                    let sorted = filtered.sorted(by: {
                        $0.score ?? 0 > $1.score ?? 0
                    })
                    return UniversalSectionModel(status: status, anime: sorted )
                }
                
            }
            .receive(on: DispatchQueue.main)
            .assign(to: &$sections)
    }
}

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
    let userId: Int
    var type: ContentType
    var linkId: Int
    var viewed: String{
        return type == .animes ? "episodes" : "chapters"
    }
    init (type: ContentType, userId: Int) {
        self.type = type
        self.userId = userId
        self.linkId = 0
    }
    init(linkId: Int, type: ContentType){
        self.linkId = linkId
        self.type = type
        self.userId = 0
    }
    
    
    private func rebuildSection(){
        self.sections = WatchingStatus.allCases.compactMap { status in
            let filtered = self.list.filter { $0.status.rawValue == status.rawValue }
            guard !filtered.isEmpty else { return nil }
            let sorted = filtered.sorted(by: {
                $0.score ?? 0 > $1.score ?? 0
            })
            return UniversalSectionModel(status: status, item: sorted )
        }
    }
        //MARK: Network
    func loadUserList() {
        NetworkManager.shared.request(endpoint: .userRatesList(id: userId, type: type), method: .get)
            .replaceError(with: []) 
            .sink { [weak self ] (items: [UserContentListModel]) in
                guard let self = self else {return}
                self.list = items
                print(items.count)
                self.rebuildSection()
            }
            .store(in: &cancellables)
        
    }
    func updateRate(status: WatchingStatus, score: Int, episodes: Int) {
        let body = makeUpdateBody(status: status, score: score, episodes: episodes)
        NetworkManager.shared.request(endpoint: .userRateUpdate(linkID: linkId), method: .put ,body: body)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { _ in }, receiveValue: {[weak self ] (updated: UserRate) in
                guard let self = self else {return}
                if let index = self.list.firstIndex(where: { $0.id == updated.id }) {
                                self.list[index].status = status
                                self.list[index].score = score
                                if self.type == .animes {
                                    self.list[index].episodes = episodes
                                } else {
                                    self.list[index].chapters = episodes
                                }
                            }
                self.rebuildSection()
            }
                
            )
            .store(in: &cancellables)
        
    }
    private func makeUpdateBody(status: WatchingStatus, score: Int, episodes: Int) -> [String: Any] {
        return [
            "user_rate": [
                "status": status.rawValue,
                "score": score,
                viewed: episodes
            ]
        ]
    }
}

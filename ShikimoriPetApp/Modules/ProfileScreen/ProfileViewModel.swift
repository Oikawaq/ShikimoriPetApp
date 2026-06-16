//
//  ProfileViewModel.swift
//  ShikimoriPetApp
//
//  Created by Иван Илькив on 3/7/26.
//

import Foundation
import Combine
import UIKit

class ProfileViewModel {
    var userId: Int
    private var cancellabels : Set<AnyCancellable> = []
    @Published var profileData: ProfileUserModel?
    @Published var comments: [CommentsModel] = []
    @Published var commentsCOunt: Int = 0
    private var rawComments: [CommentsModel] = []
    @Published var canLoadMore: Bool = false
    var newComments: [CommentsModel] = []
    var allComments: [CommentsModel]{
        let combined = comments + newComments
       var seen = Set<Int>()
        return combined.filter{
            seen.insert($0.id).inserted
        }
    }
    
    var page: Int = 1
    var numberOfSections: [ProfileSection] {
        let sections = ProfileSection.allCases.filter { section in
            switch section{
            case .userInfo:
                return true
            case .content:
                return true
            case .friend:
                return !userFriendsList.isEmpty
            case .favorite:
                return !favoritesList.isEmpty
            case .comments:
                return !comments.isEmpty
            }
        }
        return sections
    }
    var favoritesList: [UniversalType]{
        guard let favorites = userFavorites else{return []}
        return favorites.animes.map { var i = $0; i.type = .anime; return i }
                 + favorites.characters.map { var i = $0; i.type = .character; return i }
                 + favorites.mangas.map { var i = $0; i.type = .manga; return i }
                 + favorites.ranobe.map { var i = $0; i.type = .ranobe; return i }
    }
    var animeBlockDescription: String {
        return createDescriptionForSegmentList(
            list: createSegmentList(list: profileData?.stats.statuses.anime, color: .systemBlue)
           )
    }
    var mangaBlockDescription: String{
        return createDescriptionForSegmentList(
            list: createSegmentList(list: profileData?.stats.statuses.manga, color: .systemPink)
           )
    }
    func createDescriptionForSegmentList(list: [Segment]) -> String {
        let total = list.reduce(0) { $0 + $1.value }
        return total > 0 ? "Список: \(total)" : "Список пуст"
    }
    func createSegmentList(list: [ItemsUniversalModel]?, color: UIColor) -> [Segment] {
        guard let array = list else { return [] }
        
        var completedSize = 0
        var activeSize = 0
        var droppedSize = 0
        let color = color
        array.forEach { item in
            let status = WatchingStatus(rawValue: item.name) ?? .none
            switch status {
            case .completed:
                completedSize += item.size
            case .watching, .rewatching, .planned, .onHold:
                activeSize += item.size
            case .dropped:
                droppedSize += item.size
            case .none:
                break
            }
        }
        
             return [
                Segment(value: completedSize, color: color,  status: .completed),
                Segment(value: activeSize,    color: color.withAlphaComponent(0.5),   status: .watching),
                Segment(value: droppedSize,   color: .systemGray,  status: .dropped)
            ].filter { $0.value > 0 }
            .sorted { $0.value > $1.value }
       
        
    }
    var userData: UserModel?
    
    var username: String? {
        return profileData?.nickname
    }
    var imageURL: URL? {
        return URL(string: profileData?.image?.x160 ?? "")
    }
    var userAge: String? {
        return profileData?.fullYears?.description
    }

    @Published var userFriendsList: [UserFriendsModel] = []
    @Published var userFavorites: UserFavourites?
        //MARK: init
    
    init(userId: Int) {
        self.userId = userId
    }
   
        //MARK: network
    
    func loadAllData(){
        loadUserData()
        loadUserFriends()
        loadUserFavorites()
        loadComments()
       
    }
    func moreComments(){
        page += 1
        loadComments()
    }

    func sendComment(body: String, replyToId: Int? = nil) {
        CommentService.shared.sendComment(body: body, commentableId: userId, commentableType: .user, replyToId: replyToId)
            .catch { _ in Empty<CommentsModel, Never>() }
            .receive(on: DispatchQueue.main)
            .sink { [weak self] newComment in
                guard let self else { return }
                rawComments.insert(newComment, at: 0)
                let processed = CommentService.shared.filter(unique: [newComment])
                self.comments.insert(contentsOf: processed, at: 0)
            }
            .store(in: &cancellabels)
    }

    private func loadComments(){
        CommentService.shared.loadComments(id: userId, page: page, type: .user)
            .replaceError(with: [])
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: {_ in }, receiveValue: {[weak self ] (newComment: [CommentsModel]) in
                guard let self = self else {return}
                let combined = rawComments + newComment
                var seen = Set<Int>()
                let unique = combined.filter { seen.insert($0.id).inserted }
                rawComments = unique
                self.comments = CommentService.shared.filter(unique: unique)
                self.canLoadMore = unique.count < 10 ? false: true
            })
            .store(in: &cancellabels)
    }
    private func loadUserData(){
        NetworkManager.shared.request(endpoint: .userData(id: userId), method: .get)
            .replaceError(with: nil)
            .receive(on: DispatchQueue.main)
            .assign(to: &$profileData)
    }
    private func loadUserFriends(){
        NetworkManager.shared.request(endpoint: .loadUserFriends(id: userId, limit: 5), method: .get)
            .replaceError(with: [])
            .receive(on: DispatchQueue.main)
            .assign(to: &$userFriendsList)
    }
    private func loadUserFavorites(){
        NetworkManager.shared.request(endpoint: .loadFavourites(id: userId), method: .get)
            .replaceError(with: nil)
            .receive(on: DispatchQueue.main)
            .assign(to: &$userFavorites)
       
    }
    
}

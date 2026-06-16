
import Foundation
import Combine
import Apollo

@MainActor
class CharacterViewModel{
    let characterID: String
    
    typealias characterModelGraphQL = ShikimoriSchema.GetCharacterInfoQuery.Data.Character
    typealias getCharacter = ShikimoriSchema.GetCharacterInfoQuery
    @Published var character: characterModelGraphQL? = nil
    @Published var isFavorite: Bool = false
    @Published var fullCharacterDetails: CharacterDetailModel?
    @Published var comments: [CommentsModel] = []
    @Published var canLoadMore: Bool = false
    var page: Int = 1
    var cancellables: Set<AnyCancellable> = []
    private var topicId: Int = 0
    private var rawComments: [CommentsModel] = []

    init(characterId: String) {
        self.characterID = characterId
        setupFavoritesBinding()
    }
    var numberOfSections:[CharacterSections] {
        let sections = CharacterSections.allCases.filter{ section in
            switch section{
            case .seyu: return seyu.count > 0
            case .anime: return animesListCount > 0
            case .manga: return mangasListCount > 0
            case .comments: return true
            default: return true
            }
        }
        return sections
    }
    var animesListCount: Int{
       return fullCharacterDetails?.animes.count ?? 0
    }
    var mangasListCount: Int{
       return fullCharacterDetails?.mangas.count ?? 0
    }
    var seyu: [ListSectionView.RowData] {
        fullCharacterDetails?.seyu?.prefix(2).map{seyu in
            return ListSectionView.RowData(title: seyu.russian ?? "", subtitle: seyu.name ?? "", imageUrl: seyu.image?.original, id: seyu.id, type: .animes
        )
            
        } ?? []
    }
    var relatedAnimeList: [universalType]{
        guard let list = fullCharacterDetails?.animes else { return []}
        return list
    }
    var relatedMangaList: [universalType]{
        guard let list = fullCharacterDetails?.mangas else { return []}
        return list
    }
    
    var name: String { "\(character?.russian ?? fullCharacterDetails?.russian ?? "") / \(character?.name ?? fullCharacterDetails?.name ?? "")"}
    var imageURL: URL? {
        let url = character?.poster?.originalUrl ?? ""
        return URL(string: url)
    }
    var description: NSAttributedString {
        return(character?.description ?? "").parseDescriptionBBCode()
}

    func loadFullData(){
        NetworkManager.shared.request(endpoint: .characterDetails(id: Int(characterID) ?? 0), method: .get)
            .replaceError(with: nil)
            .receive(on: DispatchQueue.main)
            .assign(to: &$fullCharacterDetails)
    }
    func loadAllData(){
        loadFullData()
        Task{
            await loadData()
            loadComments()
        }
    }

    func moreComments() {
        page += 1
        loadComments()
    }

    private func loadComments() {
        guard topicId > 0 else {
            print("[CharacterVM] loadComments: topicId is 0, skipping")
            return
        }
        print("[CharacterVM] loadComments topicId=\(topicId) page=\(page)")
        CommentService.shared.loadComments(id: topicId, page: page, type: .topic)
            .receive(on: DispatchQueue.main)
            .sink { completion in
                if case .failure(let error) = completion {
                    print("[CharacterVM] loadComments error: \(error)")
                }
            } receiveValue: { [weak self] newComments in
                guard let self else { return }
                print("[CharacterVM] loadComments got \(newComments.count) comments")
                let combined = rawComments + newComments
                var seen = Set<Int>()
                let unique = combined.filter { seen.insert($0.id).inserted }
                rawComments = unique
                self.comments = CommentService.shared.filter(unique: unique)
                self.canLoadMore = unique.count < 10 ? false : true
            }
            .store(in: &cancellables)
    }

    func sendComment(body: String, replyToId: Int? = nil) {
        guard topicId > 0 else { return }
        CommentService.shared.sendComment(body: body, commentableId: topicId, commentableType: .topic, replyToId: replyToId)
            .catch { _ in Empty<CommentsModel, Never>() }
            .receive(on: DispatchQueue.main)
            .sink { [weak self] newComment in
                guard let self else { return }
                rawComments.insert(newComment, at: 0)
                let processed = CommentService.shared.filter(unique: [newComment])
                self.comments.insert(contentsOf: processed, at: 0)
            }
            .store(in: &cancellables)
    }
    private func loadData() async {
        do {
            let response = try await ApolloService.shared.client.fetch(query: getCharacter(ids: .some(self.characterID)))
            let char = response.data?.characters.first
            character = char
            topicId = Int(char?.topic?.id ?? "0") ?? 0
            print("[CharacterVM] topicId=\(topicId)")
        } catch {
            print(error)
        }
    }
    private func setupFavoritesBinding() {
        FavouritesManager.shared.$isLoaded
            .filter { $0 }
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                guard let self else { return }
                guard let charId = Int(self.characterID) else{ return }
                self.isFavorite = FavouritesManager.shared.contains(charId, type: .character)
            }
            .store(in: &cancellables)
    }
    func toggleFavorite() {
        guard let charId = Int(self.characterID) else{ return }
        FavouritesManager.shared.toggleFavorite(id: charId, type: .character)
        isFavorite.toggle()
    }
}

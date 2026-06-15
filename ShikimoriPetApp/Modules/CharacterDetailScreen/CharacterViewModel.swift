
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
    var cancellables: Set<AnyCancellable> = []

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
        }
    }
    private func loadData() async{
        do{
            let response = try await ApolloService.shared.client.fetch(query: getCharacter(ids: .some(self.characterID)))
            character = response.data?.characters.first
        }catch{
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

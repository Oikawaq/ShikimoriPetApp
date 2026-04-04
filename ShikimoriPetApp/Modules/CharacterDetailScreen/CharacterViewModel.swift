
import Foundation
import Combine

class CharacterViewModel{
    
    var character: CharacterModel?
    let characterID: Int
    @Published var isFavorite: Bool = false
    @Published var fullCharacterDetails: CharacterDetailModel?
    var cancellables: Set<AnyCancellable> = []
    init (character: CharacterModel) {
        self.characterID = character.id
        self.character = character
        setupFavoritesBinding()
    }
    init(characterId: Int) {
        self.characterID = characterId
        self.character = nil
        setupFavoritesBinding()
    }
    var animesListCount: Int{
       return fullCharacterDetails?.animes.count ?? 0
    }
    var mangasListCount: Int{
       return fullCharacterDetails?.mangas.count ?? 0
    }
    var seyu: [ListSectionView.RowData] {
        fullCharacterDetails?.seyu?.prefix(2).map{seyu in
            return ListSectionView.RowData(title: seyu.russian ?? "", subtitle: seyu.name ?? "", imageUrl: seyu.image?.original, id: seyu.id
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
        let path = fullCharacterDetails?.image?.original ?? character?.image?.original ?? ""
        let fullPath = "https://shikimori.io" + path
        return URL(string: fullPath)
    }
    var description: String {
        guard let rawDescription = fullCharacterDetails?.description else {
        return "Загрузка описания..."
    }
    return rawDescription.htmlStripped()
}
    
    func loadData(){
        NetworkManager.shared.request(endpoint: .characterDetails(id: characterID), method: .get)
            .replaceError(with: nil)
            .receive(on: DispatchQueue.main)
            .assign(to: &$fullCharacterDetails)
    }
    private func setupFavoritesBinding() {
        FavouritesManager.shared.$isLoaded
            .filter { $0 }
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                guard let self else { return }
                self.isFavorite = FavouritesManager.shared.contains(self.characterID, type: .character)
            }
            .store(in: &cancellables)
    }
    func toggleFavorite() {
        FavouritesManager.shared.toggleFavorite(id: characterID, type: .character)
        isFavorite.toggle()
    }
}

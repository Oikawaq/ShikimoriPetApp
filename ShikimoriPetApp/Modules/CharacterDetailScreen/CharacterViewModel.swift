//
//  CharacterViewModel.swift
//  ShikimoriPetApp
//
//  Created by Иван Илькив on 3/3/26.
//

import Foundation
import Combine

class CharacterViewModel{
    
    var character: Character
    let characterID: Int

    @Published var fullCharacterDetails: CharacterDetail?
    init (character: Character) {
        self.characterID = character.id
        self.character = character
    }
    
    var seyu: [ListSectionView.RowData] {
        fullCharacterDetails?.seyu?.prefix(2).map{seyu in
            return ListSectionView.RowData(title: seyu.russian ?? "", subtitle: seyu.name ?? "", imageUrl: seyu.image?.original, id: seyu.id
        )
            
        } ?? []
    }
    var relatedAnime: [ListSectionView.RowData] {
        fullCharacterDetails?.animes.map{ anime in
            return ListSectionView.RowData(title: anime.russian ?? anime.name ?? "", subtitle: "", imageUrl: anime.image?.original, id: anime.id)
        } ?? []
    }
    var name: String { "\(character.russian ?? "") / \(character.name)"}
    var imageURL: URL? {
        let path = fullCharacterDetails?.image?.original ?? character.image?.original ?? ""
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
}

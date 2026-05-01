//
//  Character.swift
//  ShikimoriPetApp
//
//  Created by Иван Илькив on 3/31/26.
//


struct CharacterModel: Decodable, UniversalCellProtocol{
    var itemId: Int { id}
    
    
    var cellTitle: String { russian ?? name }
    
    var cellImage: String? {image?.original ?? image?.preview ?? "" }
    
    let id: Int
    let name: String
    let russian: String?
    let image: DefaultImageModel?
    
}

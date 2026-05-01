//
//  UniversalCellProtocol.swift
//  ShikimoriPetApp
//
//  Created by Иван Илькив on 3/26/26.
//

import Foundation

protocol UniversalCellProtocol {
    var cellTitle: String { get }
    var cellImage: String? { get }
    var itemId: Int { get }
}

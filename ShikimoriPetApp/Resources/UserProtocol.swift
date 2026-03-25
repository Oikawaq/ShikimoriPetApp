//
//  UserProtocol.swift
//  ShikimoriPetApp
//
//  Created by Иван Илькив on 3/7/26.
//

import Foundation

protocol UserRepresentable {
    var nickname: String { get }
    var avatarURLString: String? { get }
}

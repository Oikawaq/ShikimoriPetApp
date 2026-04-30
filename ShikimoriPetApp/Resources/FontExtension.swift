//
//  FontExtension.swift
//  ShikimoriPetApp
//
//  Created by Иван Илькив on 4/14/26.
//

import UIKit

enum Fonts {

    case categoriesFont
    func fonts() -> UIFont {
        switch self {
        case .categoriesFont:
            return UIFont.boldSystemFont(ofSize: 16)
        }
    }
}

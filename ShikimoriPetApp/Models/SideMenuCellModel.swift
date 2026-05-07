//
//  SideMenuCellModel.swift
//  ShikimoriPetApp
//
//  Created by Иван Илькив on 5/4/26.
//

import Foundation

struct SideMenuCellModel {
    let label: String
    let filters: [Filters]
    let type: SideMenuCellModelStatusType
}

enum SideMenuCellModelStatusType{
    case status,order,kind
}

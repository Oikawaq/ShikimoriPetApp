//
//  MainViewControllerDelegate.swift
//  ShikimoriPetApp
//
//  Created by Иван Илькив on 5/2/26.
//

import Foundation

protocol MainViewControllerDelegate: AnyObject{
    func didTapMenuButton()
    func didApplyFilters(filter: Filters)
    func switchType(type: ContentType)
}

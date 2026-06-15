//
//  SideMenuViewModel.swift
//  ShikimoriPetApp
//
//  Created by Иван Илькив on 5/4/26.
//

import Foundation
import Combine


final class SideMenuViewModel{
    
    @Published var type: ContentType
    @Published var selectedFilters = Filters(order: .ranked, kind: nil, status: nil)
    private var statusSection: SideMenuCellModel {
        let statuses: [Status] = switch type {
        case .animes:
            [.anons,.ongoing,.released]
        case .mangas,.ranobe:
            [.anons, .ongoing, .released, .paused, .discontinued]
        }
        return SideMenuCellModel(
            label: L10n.sideMenu.status,
            filters: statuses.map { Filters( status: $0) },
            type: .status
        )
    }

    private var orderSection: SideMenuCellModel {
        SideMenuCellModel(
            label: L10n.sideMenu.sorted,
            filters: [.ranked, .popularity, .airedOn, .name].map { Filters( order: $0) },
            type: .order
        )
    }

    private var kindSection: SideMenuCellModel {
        let kinds: [Kind] = switch type {
        case .animes: [.tv, .movie, .ova, .ona, .special, .tv_special, .music]
        case .mangas: [.manga, .manhua, .manhwa, .one_shot, .doujin]
        case .ranobe:  [.novel, .light_novel]
        }
        return SideMenuCellModel(
            label: L10n.sideMenu.type,
            filters: kinds.map { Filters(kind: $0) },
            type: .kind
        )
    }
    var sections: [SideMenuCellModel] {

            return [statusSection, kindSection, orderSection]
        
    }

    func toggleFilters(filter: Filters, type: SideMenuCellModelStatusType, isSelected: Bool){
        print(selectedFilters)
        switch type {
        case .status:
            selectedFilters.status = isSelected ? filter.status : nil
        case .kind:
            selectedFilters.kind = isSelected ? filter.kind : nil
        case .order:
            selectedFilters.order = isSelected ? filter.order : .ranked
        }
    }
    func isSelected(_ filter: Filters, type: SideMenuCellModelStatusType)->Bool{
        switch type{
            
        case .status: return selectedFilters.status == filter.status
        case .order: return selectedFilters.order == filter.order
        case .kind: return selectedFilters.kind == filter.kind
        }
    }
    func restoreFilters(){
        selectedFilters = Filters(order: .ranked, kind: nil, status: nil)
    }
        //MARK: init
    init(type: ContentType){
        self.type = type
    }
    
}

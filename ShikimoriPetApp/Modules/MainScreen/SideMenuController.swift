//
//  SideMenuController.swift
//  ShikimoriPetApp
//
//  Created by Иван Илькив on 5/2/26.
//

import UIKit
import Combine
class SideMenuController: UIViewController {
    private var cancellables: Set<AnyCancellable> = []
    let viewModel = SideMenuViewModel(type: .animes)
    weak var delegate: MainViewControllerDelegate?
    private var sideMenuView: SideMenuView?{
        return view as? SideMenuView
    }
    override func loadView() {
        view = SideMenuView()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        setupBindings()
    }
    private func setupTableView(){
        sideMenuView?.tableView.delegate = self
        sideMenuView?.tableView.dataSource = self
        sideMenuView?.tableView.register(SideMenuHeader.self, forCellReuseIdentifier: SideMenuHeader.identifier)
        sideMenuView?.tableView.register(SideMenuTableViewCell.self, forCellReuseIdentifier: SideMenuTableViewCell.identifier)
        
    }
    private func setupBindings(){
        viewModel.$type
            .receive(on: DispatchQueue.main)
            .sink { [weak self] type in
                guard let self = self else {return}
                sideMenuView?.tableView.reloadData()
            }
            .store(in: &cancellables)
    }
}
extension SideMenuController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.sections[section].filters.count + 1
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        viewModel.sections.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row == 0{
            let cell = tableView.dequeueReusableCell(withIdentifier: SideMenuHeader.identifier, for: indexPath) as! SideMenuHeader
            cell.configure(with: viewModel.sections[indexPath.section].label)
            return cell
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: SideMenuTableViewCell.identifier, for: indexPath) as! SideMenuTableViewCell
            let filters = viewModel.sections[indexPath.section].filters[indexPath.row-1]
            let type = viewModel.sections[indexPath.section].type
            let isSelected = viewModel.isSelected(filters, type: type)
            
            
            cell.configure(with: filters, isSelected: isSelected)
            cell.onButtonTapped = { [weak self ] in
                guard let self = self else {return}
                let currentlySelected = self.viewModel.isSelected(filters, type: type)
                self.viewModel.toggleFilters(filter: filters, type: type, isSelected: !currentlySelected)
                tableView.reloadSections(IndexSet(integer: indexPath.section), with: .none)
                self.delegate?.didApplyFilters(filter: viewModel.selectedFilters)
                print(viewModel.type)
            }
            return cell
        }
        
    }
}

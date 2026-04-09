//
//  AnimeListViewController.swift
//  ShikimoriPetApp
//
//  Created by Иван Илькив on 4/6/26.
//

import UIKit
import Combine

class ContentListViewController: UIViewController {
    private var cancellables: Set<AnyCancellable> = []
    private var contentListView: ContentListView?{
        view as? ContentListView
    }
    var viewModel: ContentListViewModel
        //MARK: lifecycle
    override func loadView() {
        view = ContentListView()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        setupBindings()
        viewModel.loadUserList()
    }
    
        //MARK: init
    init(viewModel: ContentListViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    private func setupBindings(){
        viewModel.$sections
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                guard let self = self else {return}
                contentListView?.tableView.reloadData()
            }
            .store(in: &cancellables)
            
    }
    private func setupTableView(){
        contentListView?.tableView.dataSource = self
        contentListView?.tableView.delegate = self
    }

}
extension ContentListViewController: UITableViewDataSource, UITableViewDelegate{
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.sections.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.sections[section].anime.count + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ContentListSectionCell.identifier) as? ContentListSectionCell else {
            return UITableViewCell()
        }
        if indexPath.row == 0{
            let item = viewModel.sections[indexPath.section].status.ruDescription
            cell.configureHeader(with: item)
            return cell
        }else{
            
            
            let item = viewModel.sections[indexPath.section].anime[indexPath.row - 1]
            cell.configure(with: item, number: indexPath.row)
            return cell
        }
    }
//    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//        let headerView = StackViewHeader(title: viewModel.sections[section].status.ruDescription)
//        return headerView
//    }
    

    
}

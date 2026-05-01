//
//  SearchViewController.swift
//  ShikimoriPetApp
//
//  Created by Иван Илькив on 5/1/26.
//

import UIKit
import Combine

final class SearchViewController: UIViewController{
    private var cancellables: Set<AnyCancellable> = []
    private let viewModel: SearchViewModel
    private var searchView : SearchView? {
        view as? SearchView
    }
    
        //MARK: init
    init(viewModel: SearchViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
        //MARK: lifecycle
    override func loadView() {
        view = SearchView()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        setupBindings()
        setupTableView()
    }
    override func viewDidAppear(_ animated: Bool) {
        searchView?.searchBar.becomeFirstResponder()
    }
    
    private func setupBindings(){
        guard let textField = searchView?.searchBar.searchTextField else {return}
        
        NotificationCenter.default
            .publisher(for: UITextField.textDidChangeNotification, object: textField)
            .compactMap{ ($0.object as? UITextField)?.text }
            .debounce(for: .milliseconds(500), scheduler: DispatchQueue.global(qos: .userInitiated))
            .receive(on: DispatchQueue.main)
            .removeDuplicates()
            .sink{ [weak self] text in
                guard let self = self else {return}
                if !text.isEmpty {
                    viewModel.makeSearch(text: text)
                }else{
                    viewModel.searchResult.removeAll()
                }
                
            }
            .store(in: &cancellables)
        
        viewModel.$searchResult
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] result in
                guard let self = self else {return}
                searchView?.tableView.reloadData()
            })
            .store(in: &cancellables)
            
    }
   
    private func setupTableView(){
        searchView?.tableView.delegate = self
        searchView?.tableView.dataSource = self
        searchView?.tableView.register(SearchBarTableCell.self, forCellReuseIdentifier: SearchBarTableCell.identifier)
    }
}

extension SearchViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.searchResult.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SearchBarTableCell.identifier, for: indexPath) as! SearchBarTableCell
        let items = viewModel.searchResult[indexPath.section]
        cell.configure(with: items)
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let itemId = viewModel.searchResult[indexPath.section].id else { return}
        let vm = DetailedViewModel(itemId: itemId, contentType: .animes)
        let vc = DetailedViewController(viewModel: vm)
        navigationController?.pushViewController(vc, animated: true)
    }
}

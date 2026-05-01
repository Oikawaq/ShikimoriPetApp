//
//  SearchView.swift
//  ShikimoriPetApp
//
//  Created by Иван Илькив on 5/1/26.
//

import UIKit
import SnapKit
final class SearchView: UIView {
    
    let searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.placeholder = L10n.Placeholder.search
        searchBar.layer.cornerRadius = 8
        searchBar.searchBarStyle = .minimal
        searchBar.searchTextField.backgroundColor = .bubbleBackground
        searchBar.searchTextField.textColor = .textColor
        return searchBar
    }()
    let tableView = UITableView(frame: .zero, style: .insetGrouped)
        //MARK: init
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .background
        setupUI()

    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        addSubview(searchBar)
        addSubview(tableView)
        tableView.backgroundColor = .background
        searchBar.snp.makeConstraints{make in
            make.top.equalTo(safeAreaLayoutGuide.snp.top)
            make.leading.trailing.equalToSuperview().inset(16)
        }
        tableView.snp.makeConstraints { make in
            make.top.equalTo(searchBar.snp.bottom).offset(16)
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.bottom.equalToSuperview().offset(12)
        }
    }
}

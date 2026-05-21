//
//  ProfileViewTest.swift
//  ShikimoriPetApp
//
//  Created by Иван Илькив on 5/7/26.
//

import UIKit
import SnapKit


class ProfileView: UIView {
    
    let tableView = UITableView(frame: .zero, style: .insetGrouped)

        //MARK: init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    private func setupUI(){
        addSubview(tableView)
        tableView.backgroundColor = .background
        tableView.rowHeight = UITableView.automaticDimension
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
  
}

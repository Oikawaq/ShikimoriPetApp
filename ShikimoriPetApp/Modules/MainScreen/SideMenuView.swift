//
//  SideMenuView.swift
//  ShikimoriPetApp
//
//  Created by Иван Илькив on 5/4/26.
//

import UIKit
import SnapKit

final class SideMenuView: UIView {
    private let titleLabel: UILabel = {
        
        let label = UILabel()
        label.text = L10n.sideMenu.filters
        label.font = .systemFont(ofSize: 24, weight: .bold)
        label.textAlignment = .left
        label.textColor = .textColor
        return label
    }()
 
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
        addSubview(titleLabel)
        addSubview(tableView)
        backgroundColor = .background
        tableView.separatorStyle = .none
        tableView.backgroundColor = .background
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(16)
            make.leading.equalToSuperview().inset(16)
        }
      
        tableView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(safeAreaLayoutGuide.snp.bottom)
        }
    }
}


//
//  SettingsScreenView.swift
//  ShikimoriPetApp
//
//  Created by Иван Илькив on 2/12/26.
//

import UIKit
import SnapKit

class SettingsView: UIView {
    
    //MARK: UIComponents
    
    let settingsLabel: UILabel = {
        let label = UILabel()
        label.text = L10n.Settings.title
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.textColor = .textColor
        return label
    }()
    
    let logoutButton: UIButton = {
        let button = UIButton()
        button.setTitle(L10n.Logout.logout, for: .normal)
        button.setTitleColor(.textColor, for: .normal)
        button.backgroundColor = .bubbleBackground
        button.layer.cornerRadius = 10
        return button
    }()
    let changeImageButton: UIButton = {
        let button = UIButton()
        button.setTitle(L10n.Settings.changeImage, for: .normal)
        button.setTitleColor(.textColor, for: .normal)
        button.backgroundColor = .bubbleBackground
        button.layer.cornerRadius = 10
        return button
    }()
    let changeUserName: UIButton = {
        let button = UIButton()
        button.setTitle(L10n.Settings.changeUserName, for: .normal)
        button.setTitleColor(.textColor, for: .normal)
        button.backgroundColor = .bubbleBackground
        button.layer.cornerRadius = 10
        return button
    }()
    
    private lazy var stackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [
            logoutButton,
            changeUserName,
            changeImageButton
        ])
        stack.axis = .vertical
        stack.spacing = 16
        stack.alignment = .fill
        stack.distribution = .fill
        return stack
    }()
    //MARK: init
    
   init () {
       super.init(frame: .zero)
       backgroundColor = .background
       addViews()
       setupConstrains()
       
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: setup
    
    private func addViews() {
        [settingsLabel,stackView].forEach {
            addSubview($0)
        }
    }
    
    private func setupConstrains(){
        [settingsLabel, changeImageButton, changeUserName, logoutButton].forEach {
                  $0.snp.makeConstraints { make in
                      make.height.equalTo(50)
                  }
              }
        settingsLabel.snp.makeConstraints { make in
            
            make.top.equalTo(safeAreaLayoutGuide.snp.top).offset(24)
            make.left.right.equalToSuperview().inset(16)
            make.height.equalTo(50)
        }
        stackView.snp.makeConstraints { make in
            make.top.equalTo(settingsLabel.snp.bottom).offset(16)
            make.left.right.equalToSuperview().inset(16)
        }

        
    }
    
    
   
    
}

//
//  ContainerView.swift
//  ShikimoriPetApp
//
//  Created by Иван Илькив on 3/5/26.
//

import UIKit
import SnapKit

final class ContainerView: UIView {
    
    private let containerView = UIView()
    let titleLabel = UILabel()
    
    init(title: String) {
        super.init(frame: .zero)
        setupContainer(title: title)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    private func setupContainer(title: String){
      
        containerView.backgroundColor = .basalt
        containerView.layer.cornerRadius = 8
        containerView.layer.borderWidth = 1
        
        titleLabel.text = title
        titleLabel.font = .systemFont(ofSize: 14, weight: .semibold)
        titleLabel.textColor = .chalkWhite
        titleLabel.textAlignment = .left
   
        addSubview(containerView)
        containerView.addSubview(titleLabel)
        
        containerView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        titleLabel.snp.makeConstraints { make in

            make.leading.equalToSuperview().offset(8)
            make.trailing.equalToSuperview().inset(8)
            make.top.bottom.equalToSuperview().inset(4)
        }
    }
    
}

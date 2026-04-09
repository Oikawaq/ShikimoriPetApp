//
//  stackViewHeader.swift
//  ShikimoriPetApp
//
//  Created by Иван Илькив on 4/8/26.
//

import Foundation
import UIKit
import SnapKit

class StackViewHeader: UIView{
    
    private let title: UILabel = {
        let title = UILabel()
        title.font = .systemFont(ofSize: 14, weight: .semibold)
        title.textColor = .white
        return title
    }()
    
    init(title: String) {
        self.title.text = title
        super.init(frame: .zero)
        addSubview(container)
        container.addArrangedSubview(self.title)
        container.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().inset(4)
            make.leading.trailing.equalToSuperview().inset(8)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    private let container: UIStackView = {
        let stackView = UIStackView()
        stackView.alignment = .leading
        stackView.backgroundColor = .systemGray6
        stackView.distribution = .fill
        return stackView
    }()
}

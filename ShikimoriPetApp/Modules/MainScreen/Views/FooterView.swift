//
//  FooterView.swift
//  ShikimoriPetApp
//
//  Created by Иван Илькив on 3/7/26.
//

import Foundation
import UIKit
import SnapKit
class FooterView: UICollectionReusableView {
    static let identifier: String = "FooterView"
    var onNextPage: (() -> Void)?
    var onPrevPage: (() -> Void)?
    
    private let stackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.distribution = .equalSpacing
        stack.alignment = .center
        stack.spacing = 20
        return stack
    }()
    
    let nextPageButton: UIButton = {
        let button = UIButton()
        button.setTitle("Next", for: .normal)
        button.backgroundColor = .systemBlue
        button.titleLabel?.font = .systemFont(ofSize: 20, weight: .bold)
        button.layer.cornerRadius = 10
        return button
    }()
    private let previousPageButton: UIButton = {
        let button = UIButton()
        button.setTitle("Prev", for: .normal)
        button.backgroundColor = .systemBlue
        button.titleLabel?.font = .systemFont(ofSize: 20, weight: .bold)
        button.layer.cornerRadius = 10
        return button
    }()
    private let currentPageLabel: UILabel = {
        let label = UILabel()
        label.textColor = .basalt
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 16, weight: .regular)
        label.text = "-"
        return label
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        nextPageButton.addTarget(self, action: #selector(nextTapped), for: .touchUpInside)
        previousPageButton.addTarget(self, action: #selector(prevTapped), for: .touchUpInside)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc private func nextTapped() { onNextPage?() }
    
    @objc private func prevTapped() { onPrevPage?() }
    
    func configure(page: Int) {
        currentPageLabel.text = "Page \(page)"
        previousPageButton.isEnabled = page > 1
        previousPageButton.alpha = page > 1 ? 1.0 : 0.5
    }
    
    private func setupUI(){
        addSubview(stackView)
            [previousPageButton, currentPageLabel, nextPageButton].forEach { stackView.addArrangedSubview($0) }
            
            stackView.snp.makeConstraints { make in
                make.center.equalToSuperview()
                make.leading.trailing.equalToSuperview().inset(32)
            }

            [nextPageButton, previousPageButton].forEach { button in
                button.snp.makeConstraints { make in
                    make.width.equalTo(80)
                    make.height.equalTo(40)
                }
            }
    }
}

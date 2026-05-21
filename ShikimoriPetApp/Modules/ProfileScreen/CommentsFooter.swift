//
//  CommentsFooter.swift
//  ShikimoriPetApp
//
//  Created by Иван Илькив on 5/13/26.
//

import UIKit
import SnapKit

class CommentsFooter: UITableViewHeaderFooterView {
    static let identifier: String = "CommentsFooter"
    private let textField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Добавить комментарий"
        textField.borderStyle = .roundedRect
        return textField
    }()
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        addSubview(textField)
        textField.snp.makeConstraints { (make) in
            make.edges.equalToSuperview().inset(4)
        }
        textField.backgroundColor = .bubbleBackground
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

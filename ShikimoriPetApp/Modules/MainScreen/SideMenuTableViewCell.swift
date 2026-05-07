
import UIKit
import SnapKit

class SideMenuTableViewCell: UITableViewCell {
    static let identifier: String = "SideMenuTableViewCell"
    var onButtonTapped: (() -> Void)?
    var tapped: Bool = false
    private let label: UILabel = {
        let label = UILabel()
        label.textColor = .textColor
        label.textAlignment = .left
        label.font = .systemFont(ofSize: 16, weight: .medium)
        return label
    }()
    let checkboxButton: UIButton = {
       let button = UIButton()
        button.setImage(UIImage(systemName: "square"), for: .normal)
        button.tintColor = .textColor
        return button
    }()
        //MARK: init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
        setupTargets()
        selectionStyle = .none
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    private func setupUI(){
        contentView.addSubview(label)
        contentView.addSubview(checkboxButton)
        backgroundColor = .bubbleBackground
        label.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(10)
        }
        checkboxButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(16)
            make.top.equalTo(label.snp.top)
        }
    }
    private func setupTargets(){
        checkboxButton.addTarget(self, action: #selector(checkboxButtonTapped), for: .touchUpInside)
    }
    @objc private func checkboxButtonTapped(){
        onButtonTapped?()

    }
    func configureLabel(with text: String){
        label.font = .systemFont(ofSize: 20, weight: .bold)
        checkboxButton.isHidden = true
        label.text = text
    }
    func configure(with data : Filters, isSelected: Bool ){
        if data.status != nil{
            label.text = data.status?.localized
        }
        if data.order != nil{
            label.text = data.order?.localized
        }
        if data.kind != nil{
            label.text = data.kind?.localized
        }
        
        let image = isSelected ? "checkmark.square" : "square"
           checkboxButton.setImage(UIImage(systemName: image), for: .normal)
    }
    
}

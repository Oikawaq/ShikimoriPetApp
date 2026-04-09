
import UIKit
import SnapKit
import Kingfisher


class ContentListView: UIView {
    
    private var stackView: UIStackView = {
        let stack = UIStackView()
        stack.spacing = 4
        stack.axis = .vertical
        stack.alignment = .fill
        stack.distribution = .fill
        stack.backgroundColor = .black
        return stack
    }()
    private let label : UILabel = {
        let label = UILabel()
        label.text = L10n.userRateList.anime
        label.numberOfLines = 1
        label.textColor = .chalkWhite
        return label
    }()
    let tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .insetGrouped)
        tableView.register(ContentListSectionCell.self, forCellReuseIdentifier: ContentListSectionCell.identifier)
        tableView.backgroundColor = .black
        tableView.separatorColor = UIColor(white: 0.2, alpha: 1.0)
//        tableView.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 60)
        tableView.separatorInsetReference = .fromCellEdges
        tableView.setContentHuggingPriority(.defaultLow, for: .vertical)
        
        return tableView
    }()
    override init(frame: CGRect){
        super.init(frame: frame)
        addsViews()
        setupUI()
      
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addsViews(){
    addSubview(stackView)
        [label, tableView].forEach {
            stackView.addArrangedSubview($0)
        }
    }
    private func setupUI(){
        backgroundColor = .black
        stackView.snp.makeConstraints{ make in

            make.top.equalTo(safeAreaLayoutGuide).offset(16)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
        }

    }
}

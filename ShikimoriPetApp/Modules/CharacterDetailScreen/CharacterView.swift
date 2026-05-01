import UIKit
import SnapKit
import SkeletonView

final class CharacterView: UIView {
    
    let tableView = UITableView(frame: .zero, style: .insetGrouped)
    
        //MARK: init
    override init(frame: CGRect){
        super.init(frame: frame)
        addSubview(tableView)
        
        tableView.snp.makeConstraints{make in
            make.edges.equalToSuperview()
        }
        tableView.backgroundColor = .background
        tableView.delaysContentTouches = false
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}

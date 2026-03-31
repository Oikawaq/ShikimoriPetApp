
import UIKit
import SnapKit

final class ListSectionView: UIView {
    var onItemTapped: ((Int) -> Void)?
    private let mainStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 0
        return stack
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
    }

    required init?(coder: NSCoder) { fatalError() }

    private func setupLayout() {
        addSubview(mainStack)
        mainStack.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    struct RowData {
        let title: String
        let subtitle: String
        let imageUrl: String?
        let id: Int?
    }

    func configure(with data: [RowData]) {
        mainStack.arrangedSubviews.forEach { $0.removeFromSuperview() }
        
        data.enumerated().prefix(4).forEach { index, item in
            let row = RowView(
                name: item.title,
                role: item.subtitle,
                imageUrl: item.imageUrl,
            )
            if let id = item.id {
                let tap = UITapGestureRecognizer()
                row.addGestureRecognizer(tap)
                row.isUserInteractionEnabled = true
                tap.addTarget(self, action: #selector(rowTapped(_:)))
                row.tag = id
            }
            mainStack.addArrangedSubview(row)
            
//            if index < data.count - 1 {
//                let separator = UIView()
//                separator.backgroundColor = .basalt
//                
//                separator.snp.makeConstraints {
//                    $0.height.equalTo(1)
//
//                }
//                mainStack.addArrangedSubview(separator)
//            }
        }
    }
    @objc private func rowTapped(_ gesture: UITapGestureRecognizer) {
        guard let view = gesture.view else { return }
        onItemTapped?(view.tag)
    }
}


import UIKit
import SnapKit

final class ListSectionView: UIView {
    var onItemTapped: ((Int,ContentType) -> Void)?
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
    struct RowData: Equatable {
        let title: String
        let subtitle: String
        let imageUrl: String?
        let id: Int?
        let type: ContentType
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
                let tap = ContentTapGesture(target: self, action: #selector(rowTapped(_:)))
                tap.id = id
                tap.type = item.type
                row.isUserInteractionEnabled = true
                row.addGestureRecognizer(tap)
                
    
            }
            mainStack.addArrangedSubview(row)
        }
    }
    @objc private func rowTapped(_ gesture: ContentTapGesture) {
        onItemTapped?(gesture.id, gesture.type)
    }
}
final class ContentTapGesture: UITapGestureRecognizer {
    var id: Int = 0
    var type: ContentType = .animes
}

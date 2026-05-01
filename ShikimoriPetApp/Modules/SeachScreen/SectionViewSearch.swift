
import UIKit
import SnapKit
final class SectionViewSearch: UIView {
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
    struct RowData: Equatable {
        let title: String
        let subtitle: String
        let imageUrl: String?
        let id: Int?
        let score: Double
        
    }
    
    func configure(with data: RowData) {
        mainStack.arrangedSubviews.forEach { $0.removeFromSuperview() }
            let row = RowView(
                name: data.title,
                role: data.subtitle,
                imageUrl: data.imageUrl,
                score: data.score
            )
           
            mainStack.addArrangedSubview(row)
        }
    
}

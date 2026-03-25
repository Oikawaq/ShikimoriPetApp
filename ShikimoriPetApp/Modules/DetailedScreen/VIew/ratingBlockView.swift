import UIKit
import SnapKit

final class RatingBlockView: UIView {
    
    let ratingStarsView = RatingStarsView()
    
    let scoreNumberLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 28, weight: .bold) // Чуть крупнее для акцента
        label.textColor = .label
        return label
    }()

    let scoreTextLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .medium)
        label.textColor = .secondaryLabel
        return label
    }()
    
    private let scoreLabelsStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 2
        return stack
    }()
    
    private let mainHorizontalStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = 16
        stack.alignment = .top
        return stack
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
    }
    
    required init?(coder: NSCoder) { fatalError() }
    
    private func setupLayout() {
        addSubview(mainHorizontalStack)

        scoreLabelsStack.addArrangedSubview(scoreNumberLabel)
        scoreLabelsStack.addArrangedSubview(scoreTextLabel)

        mainHorizontalStack.addArrangedSubview(ratingStarsView)
        mainHorizontalStack.addArrangedSubview(scoreLabelsStack)
        
        mainHorizontalStack.snp.makeConstraints { make in
            make.edges.equalToSuperview() 
        }
        ratingStarsView.snp.makeConstraints { make in
            make.width.equalTo(180) 
            make.height.equalTo(40)
        }
    }
}

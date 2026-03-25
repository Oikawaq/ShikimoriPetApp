import UIKit
import SnapKit

final class RatingStarsView: UIView {
    
    private let stackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = 4
        stack.distribution = .fillEqually
        return stack
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
    }
    
    required init?(coder: NSCoder) { fatalError() }
    
    private func setupLayout() {
        addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    func setRating(_ rating: Double) {
        stackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        
        let fiveStarScale = rating / 2.0
        
        let roundedRating = (fiveStarScale * 2).rounded() / 2.0
        
        for i in 1...5 {
            let imageView = UIImageView()
            imageView.contentMode = .scaleAspectFit
            let floatI = Double(i)
            
            if roundedRating >= floatI {
                imageView.image = UIImage(systemName: "star.fill")
                imageView.tintColor = .systemBlue
            } else if roundedRating >= floatI - 0.5 {
                imageView.image = UIImage(systemName: "star.leadinghalf.filled")
                imageView.tintColor = .systemBlue
            } else {
                imageView.image = UIImage(systemName: "star")
                imageView.tintColor = .systemGray4
            }
            
            stackView.addArrangedSubview(imageView)
        }
    }
}


import UIKit
import SnapKit
import Kingfisher
import SkeletonView
final class UniversalCollectionViewCell: UICollectionViewCell {
    
    static let identifier: String = "UniversalCollectionViewCell"
        //MARK: init
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.backgroundColor = .chalkWhite
        imageView.layer.cornerRadius = 8
        imageView.isSkeletonable = true
        return imageView
    }()
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12, weight: .semibold)
        label.textColor = .textColor
        label.textAlignment = .left
        label.numberOfLines = 2
        label.isSkeletonable = true
        label.skeletonTextNumberOfLines = 2
        return label
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupContraints()
        self.isSkeletonable = true
    }
    private func setupContraints(){
        contentView.addSubview(imageView)
        contentView.addSubview(titleLabel)
        
        imageView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.bottom.equalToSuperview().multipliedBy(0.9)
        }
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(imageView.snp.bottom).offset(4)
            make.leading.trailing.equalToSuperview()
            make.bottom.lessThanOrEqualToSuperview().inset(4).priority(999)
        }
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func configure(with: UniversalCellProtocol){
        titleLabel.text = with.cellTitle
        if let url = with.cellImage {
                let fullPath = URL(string: ("https://shikimori.io" + url))
            imageView.kf.setImage(with: fullPath, options: [.backgroundDecode])
        }
        
    }
}


import UIKit
import SnapKit
import Kingfisher

final class PhotoCell: UICollectionViewCell {
    static let identifier = "PhotoCell"
    private let imageView = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 8
        contentView.addSubview(imageView)
        imageView.snp.makeConstraints { $0.edges.equalToSuperview() }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with url: URL?) {
        imageView.kf.setImage(with: url,
                              options: [
                                  .backgroundDecode,
                                  .cacheOriginalImage
                              ])
    }
}

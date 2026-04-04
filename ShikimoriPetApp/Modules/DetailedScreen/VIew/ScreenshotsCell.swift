
import UIKit
import SnapKit
import Kingfisher
import SkeletonView

final class ScreenshotsCell: UICollectionViewCell {
    static let identifier = "ScreenshotsCell"
    private let imageView = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 8
        imageView.isSkeletonable = true
        self.isSkeletonable = true
        contentView.addSubview(imageView)
        imageView.snp.makeConstraints { $0.edges.equalToSuperview() }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with url: String?) {
        if let url = url{
            let fullpath = URL(string: ("https://shikimori.io" + url))
            imageView.kf.setImage(with: fullpath,
                                  options: [
                                      .backgroundDecode,
                                      .cacheOriginalImage
                                  ])
        }
        
    }
}

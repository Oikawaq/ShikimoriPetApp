import UIKit
import SnapKit
import Kingfisher

final class YouTubePreviewView: UIView {

    var onTap: ((String) -> Void)?
    private var videoId: String = ""

    private let thumbnailImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.layer.cornerRadius = 8
        iv.backgroundColor = .black
        return iv
    }()

    private let playButton: UIView = {
        let container = UIView()
        container.backgroundColor = UIColor.black.withAlphaComponent(0.7)
        container.layer.cornerRadius = 24
        let imageView = UIImageView(image: UIImage(systemName: "play.fill"))
        imageView.tintColor = .white
        imageView.contentMode = .scaleAspectFit
        container.addSubview(imageView)
        imageView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.height.equalTo(22)
        }
        return container
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUI() {
        addSubview(thumbnailImageView)
        addSubview(playButton)

        thumbnailImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.height.equalTo(thumbnailImageView.snp.width).multipliedBy(9.0 / 16.0)
        }

        playButton.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.height.equalTo(48)
        }

        isUserInteractionEnabled = true
        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTap)))
    }

    func configure(videoId: String) {
        self.videoId = videoId
        let thumbUrl = URL(string: "https://img.youtube.com/vi/\(videoId)/hqdefault.jpg")
        thumbnailImageView.kf.setImage(with: thumbUrl, placeholder: UIImage(systemName: "play.rectangle.fill"))
    }

    @objc private func didTap() {
        onTap?(videoId)
    }
}

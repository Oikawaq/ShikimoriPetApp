import UIKit
import SnapKit
import Kingfisher

final class FullScreenImagesVC: UIViewController {
    
    private let urls: [URL]
    private var currentIndex: Int
    
    // MARK: - UI Components
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.itemSize = UIScreen.main.bounds.size
        
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.isPagingEnabled = true
        cv.backgroundColor = .black
        cv.showsHorizontalScrollIndicator = false
        cv.register(ZoomableImageCell.self, forCellWithReuseIdentifier: "ZoomCell")
        cv.dataSource = self
        cv.delegate = self
        return cv
    }()
    
    private let countLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = .systemFont(ofSize: 16, weight: .semibold)
        return label
    }()

    // MARK: - Init
    init(urls: [URL], startIndex: Int) {
        self.urls = urls
        self.currentIndex = startIndex
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) { fatalError() }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        updateCounter()
        setupGestures()
        
        DispatchQueue.main.async {
            self.collectionView.scrollToItem(at: IndexPath(item: self.currentIndex, section: 0),
                                           at: .centeredHorizontally, animated: false)
        }
    }
    
    private func setupUI() {
        view.backgroundColor = .black
        view.addSubview(collectionView)
        view.addSubview(countLabel)
        
        collectionView.snp.makeConstraints { $0.edges.equalToSuperview() }
        countLabel.snp.makeConstraints { make in
            make.bottom.equalTo(view.safeAreaLayoutGuide).offset(-20)
            make.centerX.equalToSuperview()
        }
    }

    private func setupGestures() {

        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        collectionView.addGestureRecognizer(tap)
    }
    
    @objc private func handleTap(_ gesture: UITapGestureRecognizer) {
        dismiss(animated: true)
    }

    private func updateCounter() {
        countLabel.text = "\(currentIndex + 1) / \(urls.count)"
    }
}

// MARK: - CollectionView Extensions
extension FullScreenImagesVC: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return urls.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ZoomCell", for: indexPath) as! ZoomableImageCell
        cell.configure(with: urls[indexPath.item])
        return cell
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let width = scrollView.frame.width
        currentIndex = Int((scrollView.contentOffset.x + (width / 2)) / width)
        updateCounter()
    }
}

// MARK: - ZoomableCell 
final class ZoomableImageCell: UICollectionViewCell, UIScrollViewDelegate {
    
    private let scrollView: UIScrollView = {
        let sv = UIScrollView()
        sv.minimumZoomScale = 1.0
        sv.maximumZoomScale = 4.0 
        sv.showsVerticalScrollIndicator = false
        sv.showsHorizontalScrollIndicator = false
        return sv
    }()
    
    private let imageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.isUserInteractionEnabled = true
        return iv
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(scrollView)
        scrollView.addSubview(imageView)
        scrollView.delegate = self
        
        scrollView.snp.makeConstraints { $0.edges.equalToSuperview() }
        imageView.snp.makeConstraints { $0.edges.size.equalToSuperview() }
    }
    
    required init?(coder: NSCoder) { fatalError() }
    
    func configure(with url: URL) {
        scrollView.setZoomScale(1.0, animated: false) // Сброс зума при переиспользовании
        imageView.kf.setImage(with: url,
                              options: [
                                  .backgroundDecode,
                                  .cacheOriginalImage
                              ])
    }
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }

    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        let offsetX = max((scrollView.bounds.width - scrollView.contentSize.width) * 0.5, 0)
        let offsetY = max((scrollView.bounds.height - scrollView.contentSize.height) * 0.5, 0)
        scrollView.contentInset = UIEdgeInsets(top: offsetY, left: offsetX, bottom: 0, right: 0)
    }
}

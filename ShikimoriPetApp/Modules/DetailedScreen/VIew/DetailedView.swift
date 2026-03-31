import UIKit
import SnapKit

final class DetailView: UIView {
    //MARK: UIComponents
    private let scrollView = UIScrollView()
    
    private let stackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 16
        stack.alignment = .fill
        stack.distribution = .fill
        stack.backgroundColor = .chalkWhite
        return stack
    }()
    private let posterImageContainer: UIView = UIView()
    let posterImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.backgroundColor = .red
        iv.layer.cornerRadius = 8
        return iv
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 24, weight: .bold)
        label.numberOfLines = 0
        label.textColor = .basalt
        return label
    }()
    let favoritesButton: UIButton = {
        let button = UIButton()
        let image = UIImage(systemName: "star")
        button.setImage(image, for: .normal)
        button.tintColor = .basalt
        return button
    }()
    let ratingBlock = RatingBlockView()
    
    private let infortmationContainer = ContainerView(title: "Информация")
    private let infoStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 10
        return stack
    }()
    private let studioContainer: UIView = UIView()
    let studioImage: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        
        iv.clipsToBounds = true
        iv.layer.compositingFilter = "multiplyBlendMode"
        iv.layer.cornerRadius = 8
        return iv
    }()
    private let descriptionContainer = ContainerView(title: "Описание")
    
    let descriptionLabel: UILabel = {
        let label = UILabel()
        label.textColor = .basalt
        label.textAlignment = .left
        label.font = .systemFont(ofSize: 16, weight: .regular)
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        return label
    }()
    let relatedContainer = ContainerView(title: "Связанное")
    let relatedSectionView = ListSectionView()
    private let tagsStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = 8
        stack.alignment = .leading
        stack.distribution = .fill
        return stack
    }()
    let charactersCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.register(UniversalCollectionViewCell.self, forCellWithReuseIdentifier: UniversalCollectionViewCell.identifier)
        cv.backgroundColor = .clear
        cv.showsHorizontalScrollIndicator = false
        return cv
    }()
    private let authorsContainer = ContainerView(title: "Авторы")
    let authorsSectionView = ListSectionView()
    private let MainHeroContainer = ContainerView(title: "Главные герои")
    
    let screenshotsConainer = ContainerView(title: "Кадры")
    let screenshotsCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.register(ScreenshotsCell.self, forCellWithReuseIdentifier: ScreenshotsCell.identifier)
        cv.backgroundColor = .clear
        cv.showsHorizontalScrollIndicator = false
        return cv
    }()
    let userRateStatusButton: UIButton = {
        let button = UIButton()
       
        button.backgroundColor = .basalt
        button.titleLabel?.font = .systemFont(ofSize: 20, weight: .bold)
        button.titleLabel?.textColor = .chalkWhite
        button.layer.cornerRadius = 10
        return button
    }()
    //MARK: init
    override init(frame: CGRect) {
        super.init(frame: frame)
        addsViews()
        setupLayout()
    }
    
    required init?(coder: NSCoder) { fatalError() }
    
    //MARK: setupUI
    
    func createTagLabel(text: String, color: UIColor) -> UILabel {
        let label = UILabel()
        label.text = text
        label.font = .systemFont(ofSize: 12, weight: .bold)
        label.textColor = .chalkWhite
        label.backgroundColor = color
        label.textAlignment = .center
        label.layer.cornerRadius = 6
        label.clipsToBounds = true
        
        label.snp.makeConstraints { make in
            make.width.greaterThanOrEqualTo(label.intrinsicContentSize.width + 20)
            make.height.equalTo(24)
        }
        return label
    }
    
    private func createInfoRow(title: String, value: String?) -> UIView {
        let view = UIView()
        
        let keyLabel = UILabel()
        keyLabel.text = title
        keyLabel.textColor = .basalt
        keyLabel.font = .systemFont(ofSize: 14)
        
        let valueLabel = UILabel()
        valueLabel.text = value
        valueLabel.textColor = .basalt
        valueLabel.font = .systemFont(ofSize: 14, weight: .medium)
        valueLabel.numberOfLines = 0
        
        view.addSubview(keyLabel)
        view.addSubview(valueLabel)
        
        keyLabel.snp.makeConstraints { make in
            make.leading.top.bottom.equalToSuperview()
            make.width.equalTo(150)
        }
        
        valueLabel.snp.makeConstraints { make in
            make.leading.equalTo(keyLabel.snp.trailing).offset(8)
            make.trailing.top.bottom.equalToSuperview()
        }
        
        return view
    }
    
    func configureInfoBlock(with details: [(key: String, value: String)]) {
        infoStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        
        details.forEach { item in
            let row = createInfoRow(title: item.key, value: item.value)
            infoStackView.addArrangedSubview(row)
        }
    }
    func configureTags(with tags: [DetailedViewModel.TagData]) {
        tagsStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        
        tags.forEach { tag in
            let color: UIColor
            switch tag.type {
            case .released: color = .systemGreen
            case .ongoing:  color = .systemOrange
            case .year: color = .systemBlue
            }
            
            let tagLabel = createTagLabel(text: tag.text, color: color)
            tagsStackView.addArrangedSubview(tagLabel)
        }
        
        let spacer = UIView()
        tagsStackView.addArrangedSubview(spacer)
    }
    
    private func addsViews(){
        addSubview(scrollView)
        scrollView.addSubview(stackView)
        [
            titleLabel,
            posterImageContainer,
            ratingBlock,
            tagsStackView,
            userRateStatusButton,
            studioContainer,
            infortmationContainer,
            infoStackView,
            descriptionContainer,
            descriptionLabel,
            relatedContainer,
            relatedSectionView,
            authorsContainer,
            authorsSectionView,
            MainHeroContainer,
            charactersCollectionView,
            screenshotsConainer,
            screenshotsCollectionView
            
        ].forEach { stackView.addArrangedSubview($0) }
        posterImageContainer.addSubview(posterImageView)
        posterImageContainer.addSubview(favoritesButton)
        studioContainer.addSubview(studioImage)
        
    }
    
    //MARK: setupContraints
    private func setupLayout(){
        backgroundColor = .chalkWhite
        scrollView.decelerationRate = .normal
        studioContainer.backgroundColor = .chalkWhite
        
        scrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        stackView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(16)
            make.width.equalToSuperview().offset(-32)
        }
        posterImageContainer.snp.makeConstraints{make in
            make.height.equalTo(450)
        }
        posterImageView.snp.makeConstraints { make in
            make.leading.top.bottom.equalToSuperview()
            make.width.equalTo(300)
        }
        studioContainer.snp.makeConstraints { make in
            make.height.equalTo(80)
        }
        studioImage.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.bottom.equalToSuperview()
            make.width.equalTo(220)
        }
        charactersCollectionView.snp.makeConstraints { make in
            make.height.equalTo(200)
        }
        screenshotsCollectionView.snp.makeConstraints { make in
            make.height.equalTo(215)
        }
        userRateStatusButton.snp.makeConstraints { make in
            make.height.equalTo(50)
        }
        favoritesButton.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(16)
            make.left.equalTo(posterImageView.snp.right).offset(16)
            make.trailing.equalToSuperview().inset(16)
        }
    }
}

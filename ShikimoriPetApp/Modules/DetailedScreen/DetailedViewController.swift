import UIKit
import SnapKit
import Kingfisher
import Combine

@MainActor
final class DetailedViewController: UIViewController {
    private var cancellables = Set<AnyCancellable>()
    private let viewModel: DetailedViewModel
    private var detailView: DetailView? {
           view as? DetailView
       }
    

    override func loadView() {
        self.view = DetailView()
    }
    //MARK: init
    init(viewModel: DetailedViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder: NSCoder) { fatalError() }
    
    //MARK: lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionVIew()
        setupBindings()
        loadAllData()
        setupButtonsAction()
        setupCallbacks()
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if viewModel.isLoading {
            detailView?.userRateStatusButton.showSkeleton()
        }
    }
    
    private func loadAllData(){
        viewModel.loadUserRate()
        
        let delay = 0.2
            DispatchQueue.main.asyncAfter(deadline: .now() + delay * 1) { self.viewModel.loadData() }
            DispatchQueue.main.asyncAfter(deadline: .now() + delay * 2) { self.viewModel.loadCharacters() }
            DispatchQueue.main.asyncAfter(deadline: .now() + delay * 3) { self.viewModel.loadScreenshots() }
            DispatchQueue.main.asyncAfter(deadline: .now() + delay * 4) { self.viewModel.loadAuthors() }
            DispatchQueue.main.asyncAfter(deadline: .now() + delay * 5) { self.viewModel.loadRelated() }
       
        
    }
    private func setupButtonsAction(){
        detailView?.userRateStatusButton.addTarget(self, action: #selector(statusButtonTapped), for: .touchUpInside)
    }
    
    @objc func statusButtonTapped(){
        let vm = viewModel.makeRateEditorVM()
        let vc = RateEditorVC(viewModel: vm)
        
        
        if let sheet = vc.sheetPresentationController {
            sheet.detents = [.medium(), .large()]
            sheet.prefersGrabberVisible = true
        }
        present(vc, animated: true)

    }
    //MARK: setupUI
    private func setupCollectionVIew(){
        detailView?.collectionView.dataSource = self
        detailView?.collectionView.delegate = self
        
        detailView?.photosCollectionView.dataSource = self
        detailView?.photosCollectionView.delegate = self
    }
    private func setupBindings() {
        viewModel.$anime
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.updateHeaderInfo()
            }
            .store(in: &cancellables)

        viewModel.$characters
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.detailView?.collectionView.reloadData()
            }
            .store(in: &cancellables)

        viewModel.$screenshots
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.detailView?.photosCollectionView.reloadData()
            }
            .store(in: &cancellables)

        viewModel.$authorsRowData
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                guard let self = self else { return }
                self.detailView?.authorsSectionView.configure(with: self.viewModel.authorsRowData)
            }
            .store(in: &cancellables)
            
        viewModel.$userRate
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                guard let self = self else { return }
                self.detailView?.userRateStatusButton.setTitle(self.viewModel.statusButtonText, for: .normal)
            }
            .store(in: &cancellables)
        viewModel.$relatedRowData
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.detailView?.relatedSectionView.configure(with: self?.viewModel.relatedRowData ?? [])
            }
            .store(in: &cancellables)
        viewModel.$isLoading
            .receive(on: DispatchQueue.main)
            .sink { [weak self] isLoading in
                guard let self = self else { return }
                let button = self.detailView?.userRateStatusButton
                
                if isLoading {
                    button?.setTitle("", for: .normal)
                    button?.showSkeleton()
                } else {
                    button?.hideSkeleton()
                    button?.setTitle(self.viewModel.statusButtonText, for: .normal)
                }
            }
            .store(in: &cancellables)
    }
    private func updateHeaderInfo() {
        guard let detailView = detailView else { return }
        
        detailView.titleLabel.text = viewModel.title
        detailView.descriptionLabel.text = viewModel.description
        detailView.configureTags(with: viewModel.tagsData)
        detailView.configureInfoBlock(with: viewModel.infoDetails)
        
        detailView.ratingBlock.ratingStarsView.setRating(viewModel.numericScore)
        detailView.ratingBlock.scoreNumberLabel.text = viewModel.score
        detailView.ratingBlock.scoreTextLabel.text = viewModel.ratingText

        if let url = viewModel.studiosImage{
            detailView.studioImage.kf.setImage(with: url, options: [.backgroundDecode,
                                                                                       .cacheOriginalImage])
        }
        if let url = viewModel.imageURL {
            detailView.posterImageView.kf.setImage( with: url,
                                                    options: [
                                                        .backgroundDecode,
                                                        .cacheOriginalImage
                                                    ])
        }
      
    }
    private func setupCallbacks(){
        guard let detailView = detailView else { return }
        
        detailView.relatedSectionView.onItemTapped = { [weak self] id in
            guard let self else { return }
            let vm = DetailedViewModel(animeID: id)
            let vc = DetailedViewController(viewModel: vm)
            navigationController?.pushViewController(vc, animated: true)
        }
    }
}
// MARK: - CollectionView DataSource & Delegate
extension DetailedViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return collectionView == detailView?.collectionView ? viewModel.characters.count : viewModel.screenshots.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == detailView?.collectionView {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CharactersCell.identifier, for: indexPath) as? CharactersCell else {
                return UICollectionViewCell()
            }
            cell.configure(with: viewModel.characters[indexPath.item])
            return cell
        } else {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotoCell.identifier, for: indexPath) as? PhotoCell else {
                return UICollectionViewCell()
            }
           
            let url = URL(string: "https://shikimori.io" + (viewModel.screenshots[indexPath.item].original ?? ""))
            cell.configure(with: url)
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == detailView?.collectionView {
            guard let character = viewModel.characters[indexPath.item].character else { return }
            let vc = CharacterProfileVC(viewModel: CharacterViewModel(character: character))
//            present(vc, animated: true)
            navigationController?.pushViewController(vc, animated: true)
        } else {
            let fullScreenVC = FullScreenImagesVC(urls: viewModel.screenshotURLs, startIndex: indexPath.item)
            fullScreenVC.modalPresentationStyle = .overFullScreen
            fullScreenVC.modalTransitionStyle = .crossDissolve
            present(fullScreenVC, animated: true)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return collectionView == detailView?.collectionView ? CGSize(width: 100, height: 200) : CGSize(width: 180, height: 100)
    }
    //vertical spacing
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 15
    }
    //horizontal
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        if collectionView == detailView?.collectionView {
            return 0
        }else{
            return 15
        }
        
    }
}

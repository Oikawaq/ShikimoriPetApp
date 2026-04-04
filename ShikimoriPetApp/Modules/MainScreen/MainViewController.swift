
import UIKit
import Combine
import SkeletonView
class MainViewController: UIViewController {
    var cancellables = Set<AnyCancellable>()
    let viewModel = MainViewModel()
    private var mainView: MainView? {
           view as? MainView
       }
    
    override func loadView() {
        view = MainView()
    }
    //MARK: lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
        mainView?.showSkeleton()
        viewModel.switchContent(to: viewModel.contentType)
    }
    override func viewDidAppear(_ animated: Bool) {
        setupBindings()
        updateType()
        
    }
    private func setupBindings(){
        viewModel.$content
            .dropFirst()
            .receive(on: DispatchQueue.main)
            .sink{ [weak self ] _ in
                guard let self = self else {return}
                self.mainView?.hideSkeleton()
                self.mainView?.collectionView.reloadData()
                self.mainView?.collectionView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
            }
            .store(in: &cancellables)
        viewModel.$contentType
            .receive(on: DispatchQueue.main)
            .sink{ [weak self ] _ in
                guard let self = self else {return}
                self.mainView?.typeSelectorButton.setTitle(self.viewModel.contentType.title, for: .normal)
                self.mainView?.collectionView.reloadData()
            }
            .store(in: &cancellables)
    }
    
    private func setupCollectionView(){
        mainView?.collectionView.dataSource = self
        mainView?.collectionView.delegate = self
    }
    private func updateType(){
     
        
        let type:[ContentType] = [.animes , .mangas, .ranobe]
        
        let actions = type.map{type in
            return UIAction(title: type.title, state: type == viewModel.contentType ? .on: .off){[weak self] _ in
            guard let self = self else {return}
                self.viewModel.switchContent(to: type)
                self.updateType()
            }
        }
        mainView?.typeSelectorButton.menu = UIMenu(children: actions)
    }
}
 
extension MainViewController: UICollectionViewDelegate, SkeletonCollectionViewDataSource {
    func collectionSkeletonView(_ skeletonView: UICollectionView, cellIdentifierForItemAt indexPath: IndexPath) -> SkeletonView.ReusableCellIdentifier {
        return ItemsListCell.identifier
    }
    func collectionSkeletonView(_ skeletonView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.content.count
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 60)
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ItemsListCell.identifier, for: indexPath) as? ItemsListCell else {
            return UICollectionViewCell()
        }
        let anime = viewModel.content[indexPath.row]
        cell.configure(with: anime)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionFooter {
            guard let footer = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: FooterView.identifier, for: indexPath) as? FooterView else {
                return UICollectionReusableView()
            }
            
            footer.configure(page: viewModel.currentPage)
            
            footer.onNextPage = { [weak self] in
                self?.viewModel.loadNextPage()
            }
            
            footer.onPrevPage = { [weak self] in
                self?.viewModel.loadPreviousPage()
            }
            
            return footer
        }
        return UICollectionReusableView()
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedItem = viewModel.content[indexPath.item]
        let detailVM = DetailedViewModel(contentList: selectedItem, contentType: viewModel.contentType)
        print(viewModel.contentType)
        let detailVC = DetailedViewController(viewModel: detailVM)
        
        navigationController?.pushViewController(detailVC, animated: true)
    }
    
}
extension MainViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let sideInset: CGFloat = 16
        let interItemSpacing: CGFloat = 8
        let width = (collectionView.frame.width - (sideInset * 2) - interItemSpacing) / 2
        let height = (collectionView.frame.height)*0.5
        return CGSize(width: width, height: height)
    }
    //vertical
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    //horizontal
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}

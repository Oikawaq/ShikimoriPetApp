
import UIKit
import Combine

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
        setupBindings()
        
        viewModel.loadAnimeList(currentPage: viewModel.currentPage)
        
        
    }
    private func setupBindings(){
//        viewModel.onDataLoaded = { [weak self] in
//            self?.mainView?.collectionView.reloadData()
//           
//        }
        viewModel.$anime
            .receive(on: DispatchQueue.main)
            .sink{ [weak self ] _ in
                self?.mainView?.collectionView.reloadData()
                self?.mainView?.collectionView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
            }
            .store(in: &cancellables)
    }
    private func setupCollectionView(){
        mainView?.collectionView.dataSource = self
        mainView?.collectionView.delegate = self
    }
}
 
extension MainViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.anime.count
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 60)
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AnimeListCell.identifier, for: indexPath) as? AnimeListCell else {
            return UICollectionViewCell()
        }
        let anime = viewModel.anime[indexPath.row]
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
            
            // Передаем текущую страницу
            footer.configure(page: viewModel.currentPage)
            
            // Подписываемся на действия
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
        let selectedAnime = viewModel.anime[indexPath.item]
        let detailVM = DetailedViewModel(animeList: selectedAnime)
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

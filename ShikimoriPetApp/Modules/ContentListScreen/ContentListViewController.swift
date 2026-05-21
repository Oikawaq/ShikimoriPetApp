

import UIKit
import Combine

class ContentListViewController: UIViewController {
    private var cancellables: Set<AnyCancellable> = []
    private var contentListView: ContentListView?{
        view as? ContentListView
    }
    var viewModel: ContentListViewModel
        //MARK: lifecycle
    override func loadView() {
        view = ContentListView()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        setupBindings()
        viewModel.loadUserList()
    }
    
        //MARK: init
    init(viewModel: ContentListViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    private func setupBindings(){
        viewModel.$sections
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                guard let self = self else {return}
                contentListView?.tableView.reloadData()
            }
            .store(in: &cancellables)
        viewModel.$list
            .receive(on: DispatchQueue.main)
            .sink{ [weak self ] _ in
                guard let self = self else {return}
                self.contentListView?.tableView.reloadData()
                
            }
            .store(in: &cancellables)
            
            
    }
    private func setupTableView(){
        contentListView?.tableView.dataSource = self
        contentListView?.tableView.delegate = self
    }

}
extension ContentListViewController: UITableViewDataSource, UITableViewDelegate{
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.sections.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.sections[section].item.count + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ContentListSectionCell.identifier) as? ContentListSectionCell else {
            return UITableViewCell()
        }
        if indexPath.row == 0{
            let item = viewModel.sections[indexPath.section].status.animeRuDesc
            cell.configureHeader(with: item)
            return cell
        }else{
            
            
            let item = viewModel.sections[indexPath.section].item[indexPath.row - 1]
            cell.configure(with: item, number: indexPath.row)
            cell.isStacktapped = {[weak self ] id in
                guard let self = self else {return}
                if self.viewModel.userId != UserDefaults.standard.integer(forKey: UserDefaultsEnum.userId.value){
                    return
                }
                
                self.viewModel.linkId = id
               let vm = RateEditorViewModel(
                watchingStatus: item.status,
                maxEpisodes: item.anime?.episodesAired ?? 0,
                currentScore: item.score ?? 0,
                currentEpisodes: item.episodes ?? 0,
                onSave: {[weak self ] status, score, episodes in
                    guard let self = self else {return}
                    self.viewModel.updateRate(status: status, score: score, episodes: episodes)
                    
                })
                let vc = RateEditorVC(viewModel: vm, type: self.viewModel.type)
                if let sheet = vc.sheetPresentationController{
                    sheet.detents = [.medium(), .large()]
                    sheet.prefersGrabberVisible = true
                }
                self.present(vc, animated: true)
            }
            return cell
        }
    }

    
}

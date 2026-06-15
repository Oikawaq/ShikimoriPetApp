import Combine
import Foundation
import Apollo
import ApolloAPI
@MainActor
class DetailedViewModel{
    private let itemsId: Int
    let contentList: ContentListModel?
    
    var type: ContentType
    var page: Int = 1
    var canLoadMore: Bool = false
    typealias animeInfo  = ShikimoriSchema.GetAnimeInfoQuery
    typealias mangaInfo  = ShikimoriSchema.GetMangaInfoQuery
    typealias animeModel = ShikimoriSchema.GetAnimeInfoQuery.Data.Anime
    typealias mangaModel = ShikimoriSchema.GetMangaInfoQuery.Data.Manga
    var itemInformation: ContentItemModel?
//    var item: ContentItemModel?
    var topicId: Int {
        itemInformation?.topic ?? 0
    }
    //MARK: Published Properties
    @Published var item: ContentItemModel?
    @Published var userRate: [UserRate] = []
    @Published var isLoading: Bool = false
    @Published var isFavorite: Bool = false
    @Published var comments: [CommentsModel] = []
    @Published var topics: [TopicsModel] = []
    @Published var itemInfo: [animeModel] = []
    private var cancellables = Set<AnyCancellable>()
    
    var userID: Int {
        UserDefaults.standard.integer(forKey: UserDefaultsEnum.userId.value)
    }
    var score: String {
        return String(describing: itemInformation?.score ?? 0)
    }
    var statusButtonText: String {
        guard !isLoading else { return "Загрузка..." }
        guard let rate = userRate.first else { return "Добавить в список" }
        let status = type == .animes ? WatchingStatus(rawValue: rate.status ?? "")?.animeRuDesc ?? "Добавить в список" : WatchingStatus(rawValue: rate.status ?? "")?.mangaRuDesc ?? "Добавить в список"
        let score = rate.score ?? 0
        return score > 0 ? "\(status) — \(score)" : status
    }
    var characters: [PersonProtocol]{
        itemInformation?.characters?.filter{ character in
            character.rolesEn?.contains("Main") ?? false
            
        } ?? []
    }
    var authorsRowData: [ListSectionView.RowData] {
        guard let roles = itemInformation?.personRoles else { return [] }
        
        let filtered = roles.filter { !Set($0.rolesEn ?? []).isDisjoint(with: targetRoles(for: type)) }
        
        let sorted = filtered.sorted { $0.rolesEn?.contains("Original Creator") ?? false && !($1.rolesEn?.contains("Original Creator") ?? false) }
        
        return sorted.prefix(4).map { person in
            ListSectionView.RowData(
                title: person.person.russian ?? "",
                subtitle: person.rolesRu?.joined(separator: ", "),
                imageUrl: person.person.poster,
                id: Int(person.person.id ?? "0"),
                type: .animes
            )
        }
    }
    var genres: String{
        guard let info = itemInformation else { return "" }
        let genres = info.genres?.compactMap{genre in
            if genre.kind == .genre || genre.kind == .demographic{
                return genre.russian
            }
            return nil
        }
        return genres?.joined(separator: ", ") ?? ""
    }
    var relatedRowDataTest: [ListSectionView.RowData]{
        itemInformation?.related?
            .map{ related in
                ListSectionView.RowData(
                    title: related.anime?.russian ?? related.manga?.russian ?? "",
                    subtitle: related.relationText ?? "",
                    imageUrl: related.anime?.poster ?? related.manga?.poster,
                    id: Int(related.anime?.id ?? "") ?? Int(related.manga?.id ?? ""),
                    type: type)
            } ?? []
    }
    //MARK: Computed properties
    
    struct TagData {
        let text: String
        let type: StatusType
    }
    enum StatusType {
        case released
        case ongoing
        case year
    }
    
    var statusType: StatusType {
        return status == "Вышло" ? .released : .ongoing
    }
    
    var tagsData: [TagData] {
        return [
            TagData(text: year, type: .year),
            TagData(text: status, type: statusType)
        ]
    }
    var NumberOfSections: [DetailedSection]{
        let sections =  DetailedSection.allCases.filter { section in
            switch section {
            case .posters: return type == .animes
            case .studio: return type == .animes
            case .related:return !relatedRowDataTest.isEmpty
            case .authors:return !authorsRowData.isEmpty
                
            default: return true
            }
        }
        return sections
    }
    var watchingStatus: WatchingStatus {
        let rawValue = userRate.first?.status ?? ""
        return WatchingStatus(rawValue: rawValue) ?? .none
    }
    //MARK: init
    init(contentList: ContentListModel, contentType: ContentType) {
        self.contentList = contentList
        self.itemsId = Int(contentList.id)!
        self.type = contentType
        setupFavoritesBinding()
    }
    init(itemId: Int,contentType: ContentType){
        self.itemsId = itemId
        self.contentList = nil
        self.type = contentType
        setupFavoritesBinding()
    }
    
    private var nextEpisode: String? {
        return itemInformation?.nextEpisodeAt
    }

    private var nextEpisodeText: String? {
        return DateKit.formatAbsoluteEpisodeTime(from: nextEpisode ?? "Нет информации")
    }
    var imageURL: URL? {
        let fullPath = contentList?.image ?? itemInformation?.image ?? ""
        return URL(string: fullPath)
    }
    var studiosImage: URL? {
        guard let url = itemInformation?.studios else { return nil}
        return URL(string: url)
    }
    var infoDetails: [(key: String, value: String)] {
        var details: [(key: String, value: String)] = []
        
        details.append(("Тип", kind))
        let contentType = type
        switch contentType {
        case .animes:
            details.append(("Эпизоды", episodes))
        case .mangas, .ranobe:
            details.append(("Тома", volumes))
            details.append(("Главы", chapters))
        }
        
        
        if itemInformation?.kind?.value?.rawValue == "movie", let duration = itemInformation?.duration {
            details.append(("Длительность: ", "\(duration) мин."))
        }
        
        details.append(("Статус", status))
        if nextEpisode != nil {
            details.append(("Следующий эпизод: ", nextEpisodeText ?? "Нет информации"))
        }
        if genres != ""{
            details.append(("Жанры", genres))
        }
        
        return details
    }
    var chapters: String{
        guard let chapters = itemInformation?.chapters else{ return "?"}
        return "\(chapters)"
    }
    var volumes: String{
        guard let volumes = itemInformation?.volumes else{ return "?"}
        return "\(volumes)"
    }
    var episodes: String {
            let aired = itemInformation?.episodesAired ?? 0
            let total = itemInformation?.episodes ?? 0
            var totalText = "\(total)"
            if aired > total{
                totalText = "?"
            }
            switch status {
            case "Онгоинг": return "\(aired) / \(totalText)"
            default: return totalText
            }
    }
    
    var kind: String {
        switch itemInformation?.kind?.value {
        case .some(.cm):
            return L10n.sideMenuKind.cm.localized
        case .some(.tv):
            return L10n.sideMenuKind.tv.localized
        case .some(.movie):
            return L10n.sideMenuKind.movie.localized
        case .some(.ova):
            return L10n.sideMenuKind.ova.localized
        case .some(.ona):
            return L10n.sideMenuKind.ona.localized
        case .some(.special):
            return L10n.sideMenuKind.tv_special.localized
        case .some(.tvSpecial):
            return L10n.sideMenuKind.tv_special.localized
        case .some(.music):
            return L10n.sideMenuKind.music.localized
        case .some(.pv):
            return L10n.sideMenuKind.pv.localized
        case .none:
            return ""
        case .some(.manga):
            return L10n.sideMenuKind.manga.localized
        case .some(.lightNovel):
            return L10n.sideMenuKind.light_novel.localized
        case .some(.novel):
            return L10n.sideMenuKind.novel.localized
        case .some(.oneShot):
            return L10n.sideMenuKind.one_shot.localized
        case .some(.doujin):
            return L10n.sideMenuKind.doujin.localized
        case .some(.manhwa):
            return L10n.sideMenuKind.manhwa.localized
        case .some(.manhua):
            return L10n.sideMenuKind.manhua.localized
        }
    }
    
    var title: String { "\(contentList?.russian ?? itemInformation?.russian ?? "Нет названия") / \(contentList?.name ?? itemInformation?.name ?? "Нет названия")" }
    
    var numericScore: Double {
        return Double(contentList?.score ?? 0)
    }
    
    var ratingText: String {
        let s = numericScore
        if s >= 9 { return "Великолепно" }
        if s >= 8 { return "Отлично" }
        if s >= 7 { return "Хорошо" }
        return "Нормально"
    }
    
    var description: NSAttributedString {
        (itemInformation?.description ?? "").parseDescriptionBBCode()
    }
    
    var status: String {
        switch itemInformation?.status?.value {
        case .some(.anons):
            return "Анонсировано"
        case .some(.ongoing):
            return "Онгоинг"
        case .some(.released):
            return "Вышло"
        case  .some(.paused):
            return "Приостановлено"
        case .some(.discontinued):
            return "Прекращено"
        case .none:
            return "Неизвестно"
        }
    }
    
    var year: String {
        return String(describing: itemInformation?.airedOn ?? 0)
    }
    var screenshotsPreview: [URL] {
        return itemInformation?.screenshots?.compactMap{
            URL(string: $0.preview)
        } ?? []
      
    }
    var screenshotOriginal: [URL]{
        return itemInformation?.screenshots?.compactMap{
            URL(string: $0.original)
        } ?? []
    }
    var maxEpisodesBug: Int {
        switch type{
        case .animes:
            let aired = item?.episodesAired.map { "\($0)" } ?? "?"
            let total = item?.episodes.map { "\($0)" } ?? "?"
            if aired > total{
                return item?.episodesAired ?? 0
            }
            return item?.episodes ?? 0
        case .mangas,.ranobe:
            return item?.chapters ?? 0
        }
        
    }
    var currentEpisode: Int?{
        return type == .animes ? userRate.first?.episodes : userRate.first?.chapters
        
    }
    var viewed: String{
        return type == .animes ? "episodes" : "chapters"
    }
    func makeRateEditorVM() -> RateEditorViewModel {
            RateEditorViewModel(
                watchingStatus: watchingStatus,
                maxEpisodes: maxEpisodesBug,
                currentScore: userRate.first?.score ?? 0,
                currentEpisodes: currentEpisode ?? 0,
                onSave: { [weak self] status, score, episodes in
                    self?.updateFullRate(status: status, score: score, episodes: episodes)
                }
        )
        
    }

    //MARK: Network Methods
    func loadAllData() async{
       
        switch type{
            
        case .animes:
            await fetchAnimeInfo()
        case .mangas:
            await fetchMangaInfo()
        case .ranobe:
            print("www")
        }
        await loadUserRate()
//        await loadData()
      
        loadComments()

    }
    func fetchAnimeInfo() async{
        let id = String(itemsId)
            do{
                let response = try await ApolloService.shared.client.fetch(query: animeInfo(ids: .some(id)))
                await MainActor.run{
                    if let animeResponse = response.data?.animes.first {
                        itemInformation = .init(anime: animeResponse)
                    }
                }
            } catch{
                print("Fetched error : \(error)")
            }
    }
    func fetchMangaInfo() async{
        let id = String(itemsId)
            do{
                let response = try await ApolloService.shared.client.fetch(query: mangaInfo(ids: .some(id)))
                await MainActor.run{
                    if let mangaResponse = response.data?.mangas.first {
                        itemInformation = .init(manga: mangaResponse)
                    }
                }
               
            } catch{
                print("Fetched error : \(error)")
            }
        
        
    }

    
    
    func updateFullRate(status: WatchingStatus, score: Int, episodes: Int) {
        if status == .none {
            deleteRate()
        }
        if userRate.first?.id == nil {
            createRate(status: status, score: score, episodes: episodes)
        }else {
            updateRate(status: status, score: score, episodes: episodes)
        }
    }
    
    private func createRate(status: WatchingStatus, score: Int, episodes: Int) {
        let body = makeCreateBody(status: status, score: score, episodes: episodes)
        NetworkManager.shared.request(endpoint: .createUserRate, method: .post, body: body)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { _ in }, receiveValue: { [weak self] (newRate: UserRate) in
                self?.userRate = [newRate]
            })
            .store(in: &cancellables)
    }
    
    private func deleteRate() {
        guard let rateID = userRate.first?.id else { return }
        NetworkManager.shared.requestVoid(endpoint: .deleteUserRate(linkID: rateID), method: .delete)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: {[weak self]  completion in
                
                switch completion{
                case .finished:
                self?.userRate = []
                case .failure(let error):
                    print("Ошибка, \(error)")
                }
            }, receiveValue: { _ in })
            .store(in: &cancellables)
    }
    
    private func updateRate(status: WatchingStatus, score: Int, episodes: Int) {
        guard let rateID = userRate.first?.id else { return }
        let body = makeUpdateBody(status: status, score: score, episodes: episodes)
        NetworkManager.shared.request(endpoint: .userRateUpdate(linkID: rateID), method: .put, body: body)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { _ in }, receiveValue: { [weak self] (updated: UserRate) in
                self?.userRate = [updated]
            })
            .store(in: &cancellables)
    }
    
    private func makeCreateBody(status: WatchingStatus, score: Int, episodes: Int) -> [String: Any] {
        return [
            "user_rate": [
                "user_id": userID,
                "target_id": itemsId,
                "target_type": type.apiPath,
                "status": status.rawValue,
                "score": score,
                viewed: episodes
            ]
        ]
    }
    private func makeUpdateBody(status: WatchingStatus, score: Int, episodes: Int) -> [String: Any] {
        return [
            "user_rate": [
                "status": status.rawValue,
                "score": score,
                viewed: episodes
            ]
        ]
    }
//    private func loadData() async{
//        NetworkManager.shared.request(endpoint: .contentDetails(id: itemsId, contentType: type), method: .get)
//            .replaceError(with: nil)
//            .receive(on: DispatchQueue.main)
//            .assign(to: &$item)
//    }


    private func targetRoles(for type: ContentType) -> Set<String> {
        switch type {
        case .animes:
            return ["Original Creator", "Chief Producer", "Chief Animation Director", "Director", "Writer"]
        case .mangas:
            return ["Story & Art", "Art"]
        case .ranobe:
            return ["Story", "Art"]
        }
    }

    private func loadUserRate() async{
    
        NetworkManager.shared.request(endpoint: .checkUserRates(userID: userID, targetID: itemsId, contentType: type), method: .get)
            .replaceError(with: [])
            .receive(on: DispatchQueue.main)
            .sink { [weak self] (rates: [UserRate]) in
                guard let self = self else { return }
                self.userRate = rates
            }
            .store(in: &cancellables)
    }
    private func setupFavoritesBinding() {
        FavouritesManager.shared.$isLoaded
            .filter { $0 }
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                guard let self else { return }
                self.isFavorite = FavouritesManager.shared.contains(self.itemsId, type: setFavoriteType())
            }
            .store(in: &cancellables)
    }
    private func setFavoriteType() -> FavoriteType{
        let favoriteType: FavoriteType
        switch type {
        case .animes:
            favoriteType = .anime
        case .mangas:
            favoriteType = .manga
        case .ranobe:
            favoriteType = .ranobe
        default : favoriteType = .character
        }
        return favoriteType
    }
    
    private func loadComments(){
        CommentService.shared.loadComments(id: topicId, page: page, type: .topic)
            .replaceError(with: [])
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: {_ in }, receiveValue: {[weak self ] (newComment: [CommentsModel]) in
                guard let self = self else {return}
                
                let combined:[CommentsModel] = self.comments + newComment
                var seen = Set<Int>()
                let unique = combined.filter{
                    seen.insert($0.id).inserted
                }
                self.comments = CommentService.shared.filter(unique: unique)
                self.canLoadMore = unique.count < 10 ? false: true
            })
            .store(in: &cancellables)
    }
    func moreComments(){
        page += 1
        loadComments()
    }
    
    func toggleFavorite() {
        FavouritesManager.shared.toggleFavorite(id: itemsId, type: setFavoriteType())
        isFavorite.toggle()
    }
}

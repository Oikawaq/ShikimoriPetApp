import Combine
import Foundation

@MainActor
class DetailedViewModel{
    private let itemsId: Int
    let contentList: ContentListModel?
    
    var type: ContentType
    
    //MARK: Published Properties
    @Published var item: ContentItemModel?
    @Published var characters: [CharacterRoleModel] = []
    @Published var screenshots: [Screenshots] = []
    @Published var authors: [AuthorModel] = []
    @Published var relatedAnimeList: [RelatedAnime] = []
    @Published var userRate: [UserRate] = []
    @Published var authorsRowData: [ListSectionView.RowData] = []
    @Published var relatedRowData: [ListSectionView.RowData] = []
    @Published var isLoading: Bool = false
    @Published var isFavorite: Bool = false
    
    private var cancellables = Set<AnyCancellable>()
    
    var userID: Int {
        UserDefaults.standard.integer(forKey: UserDefaultsEnum.userId.value)
    }
    var score: String {
        return contentList?.score ?? item?.score ?? "Нет информации"
    }
    var statusButtonText: String {
        guard !isLoading else { return "Загрузка..." }
        guard let rate = userRate.first else { return "Добавить в список" }
        let status = type == .animes ? WatchingStatus(rawValue: rate.status ?? "")?.animeRuDesc ?? "Добавить в список" : WatchingStatus(rawValue: rate.status ?? "")?.mangaRuDesc ?? "Добавить в список"
        let score = rate.score ?? 0
        return score > 0 ? "\(status) — \(score)" : status
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
            case .related:return !relatedRowData.isEmpty
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
        self.itemsId = contentList.id
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
        return item?.nextEpisodeAt
        
    }
    private var nextEpisodeDate: Date? {
        guard let date = nextEpisode else { return nil}
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]

        return formatter.date(from: date)
    }
    private var nextEpisodeText: String? {
        guard let date = nextEpisodeDate else { return nil}
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ru-RU")
        formatter.dateFormat = "d MMMM HH:mm"
        return formatter.string(from: date)
    }
    var imageURL: URL? {
        let fullPath = "https://shikimori.io" + (contentList?.image.original ?? item?.image?.original ?? "")
        return URL(string: fullPath)
    }
    var studiosImage: URL? {
        guard let url = item?.studios?.first?.image else { return nil}
        let fullpath = "https://shikimori.io" + url
        return URL(string: fullpath)
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
        
        
        if item?.kind == "movie", let duration = item?.duration {
            details.append(("Длительность: ", "\(duration) мин."))
        }
        
        details.append(("Статус", status))
        if nextEpisode != nil {
            details.append(("Следующий эпизод: ", nextEpisodeText ?? "Нет информации"))
        }
        return details
    }
    var chapters: String{
        guard let chapters = item?.chapters else{ return "?"}
        return "\(chapters)"
    }
    var volumes: String{
        guard let volumes = item?.volumes else{ return "?"}
        return "\(volumes)"
    }
    var episodes: String {
            let aired = item?.episodesAired.map { "\($0)" } ?? "?"
            var total = item?.episodes.map { "\($0)" } ?? "?"
            if aired > total{
                total = "?"
            }
            switch status {
            case "Онгоинг": return "\(aired) / \(total)"
            default: return total
            }
    }
    
    var kind: String {
        switch item?.kind {
        case L10n.sideMenuKind.tv.rawValue: return L10n.sideMenuKind.tv.localized
        case L10n.sideMenuKind.movie.rawValue : return L10n.sideMenuKind.movie.localized
        case L10n.sideMenuKind.ona.rawValue : return L10n.sideMenuKind.ona.localized
        case L10n.sideMenuKind.manga.rawValue: return L10n.sideMenuKind.manga.localized
        case "ranobe": return "Ранобэ"
        case L10n.sideMenuKind.novel.rawValue: return L10n.sideMenuKind.novel.localized
        case L10n.sideMenuKind.special.rawValue,L10n.sideMenuKind.tv_special.rawValue: return L10n.sideMenuKind.tv_special.localized
        case L10n.sideMenuKind.manhwa.rawValue: return L10n.sideMenuKind.manhwa.localized
        case L10n.sideMenuKind.manhua.rawValue: return L10n.sideMenuKind.manhua.localized
        case L10n.sideMenuKind.one_shot.rawValue: return L10n.sideMenuKind.one_shot.localized
            
        default: return item?.kind ?? "Неизвестно"
        }
    }
    
    var title: String { "\(contentList?.russian ?? item?.russian ?? "Нет названия") / \(contentList?.name ?? item?.name ?? "Нет названия")" }
    
    var numericScore: Double {
        return Double(contentList?.score ?? item?.score ?? "0") ?? 0.0
    }
    
    var ratingText: String {
        let s = numericScore
        if s >= 9 { return "Великолепно" }
        if s >= 8 { return "Отлично" }
        if s >= 7 { return "Хорошо" }
        return "Нормально"
    }
    
    var description: String {
        let rawDescription = item?.description
        return rawDescription?.htmlStripped() ?? ""
    }
    
    var status: String {
        switch item?.status {
        case "released": return "Вышло"
        case "ongoing": return "Онгоинг"
        case "paused" : return "Приостановлено"
        default: return contentList?.status ?? item?.status ?? "Неизвестно"
        }
    }
    
    var year: String {
        return String(contentList?.airedOn?.prefix(4) ?? item?.airedOn?.prefix(4) ?? "??")
    }
    var screenshotsPreview: [URL] {
        return screenshots.compactMap {
            URL(string: "https://shikimori.io" + ($0.preview ?? ""))
        }
    }
    var screenshotOriginal: [URL]{
        return screenshots.compactMap {
            URL(string: "https://shikimori.io" + ($0.original ?? ""))
        }
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
        
        await loadData()
        await loadUserRate()
        try? await Task.sleep(nanoseconds: 250_000_000)
        await loadCharacters()
        try? await Task.sleep(nanoseconds: 250_000_000)
        await loadRelated()
        try? await Task.sleep(nanoseconds: 250_000_000)
        await loadAuthors(type: type)
        try? await Task.sleep(nanoseconds: 250_000_000)
        if type == .animes {
            loadScreenshots()
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
    private func loadData() async{
        NetworkManager.shared.request(endpoint: .contentDetails(id: itemsId, contentType: type), method: .get)
            .replaceError(with: nil)
            .receive(on: DispatchQueue.main)
            .assign(to: &$item)
    }
    
    private func loadCharacters()async{
        NetworkManager.shared.request(endpoint: .itemMainCharacters(id: itemsId, contentType: type), method: .get)
            .map{(roles: [CharacterRoleModel]) in
                roles.filter{$0.roles.contains("Main")
                }
            }
            .replaceError(with: [])
            .receive(on: DispatchQueue.main)
            .assign(to: &$characters)
    }
    private func loadScreenshots() {
        NetworkManager.shared.request(endpoint: .screenshots(id: itemsId, сontentType: type), method: .get)
            .replaceError(with: [])
            .receive(on: DispatchQueue.main)
            .assign(to: &$screenshots)
    }

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

    private func mapToRowData(_ roles: [AuthorModel]) -> [ListSectionView.RowData] {
        roles.prefix(4).map {
            var title = $0.person?.russian
            if title == ""{
                title = $0.person?.name
            }
            return ListSectionView.RowData(
                title: title ?? "Unknown",
                subtitle: $0.rolesRussian.joined(separator: ", "),
                imageUrl: $0.person?.image?.original,
                id: $0.person?.id,
                type: .animes
            )
        }
    }

    private func loadAuthors(type: ContentType) async{
        NetworkManager.shared.request(endpoint: .authors(id: itemsId, contentType: type), method: .get)
            .map { [weak self] (roles: [AuthorModel]) -> [ListSectionView.RowData] in
                guard let self else { return [] }
                let target = self.targetRoles(for: type)
                let filtered = roles
                    .filter { !target.isDisjoint(with: Set($0.roles)) }
                    .sorted { $0.roles.contains("Original Creator") && !$1.roles.contains("Original Creator") }
                return self.mapToRowData(Array(filtered))
            }
            .replaceError(with: [])
            .receive(on: DispatchQueue.main)
            .assign(to: &$authorsRowData)
    }
    
    private func loadRelated() async{
        NetworkManager.shared.request(endpoint: .related(id: itemsId, contentType: type), method: .get)
            .map { (related: [RelatedAnime]) -> [ListSectionView.RowData] in
                return related.compactMap { item in
                    let content = item.anime ?? item.manga
                    guard let content = content else { return nil }
                    let type: ContentType = if item.anime != nil { .animes } else { .mangas }
                    return ListSectionView.RowData(
                        title: content.russian ?? content.name,
                        subtitle: item.relationRussian,
                        imageUrl: content.image?.original,
                        id: content.id,
                        type: type
                    )
                }
            }
            .replaceError(with: [])
            .receive(on: DispatchQueue.main)
            .assign(to: &$relatedRowData)
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
    func toggleFavorite() {

        FavouritesManager.shared.toggleFavorite(id: itemsId, type: setFavoriteType())
        isFavorite.toggle()
    }
}

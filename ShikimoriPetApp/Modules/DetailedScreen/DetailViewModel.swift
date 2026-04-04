import Combine
import Foundation

@MainActor
class DetailedViewModel{
    private let itemsId: Int
    let contentList: ContentListModel?
    
    var type: ContentType
    
    //MARK: Published Properties
    @Published var anime: ContentItemModel?
    @Published var characters: [CharacterRoleModel] = []
    @Published var screenshots: [Screenshots] = []
    @Published var authors: [AuthorModel] = []
    @Published var relatedAnimeList: [RelatedAnime] = []
    @Published var userRate: [AnimeUserRate] = []
    @Published var authorsRowData: [ListSectionView.RowData] = []
    @Published var relatedRowData: [ListSectionView.RowData] = []
    @Published var isLoading: Bool = false
    @Published var isFavorite: Bool = false
    
    private var cancellables = Set<AnyCancellable>()
    
    var userID: Int {
        UserDefaults.standard.integer(forKey: "current_user_id")
    }
    var score: String {
        return contentList?.score ?? anime?.score ?? "Нет информации"
    }
    var statusButtonText: String {
        guard !isLoading else { return "Загрузка..." }
        guard let rate = userRate.first else { return "Добавить в список" }
        let status = WatchingStatus(rawValue: rate.status ?? "")?.ruDescription ?? "Добавить в список"
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
    enum WatchingStatus: String {
        case planned, watching, rewatching, completed, dropped
        case onHold = "on_hold"
        case none = ""
        var ruDescription: String {
            switch self {
            case .planned:    return "Запланировано"
            case .watching:   return "Смотрю"
            case .rewatching: return "Пересматриваю"
            case .completed:  return "Завершено"
            case .onHold:     return "На паузе"
            case .dropped:    return "Брошено"
            case .none:       return "Добавить в список"
            }
        }
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
        return anime?.nextEpisodeAt
        
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
        let fullPath = "https://shikimori.io" + (contentList?.image.original ?? anime?.image?.original ?? "")
        return URL(string: fullPath)
    }
    var studiosImage: URL? {
        let fullpath = "https://shikimori.io" + (anime?.studios?.first?.image ?? "")
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
        
        
        if anime?.kind == "movie", let duration = anime?.duration {
            details.append(("Длительность: ", "\(duration) мин."))
        }
        
        details.append(("Статус", status))
        if nextEpisode != nil {
            details.append(("Следующий эпизод: ", nextEpisodeText ?? "Нет информации"))
        }
        return details
    }
    var chapters: String{
        guard let chapters = anime?.chapters else{ return "?"}
        return "\(chapters)"
    }
    var volumes: String{
        guard let volumes = anime?.volumes else{ return "?"}
        return "\(volumes)"
    }
    var episodes: String {
            let aired = anime?.episodesAired.map { "\($0)" } ?? "?"
            var total = anime?.episodes.map { "\($0)" } ?? "?"
            if aired > total{
                total = "?"
            }
            switch status {
            case "Онгоинг": return "\(aired) / \(total)"
            default: return total
            }
    }
    
    var kind: String {
        switch anime?.kind {
        case "tv": return "ТВ-сериал"
        case "movie": return "Фильм"
        case "ona" : return "ONA"
        case "manga": return "Манга"
        case "ranobe": return "Ранобэ"
        case "novel": return "Новелла"
        case "special","tv_special": return "Специальный выпуск"
            
        default: return anime?.kind ?? "Неизвестно"
        }
    }
    
    var title: String { "\(contentList?.russian ?? anime?.russian ?? "Нет названия") / \(contentList?.name ?? anime?.name ?? "Нет названия")" }
    
    var numericScore: Double {
        return Double(contentList?.score ?? anime?.score ?? "0") ?? 0.0
    }
    
    var ratingText: String {
        let s = numericScore
        if s >= 9 { return "Великолепно" }
        if s >= 8 { return "Отлично" }
        if s >= 7 { return "Хорошо" }
        return "Нормально"
    }
    
    var description: String {
//        guard let rawDescription = anime?.description else {
//            return "Загрузка описания..."
//        }
        let rawDescription = anime?.description
        return rawDescription?.htmlStripped() ?? ""
    }
    
    var status: String {
        switch anime?.status {
        case "released": return "Вышло"
        case "ongoing": return "Онгоинг"
        case "paused" : return "Приостановлено"
        default: return contentList?.status ?? anime?.status ?? "Неизвестно"
        }
    }
    
    var year: String {
        return String(contentList?.airedOn?.prefix(4) ?? anime?.airedOn?.prefix(4) ?? "??")
    }
    var screenshotURLs: [URL] {
        return screenshots.compactMap {
            URL(string: "https://shikimori.io" + ($0.original ?? ""))
        }
    }
    var maxEpisodesBug: Int {
        let aired = anime?.episodesAired.map { "\($0)" } ?? "?"
        let total = anime?.episodes.map { "\($0)" } ?? "?"
        if aired > total{
            return anime?.episodesAired ?? 0
        }
        return anime?.episodes ?? 0
    }
    func makeRateEditorVM() -> RateEditorViewModel {
        switch type{
        case .animes:
            RateEditorViewModel(
                watchingStatus: watchingStatus,
                maxEpisodes: maxEpisodesBug,
                currentScore: userRate.first?.score ?? 0,
                currentEpisodes: userRate.first?.episodes ?? 0,
                onSave: { [weak self] status, episodes, score in
                    self?.updateFullRate(status: status, score: score, episodes: episodes)
                }
                
            )
        case .mangas,.ranobe:
            RateEditorViewModel(
                watchingStatus: watchingStatus,
                maxEpisodes: maxEpisodesBug,
                currentScore: userRate.first?.score ?? 0,
                currentEpisodes: userRate.first?.episodes ?? 0,
                onSave: { [weak self] status, episodes, score in
                    self?.updateFullRate(status: status, score: score, episodes: episodes)
                }
                
            )
        }
        
        
    }

    //MARK: Network Methods
    func updateFullRate(status: WatchingStatus, score: Int, episodes: Int) {
        if userRate.first?.id == nil {
            createRate(status: status, score: score, episodes: episodes)
        } else if status == .none {
            deleteRate()
        } else {
            updateRate(status: status, score: score, episodes: episodes)
        }
    }
    
    private func createRate(status: WatchingStatus, score: Int, episodes: Int) {
        let body = makeCreateBody(status: status, score: score, episodes: episodes)
        NetworkManager.shared.request(endpoint: .createUserRate, method: .post, body: body)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { _ in }, receiveValue: { [weak self] (newRate: AnimeUserRate) in
                self?.userRate = [newRate]
            })
            .store(in: &cancellables)
    }
    
    private func deleteRate() {
        guard let rateID = userRate.first?.id else { return }
        NetworkManager.shared.requestVoid(endpoint: .deleteUserRate(linkID: rateID), method: .delete)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { _ in }, receiveValue: { [weak self] in
                self?.userRate = []
            })
            .store(in: &cancellables)
    }
    
    private func updateRate(status: WatchingStatus, score: Int, episodes: Int) {
        guard let rateID = userRate.first?.id else { return }
        let body = makeUpdateBody(status: status, score: score, episodes: episodes)
        NetworkManager.shared.request(endpoint: .userRateUpdate(linkID: rateID), method: .put, body: body)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { _ in }, receiveValue: { [weak self] (updated: AnimeUserRate) in
                self?.userRate = [updated]
            })
            .store(in: &cancellables)
    }
    
    private func makeCreateBody(status: WatchingStatus, score: Int, episodes: Int) -> [String: Any] {
        return [
            "user_rate": [
                "user_id": userID,
                "target_id": itemsId,
                "target_type": type,
                "status": status.rawValue,
                "score": score,
                "episodes": episodes
            ]
        ]
    }
    private func makeUpdateBody(status: WatchingStatus, score: Int, episodes: Int) -> [String: Any] {
        return [
            "user_rate": [
                "status": status.rawValue,
                "score": score,
                "episodes": episodes
            ]
        ]
    }
    func loadData(){
        NetworkManager.shared.request(endpoint: .contentDetails(id: itemsId, contentType: type), method: .get)
            .replaceError(with: nil)
            .receive(on: DispatchQueue.main)
            .assign(to: &$anime)
    }
    
    func loadCharacters(){
        NetworkManager.shared.request(endpoint: .itemMainCharacters(id: itemsId, contentType: type), method: .get)
            .map{(roles: [CharacterRoleModel]) in
                roles.filter{$0.roles.contains("Main")
                }
            }
            .replaceError(with: [])
            .receive(on: DispatchQueue.main)
            .assign(to: &$characters)
    }
    func loadScreenshots() {
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
                id: $0.person?.id
            )
        }
    }

    func loadAuthors(type: ContentType) {
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
    
    func loadRelated() {
        NetworkManager.shared.request(endpoint: .related(id: itemsId, contentType: type), method: .get)
            .map { (related: [RelatedAnime]) -> [ListSectionView.RowData] in
                return related.compactMap { item in
                    let content = item.anime ?? item.manga
                    guard let content = content else { return nil }
                    return ListSectionView.RowData(
                        title: content.russian ?? content.name ?? "",
                        subtitle: item.relationRussian,
                        imageUrl: content.image?.original,
                        id: content.id
                    )
                }
            }
            .replaceError(with: [])
            .receive(on: DispatchQueue.main)
            .assign(to: &$relatedRowData)
    }
    
    func loadUserRate() {
    
        NetworkManager.shared.request(endpoint: .checkUserRates(userID: userID, targetID: itemsId, contentType: type), method: .get)
            .replaceError(with: [])
            .receive(on: DispatchQueue.main)
            .sink { [weak self] (rates: [AnimeUserRate]) in
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

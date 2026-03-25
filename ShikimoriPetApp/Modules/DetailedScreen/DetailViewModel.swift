import Combine
import Foundation

@MainActor
class DetailedViewModel{
    private let animeID: Int
    let animeList: AnimeList?
    
    //MARK: Published Properties
    @Published var anime: Anime?
    @Published var characters: [CharacterRole] = []
    @Published var screenshots: [Screenshots] = []
    @Published var authors: [AuthorModel] = []
    @Published var relatedAnimeList: [RelatedAnime] = []
    @Published var userRate: [AnimeUserRate] = []
    @Published var authorsRowData: [ListSectionView.RowData] = []
    @Published var relatedRowData: [ListSectionView.RowData] = []
    @Published var isLoading: Bool = false

    private var cancellables = Set<AnyCancellable>()
    
    var userID: Int {
        UserDefaults.standard.integer(forKey: "current_user_id")
    }
    var score: String {
        return animeList?.score ?? anime?.score ?? "Нет информации"
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
    init(animeList: AnimeList) {
        self.animeList = animeList
        self.animeID = animeList.id
    }
    init(animeID: Int){
        self.animeID = animeID
        self.animeList = nil
    }
    
    var nextEpisode: String? {
            return anime?.nextEpisodeAt
        
    }
    var imageURL: URL? {
        let fullPath = "https://shikimori.io" + (animeList?.image.original ?? anime?.image?.original ?? "")
        return URL(string: fullPath)
    }
    var studiosImage: URL? {
        let fullpath = "https://shikimori.io" + (anime?.studios.first?.image ?? "")
        return URL(string: fullpath)
        
    }
    var infoDetails: [(key: String, value: String)] {
        var details: [(key: String, value: String)] = []
        
        details.append(("Тип", kind))
        
        details.append(("Эпизоды", episodes))
        
        if anime?.kind == "movie", let duration = anime?.duration {
            details.append(("Длительность: ", "\(duration) мин."))
        }
        
        details.append(("Статус", status))
        
        if nextEpisode != nil {
            details.append(("Следующий эпизод: ", nextEpisode ?? "Нет информации"))
        }
        return details
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
        default: return anime?.kind ?? "Неизвестно"
        }
    }
    
    var title: String { "\(animeList?.russian ?? anime?.russian ?? "Нет названия") / \(animeList?.name ?? anime?.name ?? "Нет названия")" }
    
    var numericScore: Double {
        return Double(animeList?.score ?? anime?.score ?? "0") ?? 0.0
    }
    
    var ratingText: String {
        let s = numericScore
        if s >= 9 { return "Великолепно" }
        if s >= 8 { return "Отлично" }
        if s >= 7 { return "Хорошо" }
        return "Нормально"
    }
    
    var description: String {
        guard let rawDescription = anime?.description else {
            return "Загрузка описания..."
        }
        return rawDescription.htmlStripped()
    }
    
    var status: String {
        switch anime?.status {
        case "released": return "Вышло"
        case "ongoing": return "Онгоинг"
        default: return animeList?.status ?? anime?.status ?? "Неизвестно"
        }
    }
    
    var year: String {
        return String(animeList?.airedOn?.prefix(4) ?? anime?.airedOn?.prefix(4) ?? "??")
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
        NetworkManager.shared.createUserRate(endpoint: .createUserRate, body: body)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { _ in }, receiveValue: { [weak self] (newRate: AnimeUserRate) in
                self?.userRate = [newRate]
            })
            .store(in: &cancellables)
    }

    private func deleteRate() {
        guard let rateID = userRate.first?.id else { return }
        NetworkManager.shared.delete(endpoint: .deleteUserRate(linkID: rateID))
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { _ in }, receiveValue: { [weak self] in
                self?.userRate = []
            })
            .store(in: &cancellables)
    }

    private func updateRate(status: WatchingStatus, score: Int, episodes: Int) {
        guard let rateID = userRate.first?.id else { return }
        let body = makeUpdateBody(status: status, score: score, episodes: episodes)
        NetworkManager.shared.update(endpoint: .userRateUpdate(linkID: rateID), body: body)
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
                "target_id": animeID,
                "target_type": "Anime",
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
        NetworkManager.shared.fetch(endpoint: .animeDetails(id: animeID))
            .replaceError(with: nil)
            .receive(on: DispatchQueue.main)
            .assign(to: &$anime)
    }
    
    func loadCharacters(){
        NetworkManager.shared.fetch(endpoint: .animeMainCharacters(id: animeID))
            .map{(roles: [CharacterRole]) in
                roles.filter{$0.roles.contains("Main")
                }
            }
            .replaceError(with: [])
            .receive(on: DispatchQueue.main)
            .assign(to: &$characters)
    }
        func loadScreenshots() {
            NetworkManager.shared.fetch(endpoint: .screenshots(id: animeID))
                .replaceError(with: [])
                .receive(on: DispatchQueue.main)
                .assign(to: &$screenshots)
        }
        func loadAuthors() {
            NetworkManager.shared.fetch(endpoint: .authors(id: animeID))
                .map { (roles: [AuthorModel]) -> [ListSectionView.RowData] in
                    let targetRoles: Set = ["Original Creator", "Chief Producer", "Chief Animation Director", "Director", "Writer"]
                    var filtered = roles.filter { !targetRoles.isDisjoint(with: Set($0.roles)) }
                    
                    filtered.sort { first, second in
                        let f = first.roles.contains("Original Creator")
                        let s = second.roles.contains("Original Creator")
                        return f && !s
                    }
                    
                    return filtered.prefix(4).map {
                        ListSectionView.RowData(
                            title: $0.person?.russian ?? "",
                            subtitle: $0.rolesRussian.joined(separator: ", "),
                            imageUrl: $0.person?.image?.original,
                            id: $0.person?.id
                        )
                    }
                }
                .replaceError(with: [])
                .receive(on: DispatchQueue.main)
                .assign(to: &$authorsRowData)
        }
        
        func loadRelated() {
            NetworkManager.shared.fetch(endpoint: .related(id: animeID))
                .map { (related: [RelatedAnime]) -> [ListSectionView.RowData] in
                    return related.prefix(4).compactMap { item in
                        let content = item.anime ?? item.manga
                        guard let content = content else { return nil }
                        return ListSectionView.RowData(
                            title: content.russian,
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
        isLoading = true
        NetworkManager.shared.fetch(endpoint: .checkUserRates(userID: userID, targetID: animeID))
            .replaceError(with: [])
            .receive(on: DispatchQueue.main)
            .sink { [weak self] (rates: [AnimeUserRate]) in
                self?.userRate = rates
                self?.isLoading = false
            }
            .store(in: &cancellables)
    }

}

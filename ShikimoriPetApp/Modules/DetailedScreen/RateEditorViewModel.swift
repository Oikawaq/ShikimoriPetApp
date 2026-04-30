
import Foundation
import Combine
final class RateEditorViewModel {
    var watchingStatus: WatchingStatus
    let maxEpisodes: Int
    var currentScore: Int
    @Published var currentEpisodes: Int
    @Published var currentStatus: WatchingStatus
    var onSave: ((WatchingStatus, Int, Int) -> Void)?
    
    init(
        watchingStatus: WatchingStatus,
        maxEpisodes: Int,
        currentScore: Int,
        currentEpisodes: Int,
        onSave: ((WatchingStatus, Int, Int) -> Void)?
    ) {
        
        self.watchingStatus = watchingStatus
        self.maxEpisodes = maxEpisodes
        self.currentScore = currentScore
        self.currentEpisodes = currentEpisodes
        self.onSave = onSave
        self.currentStatus = watchingStatus
    }
    
    func save() {
        onSave?(currentStatus, currentScore, currentEpisodes)
        print(currentStatus)
    }
}

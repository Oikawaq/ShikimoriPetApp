import Foundation

enum DateKit {
    private static let isoFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZZZ"
        formatter.locale = Locale(identifier: "en_US_POSIX")
        return formatter
    }()
    
    private static let outputFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ru_RU")
        formatter.dateFormat = "d MMMM 'в' HH:mm"
        return formatter
    }()

    static func formatAbsoluteEpisodeTime(from isoString: String) -> String {
        guard let date = isoFormatter.date(from: isoString) else {
            return "Дата неизвестна"
        }
        return outputFormatter.string(from: date)
    }
}

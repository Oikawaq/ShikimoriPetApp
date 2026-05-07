
import Foundation


enum L10n {
    enum Auth{
        static let loginButton = "Войти"
        static let label = "Авторизируйтесь с помощью Shikimori"
        static let redeemCodeButton = "Ввести код"
        static let placeholder = "Введите код из \nбраузера"
        static let authorization = "Авторизация"
    }
    enum Logout{
        static let logoutAlert = "Вы действительно хотите выйти из аккаунта?"
        static let logout = "Выход"
    }
    enum Settings{
        static let title = "Настройки"
        static let changeUserName = "Изменить отображаемое имя"
        static let changeImage = "Изменить аватар"
    }
    enum MainPage{
        static let title = "Shikimori"
        static let categoryAnime = "Аниме"
        static let categoryManga = "Манга"
        static let description = "Здесь буду собраны аниме, отсортированные по рейтингу"
    }
    enum ContentItem{
        static let anime = "Аниме"
        static let manga = "Манга"
    }
    enum Placeholder{
        static let search = "Поиск"
    }
    enum categories{
        static let anime = "Аниме"
        static let manga = "Манга"
        static let ranobe = "Ранобэ"
        static let description = "Описание"
        static let information = "Информация"
        static let related = "Связанное"
        static let authors = "Авторы"
        static let mainCharacters = "Главные герои"
        static let screenshots = "Кадры"
        static let seyu = "Сейю"
        static let favorite = "Избранное"
        static let friends = "Друзья"
    }
    enum userRateList{
        static let anime = "Тут будет отображен ваш список аниме"
    }
    enum sideMenu{
        static let status = "Статус"
        static let filters = "Фильтры"
        static let sorted = "Сортировка"
        static let type = "Тип"
    }
    enum sideMenuStatus: String, CaseIterable{
       case anons, ongoing, released,paused, discontinued
        
        var localized: String {
            switch self {
            case .anons: return "Анонсировано"
            case .ongoing: return "Сейчас выходит"
            case .released: return "Вышедшее"
            case .paused: return "Приостановлено"
            case .discontinued: return "Прекращено"
            }
        }
    }
    enum sideMenuKind: String, CaseIterable{
        case manga, manhwa, manhua, light_novel, novel, one_shot, doujin,tv,movie,ova,ona,special,tv_special,music,ranobe
        
        var localized: String {
            switch self {
           
            case .movie: return "Фильм"
            case .tv: return "ТВ-Сериал"
            case .ova: return "OVA"
            case .ona: return "ONA"
            case .special: return "Спевыпуск"
            case .tv_special: return "ТВ Спецвыпуск"
            case .music: return "Музыка"
            case .manga: return "Манга"
            case .manhwa: return "Манхва"
            case .manhua: return "Маньхуа"
            case .light_novel: return "Ранобэ"
            case .novel: return "Новелла"
            case .one_shot: return "Ваншот"
            case .doujin: return "Додзинси"
            case .ranobe: return "Ранобэ"
            }
        }
    }
    enum sideMenuOrder: String, CaseIterable{
       case ranked, popularity,name,aired_on
        
        var localized: String {
            switch self {
            case .ranked: return "По рейтингу"
            case .popularity: return "По популярности"
            case .name: return "По алфавиту"
            case .aired_on: return "По дате выхода"
            }
        }
    }
}

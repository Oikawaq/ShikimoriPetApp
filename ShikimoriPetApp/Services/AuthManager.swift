import UIKit
import Combine
class AuthManager {
    
    static let shared = AuthManager()
    
    private init(){}
    
    enum AuthState{
        case loading
        case authorized
        case notAuthorized
    }
    var authState: AuthState = AuthState.loading
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Обновление токена
    func refreshToken(completion: @escaping(Bool)->Void ){
        guard let refreshToken = KeyChainHelper.getToken(key: "refresh_token") else {
            completion(false)
            return
        }
        guard let url = URL(string: Constants.baseURL + Constants.token) else {
            completion(false)
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("ShikimoriPetApp", forHTTPHeaderField: "User-Agent")
        
        let boundary = "Boundary-\(UUID().uuidString)"
        request.setValue("multipart/form-data; boundary=\(boundary)",
                         forHTTPHeaderField: "Content-Type")
        
        let parameters: [String: String] = [
            "grant_type": "refresh_token",
            "client_id": "hN_xC4we2VXYoVjppayl_RQFw3TcD8RFdOKgbm5Qj-0",
            "client_secret": "kCxi_iYzPQw1FGGROfNIR2tg0Tj21inJO7EG0qQ3v3U",
            "refresh_token": refreshToken
        ]
        
        let bodyData = createMultipartBody(parameters: parameters, boundary: boundary)
        request.httpBody = bodyData
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(false)
                return
            }
            
            guard let data = data else {
                completion(false)
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let tokenResponse = try decoder.decode(TokenResponse.self, from: data)
                
                KeyChainHelper.save(token: tokenResponse.accessToken, forKey: "access_token")
                KeyChainHelper.save(token: tokenResponse.refreshToken, forKey: "refresh_token")
          
                let expirationDate = Date().addingTimeInterval(TimeInterval(tokenResponse.expiresIn))
                UserDefaults.standard.set(expirationDate, forKey: "token_expiration_date")
                
                DispatchQueue.main.async {
                    self.authState = .authorized
                    completion(true)
                }
            } catch {
                DispatchQueue.main.async {
                    completion(false)
                }
            }
        }.resume()
    }
    
    // MARK: - Проверка актуальности токена
    func isTokenValid() -> Bool {
        guard let expirationDate = UserDefaults.standard.object(forKey: "token_expiration_date") as? Date else {
            return false
        }
        return Date().addingTimeInterval(300) < expirationDate
    }
    
    // MARK: - Получение валидного токена
    func getValidAccessToken(completion: @escaping (Result<String, Error>) -> Void) {
        if isTokenValid() {
            if let accessToken = KeyChainHelper.getToken(key: "access_token") {
                completion(.success(accessToken))
            } else {
                completion(.failure(NetworkError.badData))
            }
        } else {
            refreshToken { success in
                if success {
                    if let accessToken = KeyChainHelper.getToken(key: "access_token") {
                        completion(.success(accessToken))
                    } else {
                        completion(.failure(NetworkError.badData))
                    }
                } else {
                    DispatchQueue.main.async {
                        self.authState = .notAuthorized
                    }
                    completion(.failure(NetworkError.unauthorized))
                }
            }
        }
    }
    
    
    private func getURL()->URL?{
        
        let url = Constants.baseURL+Constants.redirectURL
        return URL(string: url)
    }
    //MARK: redirect
    func redirectAuth(completion: @escaping (Result<Void,Error>) -> Void) {
        
        guard let url = getURL() else{
            completion(.failure(NetworkError.badResponse))
            return
        }
        
        UIApplication.shared.open(url){ success in
            
            if success {
                completion(.success(()))
            } else {
                completion(.failure(NetworkError.failedToOpenSafari))
            }
        }
    }
    
    func exchangeCodeForToken(code: String, completion: @escaping (Result<TokenResponse, Error>) -> Void){
        guard let url = URL(string: Constants.baseURL+Constants.token) else {
            completion(.failure(NetworkError.badUrl))
            return
        }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("ShikimoriPetApp", forHTTPHeaderField: "User-Agent")
        
        let boundary = "Boundary-\(UUID().uuidString)"
        request.setValue("multipart/form-data; boundary=\(boundary)",
                         forHTTPHeaderField: "Content-Type")
        
        let parameters: [String: String] = [
            "grant_type": "authorization_code",
            "client_id": "hN_xC4we2VXYoVjppayl_RQFw3TcD8RFdOKgbm5Qj-0",
            "client_secret": "kCxi_iYzPQw1FGGROfNIR2tg0Tj21inJO7EG0qQ3v3U",
            "code": code,
            "redirect_uri": "urn:ietf:wg:oauth:2.0:oob"
        ]
        
        let bodyData = createMultipartBody(parameters: parameters, boundary: boundary)
        request.httpBody = bodyData
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            guard let data = data else {
                completion(.failure(NetworkError.badData))
                return
            }
            do{
                let decoder = JSONDecoder()
                let tokenResponse = try decoder.decode(TokenResponse.self, from: data)
                
                KeyChainHelper.save(token: tokenResponse.accessToken, forKey: "access_token")
                KeyChainHelper.save(token: tokenResponse.refreshToken, forKey: "refresh_token")
                self.whoAmI()

                let expirationDate = Date().addingTimeInterval(TimeInterval(tokenResponse.expiresIn))
                UserDefaults.standard.set(expirationDate, forKey: "token_expiration_date")
               
                completion(.success(tokenResponse))
            }catch{
                completion(.failure(NetworkError.badResponse))
            }
        }.resume()
    }
    
    func logout(){
        KeyChainHelper.delete(key: "access_token")
        KeyChainHelper.delete(key: "refresh_token")
        UserDefaults.standard.removeObject(forKey: "token_expiration_date")
        AuthManager.shared.authState = .notAuthorized
    }
    
    func createMultipartBody(parameters: [String: String], boundary: String) -> Data {
        var body = Data()
        
        for (key, value) in parameters {
            body.append("--\(boundary)\r\n".data(using: .utf8)!)
            body.append("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n".data(using: .utf8)!)
            body.append("\(value)\r\n".data(using: .utf8)!)
        }
        
        body.append("--\(boundary)--\r\n".data(using: .utf8)!)
        return body
    }

    
    private func whoAmI() {
        NetworkManager.shared.request(endpoint: .whoami, method: .get)
                .receive(on: DispatchQueue.main)
                .sink(receiveCompletion: { completion in
                    switch completion {
                    case .finished:
                        print("Успешно получили профиль пользователя")
                    case .failure(let error):
                        print("Ошибка получения профиля: \(error)")
                    }
                }, receiveValue: { (user: UserModel) in
             
                    print("Мой ID: \(user.id)")

                    UserDefaults.standard.set(user.id, forKey: "current_user_id")
                    UserDefaults.standard.set(user.nickname, forKey: "current_user_nickname")
                })
                .store(in: &cancellables)
        }

}

extension Dictionary where Key == String, Value == String {
    var urlEncoded: Data {
        var body = ""
        for (key, value) in self {
            body += "--boundary\nContent-Disposition: form-data; name=\"\(key)\"\n\n\(value)\n"
        }
        body += "--boundary--"
        return body.data(using: .utf8)!
    }
}

import Foundation
import Combine

final class NetworkManager {
    static let shared = NetworkManager()
    private let queue = OperationQueue()
    private let decoder: JSONDecoder = {
        let d = JSONDecoder()
        d.keyDecodingStrategy = .convertFromSnakeCase
        return d
    }()
    
    private init() {
        queue.maxConcurrentOperationCount = 1
    }
    enum Method: String {
        case get, post, put, delete
    }
    func request<T: Decodable>(
        endpoint: ShikimoriEndpoint,
        method: Method,
        body: [String: Any]? = nil
    ) -> AnyPublisher<T, NetworkError> {
        return Future<T, NetworkError> { [weak self] promise in
            self?.queue.addOperation {
                guard let self else { return }
                guard var request = self.buildRequest(for: endpoint, method: method.rawValue) else {
                    promise(.failure(.badUrl))
                    return
                }
                if let body = body {
                    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
                    request.httpBody = try? JSONSerialization.data(withJSONObject: body)
                }
                URLSession.shared.dataTask(with: request) { data, _, error in
                    if error != nil { promise(.failure(.badData)); return }
                    guard let data else { promise(.failure(.badData)); return }
                    do {
                        promise(.success(try self.decoder.decode(T.self, from: data)))
                    } catch {
                        promise(.failure(.badResponse))
                    }
                }.resume()
            }
        }.eraseToAnyPublisher()
    }

    func requestVoid(
         endpoint: ShikimoriEndpoint,
         method: Method
     ) -> AnyPublisher<Void, NetworkError> {
         return Future<Void, NetworkError> { [weak self] promise in
             self?.queue.addOperation {
                 guard let self else { return }
                 guard let request = self.buildRequest(for: endpoint, method: method.rawValue) else {
                     promise(.failure(.badUrl))
                     return
                 }
                 URLSession.shared.dataTask(with: request) { _, _, error in
                     error != nil ? promise(.failure(.badData)) : promise(.success(()))
                 }.resume()
             }
         }.eraseToAnyPublisher()
     }
    
    private func buildRequest(for endpoint: ShikimoriEndpoint, method: String) -> URLRequest? {
        guard let url = endpoint.url else { return nil }
        var request = URLRequest(url: url)
        request.httpMethod = method
        request.setValue("ShikimoriPetApp", forHTTPHeaderField: "User-Agent")
        if let token = KeyChainHelper.getToken(key: "access_token") {
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
        return request
    }
}

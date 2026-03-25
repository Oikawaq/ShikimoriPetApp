import Foundation
import Combine

final class NetworkManager {
    static let shared = NetworkManager()
    private let queue = OperationQueue()
    
    private init() {
        queue.maxConcurrentOperationCount = 1
    }
    
    func fetch<T: Decodable>(endpoint: ShikimoriEndpoint) -> AnyPublisher<T, NetworkError> {
        
        
        return Future<T, NetworkError>{[weak self] promise in
            
            self?.queue.addOperation{
                guard let self = self else { return }

                guard let request = self.buildRequest(for: endpoint, method: "GET") else {
                    promise(.failure(.badUrl))
                    return
                }
                
                let task = URLSession.shared.dataTask(with: request) { data, response, error in
                    if error != nil {
                        promise(.failure(.badData))
                        return
                    }
                    
                    guard let data = data else {
                        promise(.failure(.badData))
                        return
                    }
                    
                    do {
                        let decoder = JSONDecoder()
                        decoder.keyDecodingStrategy = .convertFromSnakeCase
                        let decodedObject = try decoder.decode(T.self, from: data)
                        promise(.success(decodedObject))
                    } catch  {
                        promise(.failure(.badResponse))
                    }
                }
                task.resume()
//                Thread.sleep(forTimeInterval: 0.2)
            }
        }.eraseToAnyPublisher()
    }

    func update<T: Decodable>(endpoint: ShikimoriEndpoint, body: [String: Any]) -> AnyPublisher<T, NetworkError> {
        return Future<T, NetworkError> { [weak self] promise in
      
                guard let self = self else { return }

                guard var request = self.buildRequest(for: endpoint, method: "PUT") else {
                    promise(.failure(.badUrl))
                    return
                }
                request.setValue("application/json", forHTTPHeaderField: "Content-Type")

                request.httpBody = try? JSONSerialization.data(withJSONObject: body)
                
                let task = URLSession.shared.dataTask(with: request) { data, _, error in
                    guard let data = data, error == nil else {
                        promise(.failure(.badData))
                        return
                    }
                    
                    do {
                        let decoder = JSONDecoder()
                        decoder.keyDecodingStrategy = .convertFromSnakeCase
                        let decodedObject = try decoder.decode(T.self, from: data)
                        promise(.success(decodedObject))
                    } catch {
                        promise(.failure(.badResponse))
                    }
                }
                task.resume()
        }
        .eraseToAnyPublisher()
    }
    func createUserRate<T: Decodable>(endpoint: ShikimoriEndpoint, body: [String: Any]) -> AnyPublisher<T, NetworkError> {
        return Future<T, NetworkError> { [weak self] promise in
            
                guard let self = self else { return }

                guard var request = self.buildRequest(for: endpoint, method: "POST") else {
                    promise(.failure(.badUrl))
                    return
                }
                request.setValue("application/json", forHTTPHeaderField: "Content-Type")

                request.httpBody = try? JSONSerialization.data(withJSONObject: body)
                let task = URLSession.shared.dataTask(with: request) { data, _, error in
                    guard let data = data, error == nil else {
                        promise(.failure(.badData))
                        return
                    }
                    
                    do {
                        let decoder = JSONDecoder()
                        decoder.keyDecodingStrategy = .convertFromSnakeCase
                        let decodedObject = try decoder.decode(T.self, from: data)
                        promise(.success(decodedObject))
                    } catch {
                        promise(.failure(.badResponse))
                    }
                }
                task.resume()
            
        }
        .eraseToAnyPublisher()
    }
    func delete(endpoint: ShikimoriEndpoint) -> AnyPublisher<Void, NetworkError> {
        
        return Future<Void, NetworkError>{[weak self] promise in
                guard let self = self else { return }

            guard let request = self.buildRequest(for: endpoint, method: "DELETE") else {
                    promise(.failure(.badUrl))
                    return
                }

                let task = URLSession.shared.dataTask(with: request) { _, response, error in
                    if let httpResponse = response as? HTTPURLResponse {
                          print("DELETE status code: \(httpResponse.statusCode)")
                      }
                            if let error = error {
                            print("DELETE error: \(error)")
                            promise(.failure(.badData))
                            return
                        }
                            promise(.success(()))
                        }
                task.resume()
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

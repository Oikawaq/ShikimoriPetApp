

import Foundation



enum AuthScreenState {
    case initial
    case waitingForCode
    case loading
    case success
    case error(String)
}


final class AuthViewModel{

    var onStateChanged: ((AuthScreenState)->Void)?
    
    private let authManager = AuthManager.shared
    
    func startAuthorization() {
        onStateChanged?(.loading)
            
            authManager.redirectAuth { [weak self] result in
                DispatchQueue.main.async {
                    switch result {
                    case .success:
                        self?.onStateChanged?(.waitingForCode)
                    case .failure(let error):
                        self?.onStateChanged?(.error(error.localizedDescription))
                    }
                }
            }
        }
    
    func sumbitCode(code: String){
        
        guard !code.isEmpty else { return }

        onStateChanged?(.loading)
        
        authManager.exchangeCodeForToken(code: code){[weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let tokens):
                    KeyChainHelper.save(token: tokens.accessToken, forKey: "access_token")
                    self?.onStateChanged?(.success)
                    
                case .failure(let error):
                    self?.onStateChanged?(.error("Неверный код или сбой сети: \(error.localizedDescription)"))
                    self?.onStateChanged?(.waitingForCode)
                }
            }
        }
    }
}


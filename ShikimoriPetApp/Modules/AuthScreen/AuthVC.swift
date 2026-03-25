import UIKit

class AuthVC: UIViewController {
    
    private let viewModel = AuthViewModel()
    
    private var authView: AuthView? {
        return view as? AuthView
    }
    
    override func loadView() {
        self.view = AuthView()
        
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        updateUI(state: .initial)
        setupBindings()
        setupTargets()
    }
    @objc private func authButtonTapped() {
        viewModel.startAuthorization()
        
    }
    @objc private func redeemButtonTapped() {
        guard let code = authView?.codeTextField.text else { return }
        viewModel.sumbitCode(code: code)
    }
    
    private func setupTargets() {
        authView?.authButton.addTarget(
            self,
            action: #selector(authButtonTapped),
            for: .touchUpInside
        )
        authView?.redeemCodeButton.addTarget(
            self,
            action: #selector(redeemButtonTapped),
            for: .touchUpInside
        )
    }
    
    private func setupBindings() {
        viewModel.onStateChanged = { [weak self] state in
            self?.updateUI(state: state)
        }
    }
    
    private func updateUI(state: AuthScreenState) {
        view.endEditing(true)
        
        switch state {
            
        case .initial:
            authView?.authButton.isHidden = false
            authView?.codeTextField.isHidden = true
            authView?.redeemCodeButton.isHidden = true
            authView?.label.text = "Авторизация"
            
        case .waitingForCode:
            authView?.authButton.isHidden = true
            authView?.codeTextField.isHidden = false
            authView?.redeemCodeButton.isHidden = false
            authView?.label.text = "Введите код из \nбраузера"
            
        case .loading:
            authView?.activityIndicator.startAnimating()
            authView?.redeemCodeButton.isEnabled = true
            
        case .success:
            switchToMainScreen()
            
        case .error(let message):
            showError(message)
        }
    }
    
    private func switchToMainScreen() {
        DispatchQueue.main.async {
            guard
                let windowScene = UIApplication.shared.connectedScenes.first
                    as? UIWindowScene,
                let sceneDelegate = windowScene.delegate as? SceneDelegate
            else { return }
            sceneDelegate.checkAuthenticationStatus()
        }
    }
    
    private func showError(_ message: String) {
        
        let alert = UIAlertController(
            title: "Ошибка",
            message: message,
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}

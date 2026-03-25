

import UIKit
import SnapKit

class SettingsVC: UIViewController {

    let viewModel = SettingsViewModel()
    private var settingsView: SettingsView? {
           view as? SettingsView
       }
    
    override func loadView() {
           view = SettingsView()
       }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupActions()
        setupBindings()
    }
    deinit { print("SettingsVC dead") }
    private func setupBindings() {
        viewModel.onLogoutSuccess = { [weak self] in
            guard let self else { return }
            self.switchToAuthScreen()
        }
    }
    
    private func switchToAuthScreen(){
        if let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate {
            sceneDelegate.logout()
        }
    }
    
    private func setupActions(){
        settingsView?.logoutButton.addTarget(self, action: #selector(showLogoutNotification), for: .touchUpInside)
    }
    
    
    @objc func showLogoutNotification(){
        let alert = UIAlertController(
            title: L10n.Logout.logout,
            message: L10n.Logout.logoutAlert,
            preferredStyle: .alert
        )
        
        alert.addAction(UIAlertAction(title: "Отмена", style: .cancel))
        
        alert.addAction(UIAlertAction(title: L10n.Logout.logout, style: .destructive){ [weak self] _ in
            self?.viewModel.onLogoutSuccess?()
        })
                        
        present(alert, animated: true)
        
    }

    private func isLogoutAllertAccepted() {
        viewModel.logout()
    }

}

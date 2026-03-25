//
//  SettingsViewModel.swift
//  ShikimoriPetApp
//
//  Created by Иван Илькив on 2/16/26.
//


import Foundation

final class SettingsViewModel {
    var onLogoutSuccess: (() -> Void)?
    
    private let authManager = AuthManager.shared
    
    func logout() {
        authManager.logout()
        onLogoutSuccess?()
    }
    deinit {
        print("SettingsViewModel уничтожен")
    }
}

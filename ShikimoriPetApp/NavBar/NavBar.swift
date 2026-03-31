//
//  NavBar.swift
//  ShikimoriPetApp
//
//  Created by Иван Илькив on 2/5/26.
//

import UIKit

class TabBarController: UITabBarController {
    let userId = UserDefaults.standard.integer(forKey: "current_user_id")
    override func viewDidLoad() {
        super.viewDidLoad()
        setupVCs()
        setupAppearance()
    }
    
    private func setupVCs() {
        let mainVC = MainViewController()
        let mainNav = UINavigationController(rootViewController: mainVC)
        setupNavItems(vc: mainVC, title: TabBarConstants.mainPageVC, image: "house")
        let vm = ProfileViewModel(userId: userId)
        let profile = ProfileViewController(viewModel: vm)
        let profileNav = UINavigationController(rootViewController: profile)
        setupNavItems(vc: profile, title: TabBarConstants.profileVC, image: "person.circle")
        
        let settings = SettingsVC()
        let settingsNav = UINavigationController(rootViewController: settings)
        setupNavItems(vc: settings, title: TabBarConstants.settingsVC, image: "gear")
        
        viewControllers = [mainNav,profileNav, settingsNav]
        
    }
    
    private func setupNavItems(vc: UIViewController,title: String,image: String) {
        
        vc.tabBarItem = UITabBarItem(
            title: title,
            image: UIImage(systemName: image),
            selectedImage: UIImage(systemName:"\(image).fill")
        )
        
    }
    private func setupAppearance() {
        
           selectedIndex = 0

           if #available(iOS 13.0, *) {
               let appearance = UITabBarAppearance()
               appearance.configureWithOpaqueBackground()
               appearance.backgroundColor = .basalt
               appearance.stackedLayoutAppearance.selected.iconColor = .chalkWhite
               appearance.stackedLayoutAppearance.selected.titleTextAttributes = [.foregroundColor: UIColor.chalkWhite]
               appearance.stackedLayoutAppearance.normal.iconColor = .lightGray
               appearance.stackedLayoutAppearance.normal.titleTextAttributes = [.foregroundColor: UIColor.lightGray]
               
               tabBar.standardAppearance = appearance
               if #available(iOS 15.0, *) {
                   tabBar.scrollEdgeAppearance = appearance
               }
           } else {
               tabBar.barTintColor = .basalt
               tabBar.tintColor = .chalkWhite
               tabBar.unselectedItemTintColor = .lightGray
           }
       }
}

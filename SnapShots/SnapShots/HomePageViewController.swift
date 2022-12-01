//
//  HomePageViewController.swift
//  SnapShots
//
//  Created by mahendran-14703 on 08/11/22.
//

import UIKit

class HomePageViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        navigationItem.hidesBackButton = true
        view.backgroundColor = .systemBackground
    
        tabBar.backgroundColor = .systemBackground
        tabBar.tintColor = UIColor(named: "appTheme")
        tabBar.isTranslucent = false
        setupViewControllers()
    }
    
    private func setupViewControllers() {
        
        let userID = UserDefaults.standard.integer(forKey: Constants.loggedUserFormat)
        let profileVC = ProfileVC(userID: userID)
        let profileControls = ProfileControls()
        
        profileVC.profileControls = profileControls
        
        viewControllers = [
            createNavigationController(rootViewController: FeedsViewController(), title: "Feeds", icon: UIImage(systemName: "newspaper")!),
            createNavigationController(rootViewController: SearchPeopleViewController(), title: "Search", icon: UIImage(systemName: "magnifyingglass")!),
            createNavigationController(rootViewController: NotificationGridVC(), title: "Friends", icon: UIImage(systemName: "globe")!),
            
            createNavigationController(rootViewController: profileVC, title: "Profile", icon: UIImage(systemName: "person")!),
        
        ]
    }
    
    fileprivate func createNavigationController(rootViewController: UIViewController,title: String,
                                                icon: UIImage) -> UIViewController {
        
        let navigationController = UINavigationController(rootViewController: rootViewController)
        navigationController.tabBarItem.title = title
        navigationController.tabBarItem.image = icon
        return navigationController
        
    }
}

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
        
        let profileVC = ProfileVC(userID: userID,isVisiting: false)
        let profileControls = ProfileControls()        
        profileVC.setController(profileControls)
        
        let notificationVC = NotificationGridVC()
        let notificationControls = NotificationControls()
        notificationVC.setNotificationControls(notificationControls)
        
        let searchVC = SearchPeopleVC()
        let searchControls = SearchControls()
        searchVC.setController(searchControls)
        
        let feedsVC = FeedsVC()
        let feedsControls = FeedsControls()
        feedsVC.setController(feedsControls)
        
        viewControllers = [
            createNavigationController(rootViewController: feedsVC, title: "Feeds", icon: UIImage(systemName: "newspaper")!),
            createNavigationController(rootViewController: searchVC, title: "Search", icon: UIImage(systemName: "magnifyingglass")!),
            
            createNavigationController(rootViewController: notificationVC, title: "Friends", icon: UIImage(systemName: "globe")!),
            createNavigationController(rootViewController: profileVC, title: "Profile", icon: UIImage(systemName: "person")!),
        
        ]
        
        if let tabItems = tabBar.items {
            // In this case we want to modify the badge number of the third tab:
            let tabItem = tabItems[2]
            var friendRequests = notificationControls.getAllFriendRequests()

            if friendRequests.isEmpty {
                tabBar.changeBadgeValue(value: 0)
            } else {
                tabBar.changeBadgeValue(value: friendRequests.count)
            }
        }
    }
    
    fileprivate func createNavigationController(rootViewController: UIViewController,title: String,
                                                icon: UIImage) -> UIViewController {
         
        let navigationController = UINavigationController(rootViewController: rootViewController)
        navigationController.tabBarItem.title = title
        navigationController.tabBarItem.image = icon
        return navigationController
        
    }
}

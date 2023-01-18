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
        
        let profileControls = ProfileControls()
        let profileVC = ProfileVC(profileControls: profileControls,userID: userID,isVisiting: false)
        
        let notificationVC = NotificationGridVC()
        let notificationControls = NotificationControls()
        notificationVC.setNotificationControls(notificationControls)
        
        let searchVC = SearchPeopleVC()
        let searchControls = SearchControls()
        searchVC.setController(searchControls)
        
        let feedsVC = FeedsVC()
        let feedsControls = FeedsControls()
        feedsVC.setController(feedsControls)
        
        let listCollectionVC = ListCollectionVC(listCollectionControls: ListCollectionControls(),listCollectionEntity: .archive)
        let listCollectionVC1 = ListCollectionVC(listCollectionControls: ListCollectionControls(),listCollectionEntity: .savedCollection)
        
        viewControllers = [
            createNavigationController(rootViewController: feedsVC, title: "Feeds", icon: UIImage(systemName: "newspaper")!,selectedIcon: UIImage(systemName: "newspaper.fill")!),
            createNavigationController(rootViewController: searchVC, title: "Search", icon: UIImage(systemName: "magnifyingglass")!,selectedIcon: UIImage(systemName: "magnifyingglass")!),
            
            createNavigationController(rootViewController: notificationVC, title: "Friends", icon: UIImage(systemName: "globe")!,selectedIcon: UIImage(systemName: "globe")!),
            createNavigationController(rootViewController: profileVC, title: "Profile", icon: UIImage(systemName: "person")!,selectedIcon: UIImage(systemName: "person.fill")!),
            createNavigationController(rootViewController: listCollectionVC, title: "Archives", icon: UIImage(systemName: "archivebox.fill")!, selectedIcon: UIImage(systemName: "archivebox.fill")!),
            
            createNavigationController(rootViewController: listCollectionVC1, title: "Saved Collections", icon:  UIImage(systemName: "bookmark")!, selectedIcon:  UIImage(systemName: "bookmark")!)
        ]
        

        let friendRequests = notificationControls.getAllFriendRequests()
        if friendRequests.isEmpty {
            tabBar.changeBadgeValue(value: 0)
        } else {
            tabBar.changeBadgeValue(value: friendRequests.count)
        }
    }
    
    fileprivate func createNavigationController(rootViewController: UIViewController,title: String,
                                                icon: UIImage,selectedIcon: UIImage) -> UIViewController {
         
        let navigationController = UINavigationController(rootViewController: rootViewController)
        navigationController.tabBarItem = UITabBarItem(title: title, image: icon, selectedImage: selectedIcon)
        return navigationController
        
    }
}

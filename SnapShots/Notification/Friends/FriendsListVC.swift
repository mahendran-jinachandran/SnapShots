//
//  NotificationViewController.swift
//  SnapShots
//
//  Created by mahendran-14703 on 16/11/22.
//

import UIKit

class FriendsListVC: UIViewController,UITableViewDataSource,UITableViewDelegate {
    
    private var friends: [(userDP: UIImage,username: String)] = []
    var notificationTitle: UILabel = {
        var notificationTitle = UILabel()
        notificationTitle.attributedText = NSAttributedString(string: "Notification",attributes: [
            NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 20)
        ])
        return notificationTitle
    }()

    private let friendsList: UITableView = {
       let friendRequests = UITableView()
       friendRequests.translatesAutoresizingMaskIntoConstraints = false
       friendRequests.register(FriendsListCustomTVCell.self, forCellReuseIdentifier: FriendsListCustomTVCell.identifier)
        friendRequests.separatorStyle = .none
       return friendRequests
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        friends = FriendsControls().getAllFriends()
        
        navigationItem.hidesBackButton = true
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "arrow.left"),
            style: .plain,
            target: self,
            action: #selector(goBack))
        
        
        navigationItem.leftBarButtonItem?.tintColor = UIColor(named: "appTheme")
        title = "Friends"
        
        friendsList.bounces = false
        friendsList.delegate = self
        friendsList.dataSource = self
        view.addSubview(friendsList)
        setScreenConstraints()
    }
    
    @objc func goBack() {
        navigationController?.popViewController(animated: false)
    }
    
    
    func setScreenConstraints() {
        NSLayoutConstraint.activate([
            friendsList.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            friendsList.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            friendsList.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            friendsList.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return friends.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        60
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: FriendsListCustomTVCell.identifier, for: indexPath) as! FriendsListCustomTVCell 
        cell.configure(
            userDP: friends[indexPath.row].userDP,
            username: friends[indexPath.row].username)
        return cell
    }
}

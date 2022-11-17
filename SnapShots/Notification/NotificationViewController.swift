//
//  NotificationViewController.swift
//  SnapShots
//
//  Created by mahendran-14703 on 16/11/22.
//

import UIKit

class NotificationViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {
    
    var notificationTitle: UILabel = {
        var notificationTitle = UILabel()
        notificationTitle.attributedText = NSAttributedString(string: "Notification",attributes: [
            NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 20)
        ])
        return notificationTitle
    }()

    private let friendRequests: UITableView = {
       let friendRequests = UITableView()
       friendRequests.translatesAutoresizingMaskIntoConstraints = false
       friendRequests.register(CustomTableViewCell.self, forCellReuseIdentifier: CustomTableViewCell.identifier)
       return friendRequests
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: notificationTitle)
        friendRequests.bounces = false
        friendRequests.delegate = self
        friendRequests.dataSource = self
        view.addSubview(friendRequests)
        setScreenConstraints()
    }
    
    
    func setScreenConstraints() {
        NSLayoutConstraint.activate([
            friendRequests.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            friendRequests.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            friendRequests.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            friendRequests.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        30
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        60
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CustomTableViewCell.identifier, for: indexPath) as? CustomTableViewCell else {
            return UITableViewCell()
        }
        
        return cell
    }
}

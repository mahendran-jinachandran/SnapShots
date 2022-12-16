//
//  NotificationViewController.swift
//  SnapShots
//
//  Created by mahendran-14703 on 16/11/22.
//

import UIKit

class FriendsListVC: UIViewController {
    
    private var userID: Int
    private var friends: [User] = []
    private var friendsControls: FriendsControlsProtocol
  
    init(userID:Int,friendsControls: FriendsControlsProtocol) {
        self.userID = userID
        self.friendsControls = friendsControls
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private lazy var notificationTitle: UILabel = {
        var notificationTitle = UILabel()
        notificationTitle.attributedText = NSAttributedString(string: "Notification",attributes: [
            NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 20)
        ])
        return notificationTitle
    }()

    private lazy var friendsListTable: UITableView = {
       let friendsListTable = UITableView()
       friendsListTable.translatesAutoresizingMaskIntoConstraints = false
       return friendsListTable
    }()
    
    private lazy var noFriendsLabel: UILabel = {
       let noFriendsLabel = UILabel()
        noFriendsLabel.text = "No Friends"
        noFriendsLabel.textColor = .gray
        noFriendsLabel.textAlignment = .center
        return noFriendsLabel
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        

        setupNavigationItems()
        setupFriendsListTable()
        setFriendsListTableConstraints()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let indexPath = friendsListTable.indexPathForSelectedRow {
            friendsListTable.deselectRow(at: indexPath, animated: true)
        }
    }
    
    private func setupNavigationItems() {
        title = "Friends"
        view.backgroundColor = .systemBackground
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        navigationController?.navigationBar.tintColor = UIColor(named: "appTheme")
    }
    
    private func setupFriendsListTable() {
        friendsListTable.bounces = false
        friendsListTable.delegate = self
        friendsListTable.dataSource = self
        friendsListTable.register(FriendsListCustomTVCell.self, forCellReuseIdentifier: FriendsListCustomTVCell.identifier)
        friendsListTable.separatorStyle = .none
        friendsListTable.backgroundView = noFriendsLabel
        
        friends = friendsControls.getAllFriends(userID: userID)
        if friends.isEmpty {
            friendsListTable.backgroundView?.alpha = 1.0
        } else {
            friendsListTable.backgroundView?.alpha = 0.0
        }
    }
    
    private func setFriendsListTableConstraints() {
        view.addSubview(friendsListTable)
        NSLayoutConstraint.activate([
            friendsListTable.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            friendsListTable.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            friendsListTable.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            friendsListTable.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
}

extension FriendsListVC: UITableViewDataSource,UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let profileVC = ProfileVC(
            userID: friends[indexPath.row].userID,
            isVisiting: true)
        
        let profileControls = ProfileControls()
        profileVC.setController(profileControls)
        
        navigationController?.pushViewController(profileVC, animated: true)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return friends.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        60
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: FriendsListCustomTVCell.identifier, for: indexPath) as! FriendsListCustomTVCell
        
        let view = UIView()
        view.backgroundColor = .lightGray
        cell.selectedBackgroundView = view
        
        
        let profilePhoto = AppUtility.getDisplayPicture(userID: friends[indexPath.row].userID)
        cell.configure(
            userDP: profilePhoto,
            username: friends[indexPath.row].userName)
       
        return cell
    }
}

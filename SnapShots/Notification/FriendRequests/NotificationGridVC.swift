//
//  NotificationGridVC.swift
//  SnapShots
//
//  Created by mahendran-14703 on 25/11/22.
//

import UIKit

class NotificationGridVC: UIViewController {
    
    private var friendRequestsCV: UICollectionView!
    private var friendRequestsCVLayout: UICollectionViewFlowLayout!
    private var friendRequests: [User] = []
    private var notificationControls: NotificationControlsProtocols!
    
    func setNotificationControls(_ notificationControls: NotificationControlsProtocols) {
        self.notificationControls = notificationControls
    }
    
    private lazy var noRequestsNotify: UILabel = {
        let noRequestsNotify = UILabel()
        noRequestsNotify.text = "No Requests"
        noRequestsNotify.textColor = .gray
        noRequestsNotify.translatesAutoresizingMaskIntoConstraints = false
        noRequestsNotify.textAlignment = .center
        return noRequestsNotify
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    
        setupNavigationItems()
        setupFriendRequestTable()
        setConstraints()
        

    }
    
    func setupNavigationItems() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Notification", style: .plain, target: nil, action: nil)
        navigationController?.navigationBar.tintColor = UIColor(named: "appTheme")
    }
    
    func setupFriendRequestTable() {
        
        friendRequestsCVLayout = UICollectionViewFlowLayout()
        friendRequestsCVLayout.scrollDirection = .vertical
        friendRequestsCVLayout.minimumLineSpacing = 1
        friendRequestsCVLayout.minimumInteritemSpacing = 1
        
        friendRequestsCV = UICollectionView(frame: .zero, collectionViewLayout: friendRequestsCVLayout)
        friendRequestsCV.translatesAutoresizingMaskIntoConstraints = false
        friendRequestsCV.dataSource = self
        friendRequestsCV.delegate = self
        friendRequestsCV.showsVerticalScrollIndicator = false
        friendRequestsCV.register(NotificiationGridCVCell.self, forCellWithReuseIdentifier: NotificiationGridCVCell.identifier)
        friendRequestsCV.backgroundView = noRequestsNotify
        
        friendRequests = notificationControls.getAllFriendRequests()
        if friendRequests.isEmpty {
            friendRequestsCV.backgroundView?.alpha = 1.0
            return
        }
    }
    
    func setConstraints() {
        
        [friendRequestsCV].forEach {
            view.addSubview($0)
        }
        
        NSLayoutConstraint.activate([
            friendRequestsCV.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            friendRequestsCV.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            friendRequestsCV.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            friendRequestsCV.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        if previousTraitCollection?.verticalSizeClass != traitCollection.verticalSizeClass {
            friendRequestsCVLayout.invalidateLayout()
        }
    }
}

extension NotificationGridVC: UICollectionViewDelegateFlowLayout,UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if friendRequests.count > 0 {
            friendRequestsCV.backgroundView?.alpha = 0.0
            return friendRequests.count
        } else {
            friendRequestsCV.backgroundView?.alpha = 1.0
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NotificiationGridCVCell.identifier, for: indexPath) as! NotificiationGridCVCell
        cell.notificationGridVCCellDelegate = self
        
        let profilePicture = AppUtility.getDisplayPicture(userID: friendRequests[indexPath.row].userID)
        
        cell.configure(
            username: friendRequests[indexPath.row].userName,
            userDP: profilePicture)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (collectionView.frame.width / 2) - 1,
                      height: ( collectionView.frame.height / 3.75) - 1)
    }
}

extension NotificationGridVC: NotificiationGridCVCellDelegate {
    
    func acceptFriendRequest(sender: NotificiationGridCVCell) {
        let indexPath = friendRequestsCV.indexPath(for: sender)!
        
        if notificationControls.acceptFriendRequest(acceptingUserID: friendRequests[indexPath.row].userID) {
            friendRequests.remove(at: indexPath.row)
            friendRequestsCV.reloadData()
        }
    }
    
    func rejectFriendRequest(sender: NotificiationGridCVCell) {
        let indexPath = friendRequestsCV.indexPath(for: sender)!
        
        if notificationControls.rejectFriendRequest(rejectingUserID: friendRequests[indexPath.row].userID) {
            friendRequests.remove(at: indexPath.row)
            friendRequestsCV.reloadData()
        }
    }
}

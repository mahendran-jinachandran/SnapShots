//
//  NotificationGridVC.swift
//  SnapShots
//
//  Created by mahendran-14703 on 25/11/22.
//

import UIKit

class NotificationGridVC: UIViewController {
    
    private var noRequestsNotify: UILabel = {
        let noRequestsNotify = UILabel()
        noRequestsNotify.text = "No Requests"
        noRequestsNotify.textColor = .gray
        noRequestsNotify.translatesAutoresizingMaskIntoConstraints = false
        return noRequestsNotify
    }()
    private var friendRequestsCV: UICollectionView!
    private var friendRequestsCVLayout: UICollectionViewFlowLayout!
    private var friendRequests: [(userId: Int, userName: String,userDP: UIImage)] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        
        friendRequests = NotificationControls().getAllFriendRequests()
        
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Notification", style: .plain, target: nil, action: nil)
        navigationItem.leftBarButtonItem?.tintColor = UIColor(named: "appTheme")
        
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
        


        setConstraints()
        
        if friendRequests.isEmpty {
            setupNoRequestsConstraints()
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
    
    func setupNoRequestsConstraints() {
        
        [noRequestsNotify].forEach {
            view.addSubview($0)
        }
        
        NSLayoutConstraint.activate([
            noRequestsNotify.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            noRequestsNotify.centerYAnchor.constraint(equalTo: view.centerYAnchor)
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
        return friendRequests.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NotificiationGridCVCell.identifier, for: indexPath) as! NotificiationGridCVCell
        cell.notificationGridVCCellDelegate = self
        cell.configure(
            username: friendRequests[indexPath.row].userName,
            userDP: friendRequests[indexPath.row].userDP)
        
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
        
        if NotificationControls().acceptFriendRequest(acceptingUserID: friendRequests[indexPath.row].userId) {
            friendRequestsCV.deleteItems(at: [indexPath])
            friendRequests.remove(at: indexPath.row)
            friendRequestsCV.reloadData()
        }
    }
    
    func rejectFriendRequest(sender: NotificiationGridCVCell) {
        print(sender)
    }
}

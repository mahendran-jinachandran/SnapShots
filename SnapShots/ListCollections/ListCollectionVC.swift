//
//  ListCollectionVC.swift
//  SnapShots
//
//  Created by mahendran-14703 on 10/01/23.
//

import UIKit

class ListCollectionVC: UIViewController {
    
    private lazy var layout = UICollectionViewFlowLayout()
    private var listCollectionControls: ListCollectionControlsProtocol
    private var posts = [ListCollectionDetails]()
    private var collectionEntity: ListCollectionEntity
    
    private lazy var listCollection: UICollectionView = {
        var listCollection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        listCollection.translatesAutoresizingMaskIntoConstraints = false
        return listCollection
    }()
    
    private lazy var emptyLabel: UILabel = {
        let emptyLabel = UILabel()
        emptyLabel.text = "Empty"
        emptyLabel.textColor = .gray
        emptyLabel.translatesAutoresizingMaskIntoConstraints = false
        emptyLabel.textAlignment = .center
        return emptyLabel
    }()
    
    init(listCollectionControls: ListCollectionControlsProtocol,listCollectionEntity: ListCollectionEntity) {
        self.listCollectionControls = listCollectionControls
        self.collectionEntity = listCollectionEntity
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if collectionEntity == .archive {
            title = "Archive"
        } else {
            title = "Saved Collection"
        }
   
        view.backgroundColor = .systemBackground
        setupListCollections()
        setupNotificationCenters()
    }
    
    func setupNotificationCenters() {
        NotificationCenter.default.addObserver(self, selector: #selector(deletePost(_:)), name: Constants.deletePostEvent, object: nil)
     //   NotificationCenter.default.addObserver(self, selector: #selector(updatePosts(_:)), name: Constants.updatePostEvent, object: nil)
    }
    
    @objc private func deletePost(_ notification: NSNotification) {
        
        if let data = notification.userInfo?[Constants.notificationCenterKeyName] as? ListCollectionDetails {
            
            for (index,post) in posts.enumerated() where post.userID == data.userID && post.postID == data.postID {
                
                posts.remove(at: index)
                listCollection.scrollToItem(at: IndexPath(row: index, section: 0), at: .top, animated: true)
                listCollection.deleteItems(at: [IndexPath(row: index, section: 0)])
            }
        }
    }
//
//    @objc private func updatePosts(_ notification: NSNotification) {
//
//        if let data = notification.userInfo?[Constants.notificationCenterKeyName] as? FeedsDetails {
//
//            if data.postDetails.isArchived {
//                for (index,post) in posts.enumerated() where post.userID == data.userID && post.postID == data.postDetails.postID {
//
//                    posts.remove(at: index)
//                    listCollection.scrollToItem(at: IndexPath(row: index, section: 0), at: .top, animated: true)
//                    listCollection.deleteItems(at: [IndexPath(row: index, section: 0)])
//                }
//            } else {
//                posts.append(ListCollectionDetails(userID: data.userID, postID: data.postDetails.postID))
//                listCollection.insertItems(at: [IndexPath(row: 0, section: 0)])
//            }
//        }
//    }
    
    private func setupListCollections() {
        
        layout.minimumLineSpacing = 15
        layout.minimumInteritemSpacing = 1
        
        listCollection.alwaysBounceVertical = true
        listCollection.showsVerticalScrollIndicator = true
        listCollection.delegate = self
        listCollection.dataSource = self
        listCollection.backgroundView = emptyLabel
        
        listCollection.register(ListCollectionCustomCell.self, forCellWithReuseIdentifier: ListCollectionCustomCell.identifier)
        
        view.addSubview(listCollection)
        
        NSLayoutConstraint.activate([
            listCollection.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor,constant: 8),
            listCollection.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor,constant: -8),
            listCollection.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            listCollection.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
        
        if collectionEntity == .archive {
            posts = listCollectionControls.getAllArchivedPosts()
        } else {
            posts = listCollectionControls.getAllSavedCollections()
        }
    }
    
    @objc func setupData() {
        if collectionEntity == .archive {
            posts = listCollectionControls.getAllArchivedPosts()
        } else {
            posts = listCollectionControls.getAllSavedCollections()
        }
    }
}

extension ListCollectionVC: UICollectionViewDelegateFlowLayout,UICollectionViewDataSource {
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        
        if previousTraitCollection?.verticalSizeClass != traitCollection.verticalSizeClass {
            layout.invalidateLayout()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if posts.count > 0 {
            listCollection.backgroundView?.alpha = 0.0
            return posts.count
        }
            
        listCollection.backgroundView?.alpha = 1.0
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ListCollectionCustomCell.identifier, for: indexPath) as! ListCollectionCustomCell
        
        let postPicture = AppUtility.getPostPicture(
            userID: posts[indexPath.row].userID,
            postID: posts[indexPath.row].postID)
        
        cell.configure(postImage: postPicture)
        cell.delegate = self
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: (collectionView.frame.width / 3) - 10,
                      height: ( collectionView.frame.width / 3) - 1)
    }
}

extension ListCollectionVC: ListCollectionCustomCellDelegate {
    func openPost(sender: ListCollectionCustomCell) {
        
        let indexPath = listCollection.indexPath(for: sender)!
        
        let postPicture = AppUtility.getPostPicture(
            userID: posts[indexPath.row].userID,
            postID: posts[indexPath.row].postID)
        
        let postDetails = listCollectionControls.getPostDetails(userID: posts[indexPath.row].userID,
                                                                postID: posts[indexPath.row].postID)
        
        let isSaved = listCollectionControls.isSavedPost(userID: posts[indexPath.row].userID,
                                                         postID: posts[indexPath.row].postID)
        let postControls = PostControls()
        let postVC = PostVC(
            postControls: postControls,
            userID: posts[indexPath.row].userID,
            postImage: postPicture,
            postDetails: postDetails,isSaved: isSaved)
    
        navigationController?.pushViewController(postVC,animated: true)
    }
}

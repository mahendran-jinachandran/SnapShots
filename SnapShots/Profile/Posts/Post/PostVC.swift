//
//  PostViewController.swift
//  SnapShots
//
//  Created by mahendran-14703 on 24/11/22.
//

import UIKit

class PostVC: UIViewController {
    
    var particularPost: FeedsCustomCell!
    var postImage: UIImage!
    var postDetails: Post!
    
    init(postImage: UIImage,postDetails: Post) {
        self.postImage = postImage
        self.postDetails = postDetails
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        title = "Posts"
        navigationItem.hidesBackButton = true
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "arrow.left"),
            style: .plain,
            target: self,
            action: #selector(goBack))
        
        
        navigationItem.leftBarButtonItem?.tintColor = UIColor(named: "mainPage")
        
        particularPost = FeedsCustomCell()
        particularPost.translatesAutoresizingMaskIntoConstraints = false
        
        particularPost.caption.text = postDetails.caption
        particularPost.post.image = postImage
        
        view.addSubview(particularPost)
        
        NSLayoutConstraint.activate([
            particularPost.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor,constant: 8),
            particularPost.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            particularPost.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            particularPost.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
        
        
        particularPost.moreInfo.addTarget(self, action: #selector(showOwnerMenu(_:)), for: .touchUpInside)

        particularPost.comment.addTarget(self, action: #selector(gotToComments), for: .touchUpInside)
      
    }
    
    @objc func goBack() {
        self.navigationController?.popViewController(animated: false)
    }
    
    @objc func goToLikes() {
        self.navigationController?.pushViewController(LikesVC(), animated: true)
    }
    
    @objc func gotToComments() {
        self.navigationController?.pushViewController(CommentsVC(), animated: true)
    }
    
    @objc func showOwnerMenu(_ sender: UIButton) {
    
        let moreInfo = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let allLikes = UIAlertAction(title: "All Likes", style: .default) { _ in
            self.goToLikes()
        }

        let edit = UIAlertAction(title: "Edit", style: .default) { _ in
            print("EDIT")
        }

        let deletePost = UIAlertAction(title: "Delete", style: .default) { _ in
            self.confirmDeletion()
        }

        let cancel = UIAlertAction(title: "Cancel", style: .cancel,handler: nil)

        moreInfo.addAction(allLikes)
        moreInfo.addAction(edit)
        moreInfo.addAction(deletePost)
        moreInfo.addAction(cancel)
        
        present(moreInfo, animated: true)
        
    }
    
    func confirmDeletion() {
        
        let confirmDeletion = UIAlertController(title: "Confirm Delete?", message: "You won't be able to retrieve it later.", preferredStyle: .alert)
        
        let confirm = UIAlertAction(title: "Delete", style: .destructive) { _ in
            PostControls().deletePost(postID: self.postDetails.postID)
            self.navigationController?.popViewController(animated: true)
        }
        
        let cancel = UIAlertAction(title: "Cancel", style: .cancel)
        
        confirmDeletion.addAction(confirm)
        confirmDeletion.addAction(cancel)
        
        present(confirmDeletion, animated: true)
        
    }
}

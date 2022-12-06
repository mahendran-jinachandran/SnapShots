//
//  LikesVC.swift
//  SnapShots
//
//  Created by mahendran-14703 on 24/11/22.
//

import UIKit

class LikesVC: UIViewController {
    
    var postUserID: Int
    var postID: Int
    var likedUsers: [(user: User,profilePhoto: UIImage)] = []
    
    init(postUserID: Int,postID: Int) {
        self.postUserID = postUserID
        self.postID = postID
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private lazy var likesTable: UITableView = {
        let likesTable = UITableView()
        likesTable.translatesAutoresizingMaskIntoConstraints = false
        likesTable.register(
            LikesCustomCell.self,
            forCellReuseIdentifier: LikesCustomCell.identifier)
        likesTable.separatorStyle = .none
        return likesTable
    }()
    
    private lazy var emptyLikesLabel: UILabel = {
        let emptyLikes = UILabel()
        emptyLikes.text = "No Likes yet. Be the first."
        emptyLikes.translatesAutoresizingMaskIntoConstraints = false
        emptyLikes.font = UIFont.boldSystemFont(ofSize: 25)
        emptyLikes.numberOfLines = 2
        emptyLikes.textAlignment = .center
        emptyLikes.textColor = .gray
        return emptyLikes
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        title = "Likes"
        view.backgroundColor = .systemBackground
        setupLikesTable()
        setNavigationItems()
    }
    
    func setupLikesTable() {
        likesTable.delegate = self
        likesTable.dataSource = self
        
        likedUsers = LikesControls().getAllLikedUsers(postUserID: postUserID, postID: postID)
        
        if likedUsers.isEmpty {
            setupEmptyConstraints()
        } else {
            setupConstraints()
        }
    }
    
    func setNavigationItems() {
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        navigationController?.navigationBar.tintColor = UIColor(named: "appTheme")
    }
    
    func setupConstraints() {
        view.addSubview(likesTable)
        NSLayoutConstraint.activate([
            likesTable.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor,constant: 8),
            likesTable.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor,constant: 8),
            likesTable.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            likesTable.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    func setupEmptyConstraints() {
        view.addSubview(emptyLikesLabel)
        NSLayoutConstraint.activate([
            emptyLikesLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor,constant: 8),
            emptyLikesLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            emptyLikesLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            emptyLikesLabel.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
}

extension LikesVC: UITableViewDelegate,UITableViewDataSource {

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return likedUsers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(
            withIdentifier: LikesCustomCell.identifier,
            for: indexPath) as! LikesCustomCell
        
        cell.configure(
            profilePhoto: likedUsers[indexPath.row].profilePhoto,
            userNameLabel: likedUsers[indexPath.row].user.userName)
        
        return cell
    }
}

//
//  FeedsViewController.swift
//  SnapShots
//
//  Created by mahendran-14703 on 14/11/22.
//

import UIKit

class FeedsViewController: UIViewController {
    
    var feedPosts: [(userID:Int,userName: String,userDP: UIImage,postDetails:Post,postPhoto: UIImage)] = []
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private let feedsTable: UITableView = {
        let feedsTable = UITableView(frame: .zero)
        feedsTable.translatesAutoresizingMaskIntoConstraints = false
        feedsTable.register(FeedsCustomCell.self, forCellReuseIdentifier: FeedsCustomCell.identifier)
        feedsTable.bounces = false
        feedsTable.separatorStyle = .none
       return feedsTable
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        

        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "SnapShots", style: .plain, target: nil, action: nil)
        
        feedsTable.delegate = self
        feedsTable.dataSource = self
        view.addSubview(feedsTable)
        feedsTable.estimatedRowHeight = 300
        feedsTable.rowHeight = UITableView.automaticDimension
        setConstraints()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        feedPosts = FeedsControls().getAllPosts()
        if feedPosts.count > 0 {
            feedsTable.reloadData()
        } else {
            feedPosts = []
            feedsTable.reloadData()
        }
    }
    
    func setConstraints() {
        NSLayoutConstraint.activate([
            feedsTable.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            feedsTable.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor,constant: 8),
            feedsTable.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor,constant: -8),
            feedsTable.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
}

extension FeedsViewController: UITableViewDelegate,UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return feedPosts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let particularCell = tableView.dequeueReusableCell(withIdentifier: FeedsCustomCell.identifier, for: indexPath) as! FeedsCustomCell
        
        // MARK: CHANGE IT INTO CONFIGURE
        particularCell.userNameLabel.text = "\(feedPosts[indexPath.row].userName)"
        particularCell.post.image = feedPosts[indexPath.row].postPhoto
        particularCell.profilePhoto.image = feedPosts[indexPath.row].userDP
        particularCell.caption.text = feedPosts[indexPath.row].postDetails.caption
        return particularCell
    }
}

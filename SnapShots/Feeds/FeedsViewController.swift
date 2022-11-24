//
//  FeedsViewController.swift
//  SnapShots
//
//  Created by mahendran-14703 on 14/11/22.
//

import UIKit

class FeedsViewController: UIViewController {
    
    var feedPosts: [(userID:Int,userName: String,userDP: UIImage,postDetails:Post,postPhoto: UIImage)] = []
    
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

        // Do any additional setup after loading the view.
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "SnapShots", style: .plain, target: nil, action: nil)
        
        feedsTable.delegate = self
        feedsTable.dataSource = self
        view.addSubview(feedsTable)
        setConstraints()
        
        feedPosts = FeedsControls().getAllPosts()
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
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 480
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return feedPosts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let particularCell = tableView.dequeueReusableCell(withIdentifier: FeedsCustomCell.identifier, for: indexPath) as! FeedsCustomCell
        
        particularCell.userNameLabel.text = "\(feedPosts[indexPath.row].userName)"
        particularCell.post.image = feedPosts[indexPath.row].postPhoto
        particularCell.profilePhoto.image = feedPosts[indexPath.row].userDP
        
        return particularCell
        
    }
}

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
        
        setNavigationItems()
        
        feedsTable.delegate = self
        feedsTable.dataSource = self
        view.addSubview(feedsTable)
        feedsTable.estimatedRowHeight = 300
        feedsTable.rowHeight = UITableView.automaticDimension
        setConstraints()
    }
    
    func setNavigationItems() {
        let friendsAction = UIAction(
          title: "Friends",
          image: UIImage(systemName: "person.3.fill")) { _ in
           print("VIEW MAP")
        }

        let postsAction = UIAction(
          title: "Favourites",
          image: UIImage(systemName: "star.circle")) { _ in
           print("VIEW MAP")
        }
        
        let button  = UIButton(type: .custom)
        button.showsMenuAsPrimaryAction = true
        button.titleLabel?.font = UIFont(name: "Billabong", size: 30)
        button.setTitle("Snapshots ", for: .normal)
        button.setTitleColor(UIColor(named: "mainPage"), for: .normal)
        button.setImage(UIImage(systemName: "chevron.down")!, for: .normal)
        button.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
        button.titleLabel?.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
        button.imageView?.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
        button.tintColor = UIColor(named: "mainPage")!
       
        button.menu = UIMenu(title: "", image: nil, children: [friendsAction,postsAction])
        
        let barButton =  UIBarButtonItem(customView: button)
        
        navigationItem.leftBarButtonItem = barButton
    }
    
    @objc func test() {
        print(#function)
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
            feedsTable.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor,constant: 8),
            feedsTable.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            feedsTable.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
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
        
        particularCell.delegate = self
        
        // MARK: CHANGE IT INTO CONFIGURE
        particularCell.userNameLabel.text = "\(feedPosts[indexPath.row].userName)"
        particularCell.post.image = feedPosts[indexPath.row].postPhoto
        particularCell.profilePhoto.image = feedPosts[indexPath.row].userDP
        particularCell.caption.text = feedPosts[indexPath.row].postDetails.caption
        return particularCell
    }
}

extension FeedsViewController: FeedsCustomCellDelegate {
    func controller() -> FeedsViewController {
        return self
    }
}

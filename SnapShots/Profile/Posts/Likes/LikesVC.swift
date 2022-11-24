//
//  LikesVC.swift
//  SnapShots
//
//  Created by mahendran-14703 on 24/11/22.
//

import UIKit

class LikesVC: UIViewController {
    
    private lazy var likesTable: UITableView = {
        let likesTable = UITableView()
        likesTable.translatesAutoresizingMaskIntoConstraints = false
        likesTable.register(
            LikesCustomCell.self,
            forCellReuseIdentifier: LikesCustomCell.identifier)
        likesTable.separatorStyle = .none
        return likesTable
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        title = "Likes"
        
        likesTable.delegate = self
        likesTable.dataSource = self
        view.addSubview(likesTable)
        setupConstraints()
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            likesTable.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor,constant: 8),
            likesTable.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            likesTable.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            likesTable.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
}

extension LikesVC: UITableViewDelegate,UITableViewDataSource {
    
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(
            withIdentifier: LikesCustomCell.identifier,
            for: indexPath) as! LikesCustomCell
        
        
        return cell
    }
}

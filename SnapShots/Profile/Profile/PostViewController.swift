//
//  PostViewController.swift
//  SnapShots
//
//  Created by mahendran-14703 on 24/11/22.
//

import UIKit

class PostViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let feedsCustomCell = FeedsCustomCell()
        feedsCustomCell.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(feedsCustomCell)
        
        NSLayoutConstraint.activate([
            feedsCustomCell.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            feedsCustomCell.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            feedsCustomCell.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            feedsCustomCell.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
}

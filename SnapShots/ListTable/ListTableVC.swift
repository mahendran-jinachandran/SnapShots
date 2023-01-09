//
//  ListTableVC.swift
//  SnapShots
//
//  Created by mahendran-14703 on 09/01/23.
//

import UIKit



class ListTableVC: UIViewController {
    
    private lazy var listTable: UITableView = {
        let listTable = UITableView(frame: .zero)
        listTable.translatesAutoresizingMaskIntoConstraints = false
        return listTable
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        setupListTable()
    }
    
    private func setupListTable() {
        
        listTable.register(
            ListTableViewCell.self,
            forCellReuseIdentifier: ListTableViewCell.identifier)
        
        listTable.delegate = self
        listTable.dataSource = self
        
        view.addSubview(listTable)
        
        NSLayoutConstraint.activate([
            listTable.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            listTable.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            listTable.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            listTable.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
        ])
    }
}

extension ListTableVC: UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: ListTableViewCell.identifier, for: indexPath)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 65
    }
}

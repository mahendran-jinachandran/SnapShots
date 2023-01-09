//
//  ListTableVC.swift
//  SnapShots
//
//  Created by mahendran-14703 on 09/01/23.
//

import UIKit



class ListTableVC: UIViewController {
    
    private var blockedUsers = [User]()
    private var listTableControls: ListTableProtocol
    private lazy var listTable: UITableView = {
        let listTable = UITableView(frame: .zero)
        listTable.translatesAutoresizingMaskIntoConstraints = false
        return listTable
    }()
    
    
    init(listTableControls: ListTableProtocol) {
        self.listTableControls = listTableControls
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        title = "Blocked Users"
        view.backgroundColor = .systemBackground
        setupListTable()
    }
    
    private func setupListTable() {
        
        blockedUsers = listTableControls.getBlockedUsers()
        listTable.register(
            ListTableViewCell.self,
            forCellReuseIdentifier: ListTableViewCell.identifier)
        listTable.separatorStyle = .none
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
       return blockedUsers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: ListTableViewCell.identifier, for: indexPath) as! ListTableViewCell
        
        let profilePicture = AppUtility.getDisplayPicture(userID: blockedUsers[indexPath.row].userID)
        cell.configure(
            profilePhoto: profilePicture,
            userNameLabel: blockedUsers[indexPath.row].userName)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 65
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            
            if !listTableControls.unblockTheUser(unblockingUserID: blockedUsers[indexPath.row].userID) {
                showToast(message: Constants.toastFailureStatus)
            }
        
            blockedUsers.remove(at: indexPath.row)
            listTable.deleteRows(at: [indexPath], with: .left)
            NotificationCenter.default.post(name: Constants.blockEvent, object: nil)
        }
    }

    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? {
        return "Remove"
    }
}

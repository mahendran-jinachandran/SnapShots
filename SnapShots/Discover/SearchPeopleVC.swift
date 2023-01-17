//
//  SearchPeopleViewController.swift
//  SnapShots
//
//  Created by mahendran-14703 on 14/11/22.
//

import UIKit
import Lottie

class SearchPeopleVC: UIViewController {

    private var people: [User] = []
    private var dupPeople: [User] = []
    private var searchBar: UISearchController!
    private var searchControls: SearchControlsProtocol!
    
    func setController(_ searchControls: SearchControlsProtocol) {
        self.searchControls = searchControls
    }

    private lazy var searchTable: UITableView = {
        let recentSearchTable = UITableView(frame: .zero)
        recentSearchTable.translatesAutoresizingMaskIntoConstraints = false
       return recentSearchTable
    }()
    
    private lazy var searchEmptyLabel: UILabel = {
       let searchEmptyLabel = UILabel()
        searchEmptyLabel.text = "User not found"
        searchEmptyLabel.textColor = .gray
        searchEmptyLabel.textAlignment = .center
        return searchEmptyLabel
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNotificationSubscription()
        setupNavigationItems()
        setupSearchTable()
        setSearchTableConstraints()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let indexPath = searchTable.indexPathForSelectedRow {
            searchTable.deselectRow(at: indexPath, animated: true)
        }
    }
    
    private func setupNavigationItems() {
        title = "Search"
        view.backgroundColor = .systemBackground
        navigationItem.hidesSearchBarWhenScrolling = false
        
        searchBar = UISearchController(searchResultsController: nil)
        searchBar.searchBar.placeholder = "Search people 🌎"
        navigationItem.searchController = searchBar
        searchBar.searchBar.delegate = self
    }
    
    private func setupSearchTable() {
    
        people = searchControls.getAllUsers()
        dupPeople = people
        
        searchTable.delegate = self
        searchTable.dataSource = self
        searchTable.register(SearchTableViewCell.self, forCellReuseIdentifier: SearchTableViewCell.identifier)
        searchTable.separatorStyle = .none
        searchTable.backgroundView = searchEmptyLabel
        searchTable.backgroundView?.alpha = 0.0
    }
    
    @objc func setupData() {
        people = searchControls.getAllUsers()
        dupPeople = people
    }
    
    private func setupNotificationSubscription() {
        NotificationCenter.default.addObserver(self, selector: #selector(updateUser(_:)), name: Constants.updateUserEvent, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(removeUser(_:)), name: Constants.blockUserEvent, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(addUser(_:)), name: Constants.unblockingUserEvent, object: nil)
    }
    
    @objc private func updateUser(_ notification: NSNotification) {
     
        if let data = notification.userInfo?[Constants.notificationCenterKeyName] as? User {
            
            for (index,user) in people.enumerated() where user.userID == data.userID {
                
                people[index].userName = data.userName
                dupPeople[index].userName = data.userName
                
                people[index].profile.photo = AppUtility.getProfilePhotoSavingFormat(userID: data.userID)
                dupPeople[index].profile.photo = AppUtility.getProfilePhotoSavingFormat(userID: data.userID)

                searchTable.scrollToRow(at: IndexPath(row: index, section: 0), at: .none, animated: true)
                searchTable.reloadRows(at: [IndexPath(row: index, section: 0)], with: .none)
            }
        }
    }
    
    @objc private func addUser(_ notification: NSNotification) {
        
        if let data = notification.userInfo?[Constants.notificationCenterKeyName] as? Int {
            
            let user = searchControls.getUser(userID: data)
            print(user.userName)
            
            var position = people.insertionIndexOf(user) {
                $0.userName < $1.userName
            }
            
            print(position)
            
            people.insert(user, at: position)
            dupPeople.insert(user, at: position)
            people[position].profile.photo = AppUtility.getProfilePhotoSavingFormat(userID: user.userID)
            dupPeople[position].profile.photo = AppUtility.getProfilePhotoSavingFormat(userID: user.userID)
            searchTable.insertRows(at: [IndexPath(row: position, section: 0)], with: .top)
            
        } else {
            print("Null")
        }
    }
    
    @objc private func removeUser(_ notification: NSNotification) {
        
        if let data = notification.userInfo?[Constants.notificationCenterKeyName] as? Int {
            
            for (index,user) in people.enumerated() where user.userID == data {
                    
                people.remove(at: index)
                dupPeople.remove(at: index)
                
                searchTable.scrollToRow(at: IndexPath(row: index, section: 0), at: .none, animated: true)
                searchTable.deleteRows(at: [IndexPath(row: index, section: 0)], with: .none)
            }
        }
    }
    
    @objc private func refreshSearch() {
        people = searchControls.getAllUsers()
        dupPeople = people
        searchTable.reloadData()
    }
    
    private func setSearchTableConstraints() {
        
        view.addSubview(searchTable)
        NSLayoutConstraint.activate([
            searchTable.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            searchTable.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            searchTable.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            searchTable.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
        ])
    }
}

extension SearchPeopleVC: UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dupPeople.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let profileControls = ProfileControls()
        let profileVC = ProfileVC(
            profileControls: profileControls,
            userID: dupPeople[indexPath.row].userID,
            isVisiting: true)

        navigationController?.pushViewController(profileVC, animated: true)
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let particularCell = tableView.dequeueReusableCell(withIdentifier: SearchTableViewCell.identifier, for: indexPath) as! SearchTableViewCell
        
        let view = UIView()
        view.backgroundColor = .lightGray
        particularCell.selectedBackgroundView = view
        
        let userProfilePicture = AppUtility.getDisplayPicture(userID: dupPeople[indexPath.row].userID)

        particularCell.tag = indexPath.row
        particularCell.configure(
            userName: dupPeople[indexPath.row].userName,
            userDP: userProfilePicture)
        
        return particularCell
    }
}

extension SearchPeopleVC: UISearchTextFieldDelegate, UISearchBarDelegate {
    
 
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {

        if searchText.isEmpty {
            dupPeople = people
            searchTable.backgroundView?.alpha = 0.0
            searchTable.reloadData()
            return
        }

        let data = people.filter( {
            $0.userName.contains(searchText)
        })

        searchTable.backgroundView?.alpha = data.isEmpty ? 1.0 : 0.0
        dupPeople = data
        searchTable.reloadData()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        dupPeople = people
        searchTable.backgroundView?.alpha = 0.0
        searchTable.reloadData()
    }
}

extension Array {
    func insertionIndexOf(_ elem: Element, isOrderedBefore: (Element, Element) -> Bool) -> Int {
        var lo = 0
        var hi = self.count - 1
        while lo <= hi {
            let mid = (lo + hi)/2
            if isOrderedBefore(self[mid], elem) {
                lo = mid + 1
            } else if isOrderedBefore(elem, self[mid]) {
                hi = mid - 1
            } else {
                return mid // found at position mid
            }
        }
        return lo // not found, would be inserted at position lo
    }
}




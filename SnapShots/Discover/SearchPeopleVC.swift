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
        searchEmptyLabel.text = "Search not found"
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
    
    private func setupNavigationItems() {
        title = "Search"
        searchBar = UISearchController(searchResultsController: nil)
        searchBar.searchBar.placeholder = "Search people 🌎"
        navigationItem.hidesSearchBarWhenScrolling = false
        navigationItem.searchController = searchBar
        
        searchBar.searchBar.delegate = self
    }
    
    private func setupSearchTable() {
        people = searchControls.getAllUsers()
        dupPeople = people
        
        searchTable.delegate = self
        searchTable.dataSource = self
        searchTable.register(SearchTableViewCell.self, forCellReuseIdentifier: SearchTableViewCell.identifier)
        searchTable.bounces = false
        searchTable.separatorStyle = .none
        searchTable.backgroundView = searchEmptyLabel
        searchTable.backgroundView?.alpha = 0.0
    }
    
    private func setupNotificationSubscription() {
        NotificationCenter.default.addObserver(self, selector: #selector(refreshSearch), name: Constants.userDetailsEvent, object: nil)
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
        let profileVC = ProfileVC(userID: dupPeople[indexPath.row].userID,isVisiting: true)
        let profileControls = ProfileControls()
        profileVC.setController(profileControls)
        
        navigationController?.pushViewController(profileVC, animated: true)
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let particularCell = tableView.dequeueReusableCell(withIdentifier: SearchTableViewCell.identifier, for: indexPath) as! SearchTableViewCell
        
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
        searchTable.reloadData()
    }
}




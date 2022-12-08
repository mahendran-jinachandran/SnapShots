//
//  SearchPeopleViewController.swift
//  SnapShots
//
//  Created by mahendran-14703 on 14/11/22.
//

import UIKit
import Lottie

class SearchPeopleVC: UIViewController {

    private var people: [(user: User,userDP: UIImage)] = []
    private var dupPeople: [(user: User,userDP: UIImage)] = []
    private var searchBar: UISearchController!
    private var searchControls: SearchControlsProtocol!
    
    func setController(_ searchControls: SearchControlsProtocol) {
        self.searchControls = searchControls
    }

    private lazy var recentSearchTable: UITableView = {
        let recentSearchTable = UITableView(frame: .zero)
        recentSearchTable.translatesAutoresizingMaskIntoConstraints = false
        recentSearchTable.register(SearchTableViewCell.self, forCellReuseIdentifier: SearchTableViewCell.identifier)
        recentSearchTable.bounces = false
        recentSearchTable.separatorStyle = .none
       return recentSearchTable
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        people = searchControls.getAllUsers()
        dupPeople = people
        
        title = "Search"
        searchBar = UISearchController(searchResultsController: nil)
        searchBar.searchBar.placeholder = "Search people 🌎"
        navigationItem.hidesSearchBarWhenScrolling = false
        navigationItem.searchController = searchBar
        
        searchBar.searchBar.delegate = self
        recentSearchTable.delegate = self
        recentSearchTable.dataSource = self
        
        view.addSubview(recentSearchTable)
        
        setSearchTableConstraints()
    }
    
    func setSearchTableConstraints() {
        NSLayoutConstraint.activate([
            recentSearchTable.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            recentSearchTable.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            recentSearchTable.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            recentSearchTable.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
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
        let profileVC = ProfileVC(userID: dupPeople[indexPath.row].user.userID,isVisiting: true)
        let profileControls = ProfileControls()
        profileVC.setController(profileControls)
        
        navigationController?.pushViewController(profileVC, animated: false)
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let particularCell = tableView.dequeueReusableCell(withIdentifier: SearchTableViewCell.identifier, for: indexPath) as! SearchTableViewCell

        particularCell.tag = indexPath.row
        particularCell.configure(
            userName: dupPeople[indexPath.row].user.userName,
            userDP: dupPeople[indexPath.row].userDP)
        return particularCell
    }
}

extension SearchPeopleVC: UISearchTextFieldDelegate, UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        if searchText.isEmpty {
            dupPeople = people
            recentSearchTable.reloadData()
            return
        }

        let data = people.filter( {
            $0.user.userName.contains(searchText)
        })
        
        // MARK: SHOW THE SEARCHED RESULTS IS EMPTY BY USING LABEL AS TABLE VIEW BACKGROUND VIEW AS DONE IN NOTIFICATIONS
        if data.isEmpty {
        }
        
        dupPeople = data
        recentSearchTable.reloadData()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        dupPeople = people
        recentSearchTable.reloadData()
    }
}




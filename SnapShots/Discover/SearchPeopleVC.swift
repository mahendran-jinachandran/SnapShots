//
//  SearchPeopleViewController.swift
//  SnapShots
//
//  Created by mahendran-14703 on 14/11/22.
//

import UIKit
import Lottie

class SearchPeopleViewController: UIViewController {

    var people: [(user: User,userDP: UIImage)] = []
    var dupPeople: [(user: User,userDP: UIImage)] = []
        
    private var searchBar: UISearchController!

    private let recentSearchTable: UITableView = {
        let recentSearchTable = UITableView(frame: .zero)
        recentSearchTable.translatesAutoresizingMaskIntoConstraints = false
        recentSearchTable.register(SearchTableViewCell.self, forCellReuseIdentifier: SearchTableViewCell.identifier)
        recentSearchTable.bounces = false
        recentSearchTable.separatorStyle = .none
       return recentSearchTable
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        people = SearchControls().getAllUsers()
        dupPeople = people
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

extension SearchPeopleViewController: UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dupPeople.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let profileVC = ProfileVC(userID: dupPeople[indexPath.row].user.userID)
        let profileControls = ProfileControls()
        
        profileVC.profileControls = profileControls
        
        navigationController?.pushViewController(profileVC, animated: false)
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let particularCell = tableView.dequeueReusableCell(withIdentifier: SearchTableViewCell.identifier, for: indexPath) as! SearchTableViewCell
        
        
        particularCell.tag = indexPath.row
        particularCell.searchPeopleVCDelegate = self
        particularCell.configure(
            userName: dupPeople[indexPath.row].user.userName,
            userDP: dupPeople[indexPath.row].userDP)
        return particularCell
    }
}

extension SearchPeopleViewController: UISearchTextFieldDelegate, UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        if searchText.isEmpty {
            dupPeople = people
            return
        }

        let data = people.filter( {
            $0.user.userName.contains(searchText)
        })
        
        // MARK: SHOW THE SEARCHED RESULTS IS EMPTY
        if data.isEmpty {
            print("EMPTY")
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

extension SearchPeopleViewController: SearchPeopleVCDelegate {
    
    @objc func removeFromRecentSearches(_ sender: UIButton) {
        if let cell = sender.superview?.superview as? UITableViewCell,
           let indexPath = recentSearchTable.indexPath(for: cell) {
            
            dupPeople.remove(at: sender.tag)
            recentSearchTable.deleteRows(at: [indexPath], with: .fade)
        }
    }
}




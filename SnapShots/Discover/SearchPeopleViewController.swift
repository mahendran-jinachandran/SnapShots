//
//  SearchPeopleViewController.swift
//  SnapShots
//
//  Created by mahendran-14703 on 14/11/22.
//

import UIKit
import Lottie

class SearchPeopleViewController: UIViewController {
    
    var recents = ["Balaji","Mahi","Bala","Anbu","Deepak","Arka"]
    var copyRecents = ["Balaji","Mahi","Bala","Anbu","Deepak","Arka"]
    
    var searchExample = ["Search Music","Search Sport"]
    
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
        
        title = "Discover"
        searchBar = UISearchController(searchResultsController: nil)
        searchBar.searchBar.placeholder = "Discover people 🌎"
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

extension SearchPeopleViewController: UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return copyRecents.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let particularCell = tableView.dequeueReusableCell(withIdentifier: SearchTableViewCell.identifier, for: indexPath) as! SearchTableViewCell
        
        particularCell.userNameLabel.text = "User: \(copyRecents[indexPath.row])"
        particularCell.deletebutton.addTarget(self, action: #selector(removeFromRecentSearches), for: .touchUpInside)


         return particularCell
    }
    
    @objc func removeFromRecentSearches(_ sender: UIButton) {
        if let cell = sender.superview?.superview as? UITableViewCell,
           let indexPath = recentSearchTable.indexPath(for: cell) {
            
            copyRecents.remove(at: sender.tag)
            recentSearchTable.deleteRows(at: [indexPath], with: .fade)
        }
    }
}

extension SearchPeopleViewController: UISearchTextFieldDelegate, UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        if searchText.isEmpty {
            copyRecents = recents
            return
        }

        let data = recents.filter( {
            $0.contains(searchText)
        })
        
        copyRecents = data
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        copyRecents = recents
    }
}




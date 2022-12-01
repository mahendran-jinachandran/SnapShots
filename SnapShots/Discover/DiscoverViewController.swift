//
//  DiscoverViewController.swift
//  SnapShots
//
//  Created by mahendran-14703 on 25/11/22.
//

import UIKit

class DiscoverViewController: UIViewController {
    
    private var suggestionCV: UICollectionView!
    
    private lazy var suggestionLabel: UILabel = {
        let suggestionLabel = UILabel()
        suggestionLabel.translatesAutoresizingMaskIntoConstraints = false
        suggestionLabel.text = "People you might know"
        suggestionLabel.textColor = UIColor(named: "appTheme")
        return suggestionLabel
    }()
    
    private var searchBar: UISearchController!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Discover"
        searchBar = UISearchController(searchResultsController: nil)
        searchBar.searchBar.placeholder = "Discover people 🌎"
        navigationItem.hidesSearchBarWhenScrolling = false
        navigationItem.searchController = searchBar

        // Do any additional setup after loading the view.
        let suggestionCVLayout = UICollectionViewFlowLayout()
        suggestionCVLayout.scrollDirection = .horizontal
        
        suggestionCV = UICollectionView(frame: .zero, collectionViewLayout: suggestionCVLayout)
        suggestionCV.translatesAutoresizingMaskIntoConstraints = false
        suggestionCV.delegate = self
        suggestionCV.dataSource = self
        suggestionCV.showsHorizontalScrollIndicator = false
        suggestionCV.register(SuggestionCVCell.self, forCellWithReuseIdentifier: SuggestionCVCell.identifier)
        
        [suggestionLabel,suggestionCV].forEach {
            view.addSubview($0)
        }
        
        setSuggestionsConstraints()
        
    }
    
    func setSuggestionsConstraints() {
        NSLayoutConstraint.activate([
            
            suggestionLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor,constant: 2),
            suggestionLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor,constant: 8),
            suggestionLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor,constant: -8),
            suggestionLabel.heightAnchor.constraint(equalToConstant: 40),
            
            suggestionCV.topAnchor.constraint(equalTo: suggestionLabel.bottomAnchor,constant: 4),
            suggestionCV.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor,constant: 8),
            suggestionCV.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            suggestionCV.heightAnchor.constraint(equalToConstant: 230)
        ])
    }
}

extension DiscoverViewController: UICollectionViewDelegateFlowLayout,UICollectionViewDataSource {
    
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SuggestionCVCell.identifier, for: indexPath) as! SuggestionCVCell
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 170, height: 230)
    }
}

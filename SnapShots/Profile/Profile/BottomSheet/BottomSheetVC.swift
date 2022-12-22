//
//  BottomSheetVC.swift
//  SnapShots
//
//  Created by mahendran-14703 on 22/12/22.
//

import UIKit

class BottomSheetVC: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    var bottomSheetEntities: [BottomSheetDetails] = []
    
    private var buttContainer : UIView!
    
    private lazy var bottomSheetTable: UITableView = {
        let bottomSheetTable = UITableView(frame: .zero)
        bottomSheetTable.translatesAutoresizingMaskIntoConstraints = false
       return bottomSheetTable
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        view.backgroundColor = .clear
        setupTheEntities()
        setup()
        
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dismissBottomSheet)))
    }
    
    @objc private func dismissBottomSheet() {
        self.dismiss(animated: true)
    }
        
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let cellCount = bottomSheetTable.numberOfRows(inSection: 0)
        bottomSheetTable.heightAnchor.constraint(equalToConstant: CGFloat(cellCount) * 50)
            .isActive = true
    }
    
    func setup()
    {
        bottomSheetTable.register(BottomSheetsTableViewCell.self, forCellReuseIdentifier: BottomSheetsTableViewCell.identifier)
        bottomSheetTable.separatorStyle = .none
        bottomSheetTable.delegate = self
        bottomSheetTable.dataSource = self
        
        buttContainer = UIView()
        buttContainer.backgroundColor = .lightGray
        buttContainer.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(buttContainer)
        buttContainer.addSubview(bottomSheetTable)
        NSLayoutConstraint.activate([
            
            buttContainer.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            buttContainer.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            buttContainer.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            bottomSheetTable.leadingAnchor.constraint(equalTo: buttContainer.safeAreaLayoutGuide.leadingAnchor),
            bottomSheetTable.trailingAnchor.constraint(equalTo: buttContainer.safeAreaLayoutGuide.trailingAnchor),
            bottomSheetTable.bottomAnchor.constraint(equalTo: buttContainer.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            bottomSheetTable.topAnchor.constraint(equalTo: buttContainer.safeAreaLayoutGuide.topAnchor, constant: 16),
            bottomSheetTable.widthAnchor.constraint(equalTo: buttContainer.widthAnchor)
            
        ])
    }
    
    private func setupTheEntities() {
      
        bottomSheetEntities.append(contentsOf: [
            BottomSheetDetails(imageIcon: UIImage(systemName: "gear")!, entityName: "Settings"),
            BottomSheetDetails(imageIcon: UIImage(systemName: "archivebox.circle.fill")!, entityName: "Archives")
        ])

    }


    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return bottomSheetEntities.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: BottomSheetsTableViewCell.identifier, for: indexPath) as! BottomSheetsTableViewCell

        cell.configure(
            icon: bottomSheetEntities[indexPath.row].imageIcon,
            optionName: bottomSheetEntities[indexPath.row].entityName)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
}

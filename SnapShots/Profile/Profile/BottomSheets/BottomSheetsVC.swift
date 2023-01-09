//
//  BottomSheetsVC.swift
//  SnapShots
//
//  Created by mahendran-14703 on 08/01/23.
//

import UIKit

protocol BottomSheetsVCDelegate: AnyObject {
    func presentANewViewController(VCName: BottomSheetEntity)
}

class BottomSheetVC: UIViewController {
    
    private var bottomSheetEntities: [BottomSheetDetails] = []
    private var bottomContainer : UIView!
    weak var bottomSheetsDelegate: BottomSheetsVCDelegate?
    
    
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
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first
        
        if touch?.view == self.view {
            dismissBottomSheet()
        }
    }
    
    func setup()
    {
        bottomSheetTable.register(BottomSheetsTableViewCell.self, forCellReuseIdentifier: BottomSheetsTableViewCell.identifier)
        bottomSheetTable.separatorStyle = .none
        bottomSheetTable.bounces = false
        bottomSheetTable.delegate = self
        bottomSheetTable.dataSource = self
        
        bottomContainer = UIView()
        bottomContainer.layer.cornerRadius = 20
        bottomContainer.backgroundColor = UIColor(named: "BottomSheetBG")
        bottomContainer.translatesAutoresizingMaskIntoConstraints = false
        bottomContainer.isUserInteractionEnabled = true
        
        bottomContainer.addSubview(bottomSheetTable)
        view.addSubview(bottomContainer)
        
    
        NSLayoutConstraint.activate([
            
            bottomContainer.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            bottomContainer.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            bottomContainer.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            bottomSheetTable.leadingAnchor.constraint(equalTo: bottomContainer.safeAreaLayoutGuide.leadingAnchor),
            bottomSheetTable.trailingAnchor.constraint(equalTo: bottomContainer.safeAreaLayoutGuide.trailingAnchor),
            bottomSheetTable.bottomAnchor.constraint(equalTo: bottomContainer.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            bottomSheetTable.topAnchor.constraint(equalTo: bottomContainer.safeAreaLayoutGuide.topAnchor, constant: 16),
            bottomSheetTable.widthAnchor.constraint(equalTo: bottomContainer.widthAnchor)
            
        ])
    }
    
    private func setupTheEntities() {
        
        // MARK: CHANGE THE COLOURS OF THE ICON
        let settingsImage = UIImageView(image: UIImage(systemName: "gear")!.withRenderingMode(.alwaysTemplate))
        settingsImage.tintColor = UIColor(named: "appTheme")
      
        bottomSheetEntities.append(contentsOf: [
            BottomSheetDetails(imageIcon: settingsImage.image!, entityName: .settings),
            BottomSheetDetails(imageIcon: UIImage(systemName: "archivebox.circle.fill")!, entityName: .archives),
            BottomSheetDetails(imageIcon: UIImage(systemName: "nosign")!, entityName: .blockedUsers),
            BottomSheetDetails(imageIcon: UIImage(systemName: "bookmark")!, entityName: .saved)
        ])
    }
}

extension BottomSheetVC: UITableViewDelegate,UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        dismissBottomSheet()
        switch bottomSheetEntities[indexPath.row].entityName {
            case .settings:
                print("Settings")
            case .archives:
                print("Archive")
            case .blockedUsers:
                bottomSheetsDelegate?.presentANewViewController(VCName: .blockedUsers)
            case .saved:
                print("Saved")
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return bottomSheetEntities.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: BottomSheetsTableViewCell.identifier, for: indexPath) as! BottomSheetsTableViewCell

        cell.configure(
            icon: bottomSheetEntities[indexPath.row].imageIcon,
            optionName: bottomSheetEntities[indexPath.row].entityName.description)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
}


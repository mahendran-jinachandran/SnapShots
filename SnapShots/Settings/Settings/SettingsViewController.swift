//
//  SettingsViewController.swift
//  SnapShots
//
//  Created by mahendran-14703 on 17/11/22.
//

import UIKit

class SettingsViewController: UIViewController {

    private var logoutButton: UIButton = {
       let logoutButton = UIButton()
        logoutButton.setTitle("LOG OUT", for: .normal)
        logoutButton.backgroundColor = UIColor(named: "mainPage")
        logoutButton.setTitleColor(.systemBackground, for: .normal)
        logoutButton.translatesAutoresizingMaskIntoConstraints = false
        logoutButton.layer.cornerRadius = 5.0
        return logoutButton
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        title = "Settings"
        
        [logoutButton].forEach {
            view.addSubview($0)
        }
        
        
        setSettingsContratints()
        
        logoutButton.addTarget(self, action: #selector(startLogoutProcess), for: .touchUpInside)
        
    }
    
    
    // MARK: DISABLING ANIMATIONS WHEN POPING OUT
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        UIView.setAnimationsEnabled(false)
    }
    
    
    func setSettingsContratints() {
        NSLayoutConstraint.activate([
         
            logoutButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor,constant: 10),
            logoutButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor,constant: -10),
            logoutButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor,constant: -15),
            logoutButton.heightAnchor.constraint(equalToConstant: 50)
        
        ])
    }
    
    @objc func startLogoutProcess() {
        
        let logoutConfirmation = UIAlertController(title: "Confirm?", message: nil, preferredStyle: .alert)
        let logout = UIAlertAction(title: "Log out", style: .default) { _ in
            
            let loginViewController = LoginAssembler.assemble()
            self.navigationController?.pushViewController(loginViewController, animated: true)
            
            UserDefaults.standard.removeObject(forKey: "USER")
        }

        let cancel = UIAlertAction(title: "Cancel", style: .cancel)
     
        logoutConfirmation.addAction(cancel)
        logoutConfirmation.addAction(logout)
        
        self.present(logoutConfirmation, animated: true)
    }
}

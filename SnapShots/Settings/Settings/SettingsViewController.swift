//
//  SettingsViewController.swift
//  SnapShots
//
//  Created by mahendran-14703 on 17/11/22.
//

import UIKit

class SettingsViewController: UIViewController {
    
    private lazy var accountsView: UIView = {
        let accountsLabel = UILabel()
        accountsLabel.text = "Account"
        accountsLabel.font = UIFont.systemFont(ofSize: 18)
        accountsLabel.textColor = UIColor(named: "mainPage")
        accountsLabel.translatesAutoresizingMaskIntoConstraints = false
        accountsLabel.isUserInteractionEnabled = true
        accountsLabel.setContentHuggingPriority(.init(249), for: .horizontal)
        
        let accountsCell = generateCell(
            leftImage: UIImageView(image: UIImage(systemName: "gear")),
            label: accountsLabel,
            rightImage: UIImageView(image: UIImage(systemName: "chevron.right")))
        
        return accountsCell
    }()
    
    private lazy var securityView: UIView = {
        let accountsLabel = UILabel()
        accountsLabel.text = "Security"
        accountsLabel.font = UIFont.systemFont(ofSize: 18)
        accountsLabel.textColor = UIColor(named: "mainPage")
        accountsLabel.translatesAutoresizingMaskIntoConstraints = false
        accountsLabel.isUserInteractionEnabled = true
        accountsLabel.setContentHuggingPriority(.init(249), for: .horizontal)
        
        let accountsCell = generateCell(
            leftImage: UIImageView(image: UIImage(systemName: "checkmark.shield")),
            label: accountsLabel,
            rightImage: UIImageView(image: UIImage(systemName: "chevron.right")))
        
        return accountsCell
    }()
    
    private lazy var aboutView: UIView = {
        let accountsLabel = UILabel()
        accountsLabel.text = "About"
        accountsLabel.font = UIFont.systemFont(ofSize: 18)
        accountsLabel.textColor = UIColor(named: "mainPage")
        accountsLabel.translatesAutoresizingMaskIntoConstraints = false
        accountsLabel.isUserInteractionEnabled = true
        accountsLabel.setContentHuggingPriority(.init(249), for: .horizontal)
        
        let accountsCell = generateCell(
            leftImage: UIImageView(image: UIImage(systemName: "info.circle")),
            label: accountsLabel,
            rightImage: UIImageView(image: UIImage(systemName: "chevron.right")))
        
        return accountsCell
    }()
    

    private lazy var logoutButton: UIButton = {
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
        
        let appearance = UINavigationBarAppearance()
        appearance.backgroundColor = UIColor.systemBackground
    
        navigationItem.scrollEdgeAppearance = appearance

        title = "Settings"
        
        [accountsView,securityView,aboutView,logoutButton].forEach {
            view.addSubview($0)
        }
        
        setSettingsContratints()
        
        logoutButton.addTarget(self, action: #selector(startLogoutProcess), for: .touchUpInside)
        
        let accountsViewTap = UITapGestureRecognizer(target: self, action: #selector(openAccount))
        accountsView.addGestureRecognizer(accountsViewTap)
        
        let securityViewTap = UITapGestureRecognizer(target: self, action: #selector(openSecurity))
        securityView.addGestureRecognizer(securityViewTap)
        
        let aboutLabelTap = UITapGestureRecognizer(target: self, action: #selector(showAboutApp))
        aboutView.addGestureRecognizer(aboutLabelTap)
        
    }
    
    // MARK: DISABLING ANIMATIONS WHEN POPING OUT
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        UIView.setAnimationsEnabled(false)
    }
    
    func setSettingsContratints() {
        NSLayoutConstraint.activate([
            
            accountsView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor,constant: 10),
            accountsView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            accountsView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor,constant: -10),
            accountsView.heightAnchor.constraint(equalToConstant: 40),
            
            securityView.topAnchor.constraint(equalTo: accountsView.bottomAnchor),
            securityView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            securityView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor,constant: -10),
            securityView.heightAnchor.constraint(equalToConstant: 40),
            
            aboutView.topAnchor.constraint(equalTo: securityView.bottomAnchor),
            aboutView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            aboutView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor,constant: -10),
            aboutView.heightAnchor.constraint(equalToConstant: 40),
            
            logoutButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor,constant: 10),
            logoutButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor,constant: -10),
            logoutButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor,constant: -15),
            logoutButton.heightAnchor.constraint(equalToConstant: 50)
    
        ])
    }
    
    @objc func startLogoutProcess() {
        
        let logoutConfirmation = UIAlertController(title: "Confirm?", message: nil, preferredStyle: .alert)
        let logout = UIAlertAction(title: "Log out", style: .default) { _ in
            
            UserDefaults.standard.removeObject(forKey: Constants.loggedUserFormat)
            UserDefaults.standard.synchronize()
            
            let loginViewController = LoginVC()
            let loginController = LoginControls()
            
            loginController.setView(loginViewController)
            loginViewController.setController(loginController)
           
            self.view.window?.windowScene?.keyWindow?.rootViewController = UINavigationController(rootViewController: loginViewController)
        }

        let cancel = UIAlertAction(title: "Cancel", style: .cancel)
     
        logoutConfirmation.addAction(cancel)
        logoutConfirmation.addAction(logout)
        
        self.present(logoutConfirmation, animated: true)
    }
    
    @objc func showAboutApp() {
        navigationController?.pushViewController(AboutViewController(), animated: false)
    }
    
    @objc func openSecurity() {
        navigationController?.pushViewController(SecurityViewController(), animated: false)
    }
    
    

    @objc func openAccount(sender: UITapGestureRecognizer) {
        navigationController?.pushViewController(AccountViewController(), animated: false)
        if(sender.view == accountsView) {
            print("Account View Selected")
        } else if(sender.view == securityView) {
            print("Security View Selected")
        }
    }
}


//class CustomUILabel: UILabel {
//
//    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//        super.touchesBegan(touches, with: event)
//        self.backgroundColor = .gray
//    }
//
//    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
//        super.touchesEnded(touches, with: event)
//        self.backgroundColor = .white
//    }
//
//    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
//        super.touchesCancelled(touches, with: event)
//
//        self.backgroundColor = .white
//    }
//}

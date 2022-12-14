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
        accountsLabel.font = UIFont.systemFont(ofSize: 20)
        accountsLabel.textColor = UIColor(named: "appTheme")
        accountsLabel.translatesAutoresizingMaskIntoConstraints = false
        accountsLabel.isUserInteractionEnabled = true
        accountsLabel.setContentHuggingPriority(.init(249), for: .horizontal)
        
        let accountsCell = generateCell(
            leftImage: UIImageView(image: UIImage(systemName: "person.circle")),
            label: accountsLabel,
            rightImage: UIImageView(image: UIImage(systemName: "chevron.right")))
        
        return accountsCell
    }()
    
    private lazy var securityView: UIView = {
        let accountsLabel = UILabel()
        accountsLabel.text = "Security"
        accountsLabel.font = UIFont.systemFont(ofSize: 20)
        accountsLabel.textColor = UIColor(named: "appTheme")
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
        accountsLabel.font = UIFont.systemFont(ofSize: 20)
        accountsLabel.textColor = UIColor(named: "appTheme")
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
        logoutButton.backgroundColor = UIColor(named: "appTheme")
        logoutButton.setTitleColor(.systemBackground, for: .normal)
        logoutButton.translatesAutoresizingMaskIntoConstraints = false
        logoutButton.layer.cornerRadius = 5.0
        return logoutButton
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    
        setupNavigationItems()
        setupTintColors()
        setupTapGestures()
        setSettingsContraints()
    }
    
    private func setupNavigationItems() {
        view.backgroundColor = .systemBackground
        navigationItem.title = "Settings"
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    }
    
    private func setupTintColors() {
        accountsView.tintColor = UIColor(named: "appTheme")
        securityView.tintColor = UIColor(named: "appTheme")
        aboutView.tintColor = UIColor(named: "appTheme")
    }
    
    private func setupTapGestures() {
        let accountsViewTap = UITapGestureRecognizer(target: self, action: #selector(openAccount))
        accountsView.addGestureRecognizer(accountsViewTap)
        
        let securityViewTap = UITapGestureRecognizer(target: self, action: #selector(openSecurity))
        securityView.addGestureRecognizer(securityViewTap)
        
        let aboutLabelTap = UITapGestureRecognizer(target: self, action: #selector(showAboutApp))
        aboutView.addGestureRecognizer(aboutLabelTap)
        
        logoutButton.addTarget(self, action: #selector(startLogoutProcess), for: .touchUpInside)
    }
    
    private func setSettingsContraints() {
        
        [accountsView,securityView,aboutView,logoutButton].forEach {
            view.addSubview($0)
        }
        
        NSLayoutConstraint.activate([
            
            accountsView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor,constant: 5),
            accountsView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            accountsView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor,constant: -10),
            accountsView.heightAnchor.constraint(equalToConstant: 35),
            
            securityView.topAnchor.constraint(equalTo: accountsView.bottomAnchor,constant: 5),
            securityView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            securityView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor,constant: -10),
            securityView.heightAnchor.constraint(equalToConstant: 35),
            
            aboutView.topAnchor.constraint(equalTo: securityView.bottomAnchor,constant: 5),
            aboutView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            aboutView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor,constant: -10),
            aboutView.heightAnchor.constraint(equalToConstant: 35),
            
            logoutButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor,constant: 10),
            logoutButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor,constant: -10),
            logoutButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor,constant: -15),
            logoutButton.heightAnchor.constraint(equalToConstant: 50)
    
        ])
    }
    
    @objc private func startLogoutProcess() {
        
        let logoutConfirmation = UIAlertController(title: "Confirm?", message: nil, preferredStyle: .alert)
     
        logoutConfirmation.addAction(
            UIAlertAction(title: "Cancel", style: .cancel)
        )
        
        logoutConfirmation.addAction(
            UIAlertAction(title: "Log out", style: .default) { _ in
                self.executeLogoutProcess()
            }
        )
        
        self.present(logoutConfirmation, animated: true)
    }
    
    @objc private func showAboutApp(sender: UITapGestureRecognizer) {
        navigationController?.pushViewController(AboutViewController(), animated: true)
    }
    
    @objc private func openSecurity(sender: UITapGestureRecognizer) {
        navigationController?.pushViewController(SecurityViewController(), animated: true)
    }
    
    @objc private func openAccount(sender: UITapGestureRecognizer) {
        
        let accountControls = AccountControls()
        let accountVC = AccountVC(accountControls: accountControls)
        
        navigationController?.pushViewController(accountVC, animated: true)
    }
    
    private func executeLogoutProcess() {
        UserDefaults.standard.removeObject(forKey: Constants.loggedUserFormat)
        UserDefaults.standard.synchronize()
        
        let loginViewController = LoginVC()
        let loginController = LoginControls()
        
        loginController.setView(loginViewController)
        loginViewController.setController(loginController)
       
        self.view.window?.windowScene?.keyWindow?.rootViewController = UINavigationController(rootViewController: loginViewController)
    }
}


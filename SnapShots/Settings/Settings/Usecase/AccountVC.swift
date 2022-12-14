//
//  AccountViewController.swift
//  SnapShots
//
//  Created by mahendran-14703 on 20/11/22.
//

import UIKit

class AccountVC: UIViewController {
    
    private var accountControls: AccountControlsProtocol
    init(accountControls: AccountControlsProtocol) {
        self.accountControls = accountControls
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private lazy var personalInformationView: UIView = {
        let accountsLabel = UILabel()
        accountsLabel.text = "Personal Information"
        accountsLabel.font = UIFont.systemFont(ofSize: 18)
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
    
    private lazy var deleteAccount: UIButton = {
        let deleteAccount = CustomButton(selectColour: .red, deselectColour: .red)
        deleteAccount.setTitle("Delete Account", for: .normal)
        deleteAccount.backgroundColor = .red
        deleteAccount.setTitleColor(.systemBackground, for: .normal)
        deleteAccount.translatesAutoresizingMaskIntoConstraints = false
        deleteAccount.layer.cornerRadius = 5.0
        return deleteAccount
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.

        setupNavigationItems()
        setupTapGestures()
        setupTintColours()
        setConstraints()
    }
    
    func setupNavigationItems() {
        title = "Account"
        view.backgroundColor = .systemBackground
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    }
    
    func setupTintColours() {
        personalInformationView.tintColor = UIColor(named: "appTheme")
    }
    
    func setupTapGestures() {
        let personalInformationTap = UITapGestureRecognizer(target: self, action: #selector(showPersonalInformation))
        personalInformationView.addGestureRecognizer(personalInformationTap)
        
        deleteAccount.addTarget(self, action: #selector(executeDeleteAccountProcess), for: .touchUpInside)
    }
    
    func setConstraints() {
        
        [personalInformationView,deleteAccount].forEach {
            view.addSubview($0)
        }
        
        NSLayoutConstraint.activate([
            personalInformationView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor,constant: 10),
            personalInformationView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            personalInformationView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor,constant: -10),
            personalInformationView.heightAnchor.constraint(equalToConstant: 40),
            
            deleteAccount.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor,constant: 10),
            deleteAccount.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor,constant: -10),
            deleteAccount.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor,constant: -15),
            deleteAccount.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    @objc func executeDeleteAccountProcess() {
        
        let deleteAccountAlert = UIAlertController(title: "Delete Account?", message: "Account cannot be retrieved.", preferredStyle: .alert)

        deleteAccountAlert.addAction(UIAlertAction(title: "Delete", style: .destructive){ _ in
           
            if !self.accountControls.deleteAccount() {
                self.showToast(message: Constants.toastFailureStatus)
                return
            }
            
            self.executeLogoutProcess()
        })
        
        deleteAccountAlert.addAction(UIAlertAction(title: "Cancel", style: .default))
        present(deleteAccountAlert, animated: true)
        
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
    
    @objc func showPersonalInformation() {
        navigationController?.pushViewController(PersonalInformationVC(accountControls: accountControls), animated: true)
    }
}

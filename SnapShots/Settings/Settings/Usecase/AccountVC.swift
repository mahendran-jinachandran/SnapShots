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

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        view.backgroundColor = .systemBackground
        setupNavigationItems()
        setupTapGestures()
        setupTintColours()
        setConstraints()
    }
    
    func setupNavigationItems() {
        title = "Account"
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    }
    
    func setupTintColours() {
        personalInformationView.tintColor = UIColor(named: "appTheme")
    }
    
    func setupTapGestures() {
        let personalInformationTap = UITapGestureRecognizer(target: self, action: #selector(showPersonalInformation))
        personalInformationView.addGestureRecognizer(personalInformationTap)
    }
    
    func setConstraints() {
        
        [personalInformationView].forEach {
            view.addSubview($0)
        }
        
        NSLayoutConstraint.activate([
            personalInformationView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor,constant: 10),
            personalInformationView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            personalInformationView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor,constant: -10),
            personalInformationView.heightAnchor.constraint(equalToConstant: 40)
        ])
    }
    
    @objc func showPersonalInformation() {
        navigationController?.pushViewController(PersonalInformationVC(accountControls: accountControls), animated: true)
    }
}

//
//  SecurityViewController.swift
//  SnapShots
//
//  Created by mahendran-14703 on 20/11/22.
//

import UIKit

class SecurityViewController: UIViewController {
    
    private lazy var passwordView: UIView = {
        let accountsLabel = UILabel()
        accountsLabel.text = "Password"
        accountsLabel.font = UIFont.systemFont(ofSize: 18)
        accountsLabel.textColor = UIColor(named: "appTheme")
        accountsLabel.translatesAutoresizingMaskIntoConstraints = false
        accountsLabel.isUserInteractionEnabled = true
        accountsLabel.setContentHuggingPriority(.init(249), for: .horizontal)
        
        let accountsCell = generateCell(
            leftImage: UIImageView(image: UIImage(systemName: "checkerboard.shield")),
            label: accountsLabel,
            rightImage: UIImageView(image: UIImage(systemName: "chevron.right")))
        
        return accountsCell
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        title = "Security"
        view.backgroundColor = .systemBackground
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        
        setConstraints()
        setupTapGestures()
        setupTintColors()
    }
    
    func setupTintColors() {
        passwordView.tintColor = UIColor(named: "appTheme")
    }
    
    @objc func goBack() {
        navigationController?.popViewController(animated: true)
    }
    
    func setupTapGestures() {
        let passwordLabelTap = UITapGestureRecognizer(target: self, action: #selector(startChangePasswordProcess))
        passwordView.addGestureRecognizer(passwordLabelTap)
    }
    
    func setConstraints() {
        
        [passwordView].forEach {
            view.addSubview($0)
        }
        
        NSLayoutConstraint.activate([
            
            passwordView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor,constant: 10),
            passwordView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            passwordView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor,constant: -10),
            passwordView.heightAnchor.constraint(equalToConstant: 40)
        
        ])
    }
    
   @objc func startChangePasswordProcess() {
      // presentDetail(ChangePasswordViewController())
    }
}

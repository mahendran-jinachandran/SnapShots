//
//  AccountViewController.swift
//  SnapShots
//
//  Created by mahendran-14703 on 20/11/22.
//

import UIKit

class AccountVC: UIViewController {
    
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
        
        [personalInformationView].forEach {
            view.addSubview($0)
        }
        
        setConstraints()
        
        let personalInformationTap = UITapGestureRecognizer(target: self, action: #selector(showPersonalInformation))
        personalInformationView.addGestureRecognizer(personalInformationTap)
    }
    
    func setConstraints() {
        
        NSLayoutConstraint.activate([
            personalInformationView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor,constant: 10),
            personalInformationView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            personalInformationView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor,constant: -10),
            personalInformationView.heightAnchor.constraint(equalToConstant: 40)
        ])
    }
    
    @objc func showPersonalInformation() {
        navigationController?.pushViewController(PersonalInformationVC(), animated: false)
    }
    
    
    

}

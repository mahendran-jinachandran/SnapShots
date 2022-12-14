//
//  AboutViewController.swift
//  SnapShots
//
//  Created by mahendran-14703 on 20/11/22.
//

import UIKit
import SafariServices

class AboutViewController: UIViewController, UITextFieldDelegate {
    
    private lazy var privacyView: UIView = {
        let privacyLabel = UILabel()
        privacyLabel.text = "Privacy Policy"
        privacyLabel.font = UIFont.systemFont(ofSize: 18)
        privacyLabel.textColor = UIColor(named: "appTheme")
        privacyLabel.translatesAutoresizingMaskIntoConstraints = false
        privacyLabel.isUserInteractionEnabled = true
        privacyLabel.setContentHuggingPriority(.init(249), for: .horizontal)
        
        let privacyView = generateCell(
            leftImage: UIImageView(image: UIImage(systemName: "info.circle")),
            label: privacyLabel,
            rightImage: UIImageView(image: UIImage(systemName: "chevron.right")))
        
        return privacyView
    }()
    
    private lazy var termsView: UIView = {
        let privacyLabel = UILabel()
        privacyLabel.text = "Terms of Use"
        privacyLabel.font = UIFont.systemFont(ofSize: 18)
        privacyLabel.textColor = UIColor(named: "appTheme")
        privacyLabel.translatesAutoresizingMaskIntoConstraints = false
        privacyLabel.isUserInteractionEnabled = true
        privacyLabel.setContentHuggingPriority(.init(249), for: .horizontal)
        
        let privacyView = generateCell(
            leftImage: UIImageView(image: UIImage(systemName: "info.circle")),
            label: privacyLabel,
            rightImage: UIImageView(image: UIImage(systemName: "chevron.right")))
        
        return privacyView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
    
        setupNavigationItems()
        setupTintColors()
        setupTapGestures()
        setAboutConstraints()
     }
    
    private func setupNavigationItems() {
        title = "About"
        view.backgroundColor = .systemBackground
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    }
    
    private func setupTintColors() {
        privacyView.tintColor = UIColor(named: "appTheme")
        termsView.tintColor = UIColor(named: "appTheme")
    }
    
    private func setupTapGestures() {
        let privacyPolicyTap = UITapGestureRecognizer(target: self, action: #selector(showPrivacyPolicies))
        privacyView.addGestureRecognizer(privacyPolicyTap)
    }
    
    private func setAboutConstraints() {
        
        [privacyView,termsView].forEach {
            view.addSubview($0)
        }
        
        NSLayoutConstraint.activate([
            privacyView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor,constant: 10),
            privacyView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            privacyView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor,constant: -10),
            privacyView.heightAnchor.constraint(equalToConstant: 40),
            
            termsView.topAnchor.constraint(equalTo: privacyView.bottomAnchor),
            termsView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            termsView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor,constant: -10),
            termsView.heightAnchor.constraint(equalToConstant: 40)
            
        ])
    }
    
    @objc private func showPrivacyPolicies() {
        guard let url = URL(string: "https://www.termsfeed.com/live/04e5a598-6985-4e03-a896-31106dc8edbc") else {
            return
        }
        
        present(
            SFSafariViewController(url: url),
            animated: true
        )
    }
}



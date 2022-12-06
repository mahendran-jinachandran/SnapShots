//
//  CommentsVC.swift
//  SnapShots
//
//  Created by mahendran-14703 on 24/11/22.
//

import UIKit

class CommentsVC: UIViewController {
    
    private lazy var commentsTable: UITableView = {
        var comments = UITableView()
        comments.translatesAutoresizingMaskIntoConstraints = false
        comments.register(CommentsCustomCell.self, forCellReuseIdentifier: CommentsCustomCell.identifier)
        comments.separatorStyle = .none
        comments.bounces = false
        return comments
    }()
    
    private lazy var addComments: UITextField = {
        var addComments = UITextField()
        addComments.placeholder = "Add Comment"
        addComments.clearsOnBeginEditing = true
        addComments.translatesAutoresizingMaskIntoConstraints = false
        addComments.backgroundColor = .systemBackground
        addComments.layer.borderColor = UIColor.gray.cgColor
        addComments.layer.borderWidth = 2
        addComments.layer.cornerRadius = 20
        addComments.textColor = UIColor(named: "appTheme")
        addComments.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 0))
        addComments.leftViewMode = .always
        return addComments
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        view.keyboardLayoutGuide.followsUndockedKeyboard = true
        view.backgroundColor = .systemBackground
        navigationController?.navigationBar.tintColor = UIColor(named: "appTheme")
        title = "Comments"
        
        commentsTable.delegate = self
        commentsTable.dataSource = self
        setupConstraints()

    }
    
    func setupConstraints() {
        
        [commentsTable,addComments].forEach {
            view.addSubview($0)
        }
    
        NSLayoutConstraint.activate([
            
            addComments.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor,constant: 8),
            addComments.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor,constant: -8),
            addComments.heightAnchor.constraint(equalToConstant: 50),
            
            commentsTable.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor,constant: 10),
            commentsTable.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor,constant: 8),
            commentsTable.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor,constant: -8),
            commentsTable.bottomAnchor.constraint(equalTo: addComments.topAnchor)
        ])
        
        let textFieldOnKeyboard = view.keyboardLayoutGuide.topAnchor.constraint(equalTo: addComments.bottomAnchor)
        view.keyboardLayoutGuide.setConstraints([textFieldOnKeyboard], activeWhenAwayFrom: .top)
    }
}

extension CommentsVC: UITableViewDelegate,UITableViewDataSource {
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 6
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CommentsCustomCell.identifier, for: indexPath) as! CommentsCustomCell
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

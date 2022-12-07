//
//  CommentsVC.swift
//  SnapShots
//
//  Created by mahendran-14703 on 24/11/22.
//

import UIKit

class CommentsVC: UIViewController {
    
    private lazy var commentDetails: [(userDP: UIImage,username: String,comment:String)] = []
    private var postUserID: Int
    private var postID: Int
    private var commentsControls: CommentsControlsProtocol
    
    init(commentsControls: CommentsControlsProtocol,postUserID: Int,postID: Int) {
        self.commentsControls = commentsControls
        self.postUserID = postUserID
        self.postID = postID
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private lazy var commentsTable: UITableView = {
        var comments = UITableView()
        comments.translatesAutoresizingMaskIntoConstraints = false
        comments.register(CommentsCustomCell.self, forCellReuseIdentifier: CommentsCustomCell.identifier)
        comments.separatorStyle = .none
        comments.bounces = false
        return comments
    }()
    
    private lazy var addCommentTextField: UITextField = {
        var addComments = UITextField()
        addComments.placeholder = "Add Comment"
        addComments.clearsOnBeginEditing = true
        addComments.translatesAutoresizingMaskIntoConstraints = false
        addComments.backgroundColor = .systemBackground
        addComments.layer.borderColor = UIColor.gray.cgColor
        addComments.layer.borderWidth = 2
        addComments.layer.cornerRadius = 20
        addComments.textColor = UIColor(named: "appTheme")
        addComments.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 20, height: 0))
        addComments.leftViewMode = .always
        return addComments
    }()
    
    private lazy var emptyCommentsLabel: UILabel = {
        let emptyComments = UILabel()
        emptyComments.text = "No Comments yet. Be the first."
        emptyComments.translatesAutoresizingMaskIntoConstraints = false
        emptyComments.font = UIFont.boldSystemFont(ofSize: 25)
        emptyComments.numberOfLines = 2
        emptyComments.textAlignment = .center
        emptyComments.textColor = .gray
        return emptyComments
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.keyboardLayoutGuide.followsUndockedKeyboard = true
        view.backgroundColor = .systemBackground
        navigationController?.navigationBar.tintColor = UIColor(named: "appTheme")
        title = "Comments"
        

        addCommentTextField.delegate = self
        setupCommentsTable()
    }
    
    func setupCommentsTable() {
        commentsTable.delegate = self
        commentsTable.dataSource = self
        
        commentDetails = commentsControls.getAllComments(postUserID: postUserID, postID: postID)
        if commentDetails.isEmpty {
            setupNoCommentsConstraints()
            return
        } else {
            setupConstraints()
        }
    }
    
    func setupConstraints() {
        
        [commentsTable,addCommentTextField].forEach {
            view.addSubview($0)
        }
    
        NSLayoutConstraint.activate([
            
            addCommentTextField.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor,constant: 8),
            addCommentTextField.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor,constant: -8),
            addCommentTextField.heightAnchor.constraint(equalToConstant: 50),
            
            commentsTable.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor,constant: 10),
            commentsTable.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor,constant: 8),
            commentsTable.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor,constant: -8),
            commentsTable.bottomAnchor.constraint(equalTo: addCommentTextField.topAnchor)
        ])
        
        let textFieldOnKeyboard = view.keyboardLayoutGuide.topAnchor.constraint(equalTo: addCommentTextField.bottomAnchor,constant: 10)
        view.keyboardLayoutGuide.setConstraints([textFieldOnKeyboard], activeWhenAwayFrom: .top)
    }
    
    func setupNoCommentsConstraints() {
        [emptyCommentsLabel,addCommentTextField].forEach {
            view.addSubview($0)
        }
        
        NSLayoutConstraint.activate([
            
            addCommentTextField.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor,constant: 8),
            addCommentTextField.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor,constant: -8),
            addCommentTextField.heightAnchor.constraint(equalToConstant: 50),
            
            emptyCommentsLabel.bottomAnchor.constraint(equalTo: addCommentTextField.topAnchor),
            emptyCommentsLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            emptyCommentsLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            emptyCommentsLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
        ])
        
        let textFieldOnKeyboard = view.keyboardLayoutGuide.topAnchor.constraint(equalTo: addCommentTextField.bottomAnchor,constant: 10)
        view.keyboardLayoutGuide.setConstraints([textFieldOnKeyboard], activeWhenAwayFrom: .top)
    }
}

extension CommentsVC: UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate {
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return commentDetails.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CommentsCustomCell.identifier, for: indexPath) as! CommentsCustomCell
        
        cell.configure(
            userDP: commentDetails[indexPath.row].userDP,
            username: commentDetails[indexPath.row].username,
            comment: commentDetails[indexPath.row].comment)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        
        if !textField.text!.isEmpty {
            navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Add", style: .plain, target: self, action: #selector(addComment))
        } else {
            navigationItem.rightBarButtonItem = nil
        }
    }
    
    @objc func addComment() {
        commentsControls.addComment(postUserID: postUserID, postID: postID, comment: addCommentTextField.text!)
        
        commentDetails = commentsControls.getAllComments(postUserID: postUserID, postID: postID)
        addCommentTextField.text = nil
        setupConstraints()
        commentsTable.reloadData()
        
    }
}

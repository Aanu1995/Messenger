//
// ConversationViewController.swift
//  Messenger
//
//  Created by user on 09/04/2021.
//

import UIKit
import JGProgressHUD

class ConversationViewController: UIViewController {
    // MARK: Properties
    
    private let tableView: UITableView = {
        let table = UITableView()
        table.isHidden = true
        table.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return table
    }()
    
    private let noChatsLabel: UILabel = {
        let label = UILabel()
        label.text = "No Conversations!"
        label.textColor = .gray
        label.font = .systemFont(ofSize: 21, weight: .medium)
        return label
    }()
    
    private let loadingView: JGProgressHUD = {
        let loadingView = JGProgressHUD()
        loadingView.textLabel.text = "Logging In"
        return loadingView
    }()
    
    // MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        fetchConversations()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        checkIfUserIsLoggedIn()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
        noChatsLabel.center = view.center
    }
    
    // MARK: Methods
    
    private func configureUI() {
        view.backgroundColor = .systemBackground
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .compose, target: self, action: #selector(didTapCompose))
        
        view.addSubview(tableView)
        view.addSubview(noChatsLabel)
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    private func checkIfUserIsLoggedIn(){
        AuthManager.shared.getUserDataFromCache() // retrieve data from cache if available
        if !AuthManager.shared.isSignedIn {
            let navC = UINavigationController(rootViewController: LoginViewController())
            navC.modalPresentationStyle = .fullScreen
            navC.navigationBar.prefersLargeTitles = true
            navC.navigationItem.largeTitleDisplayMode = .always
            present(navC, animated: false)
        }
    }
    
    private func showLoading(isLoading: Bool) {
        if isLoading {
            loadingView.show(in: view, animated: true)
        } else {
            loadingView.dismiss(animated: true)
        }
        noChatsLabel.isHidden = !isLoading
    }
    
    private func fetchConversations(){
        tableView.isHidden = false
    }
    
    @objc private func didTapCompose(){
        let vc = NewConversationViewController()
        vc.title = "New Conversation"
        present(UINavigationController(rootViewController: vc), animated: true)
    }
}

// MARK: TableView

extension ConversationViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = "Foo"
        cell.accessoryType = .disclosureIndicator
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let vc = ChatViewController()
        vc.title = "Rufus"
        vc.navigationItem.largeTitleDisplayMode = .never
        navigationController?.pushViewController(vc, animated: true)
    }
}


//
// ConversationViewController.swift
//  Messenger
//
//  Created by user on 09/04/2021.
//

import UIKit
import JGProgressHUD

class ConversationViewController: UIViewController, Dialog {
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
    
    var chats: [Conversation] = []
    
    // MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
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
        fetchConversations()
    }
    
    private func showLoading(isLoading: Bool) {
        if isLoading {
            loadingView.show(in: view, animated: true)
        } else {
            loadingView.dismiss(animated: true)
        }
        noChatsLabel.isHidden = true
        tableView.isHidden = isLoading
    }
    
    private func fetchConversations(){
        showLoading(isLoading: true)
        DatabaseManager.shared.getAllConversations(for: AuthManager.shared.currentUser) { [weak self] result in
            guard let strongSelf = self else { return }
            DispatchQueue.main.async {
                strongSelf.showLoading(isLoading: false)
                switch result {
                case .success(let chats):
                    strongSelf.chats = chats
                    strongSelf.tableView.reloadData()
                    break
                case .failure(let error):
                    if strongSelf.chats.isEmpty {
                        strongSelf.present(strongSelf.showErrorDialog(message: error.localizedDescription), animated: true)
                    }
                }
            }
        }
    }
    
    private func createNewChat(with user: ChatAppUser){
        let vc = ChatViewController(receiver: user, sender: AuthManager.shared.currentUser, id: nil)
        vc.navigationItem.largeTitleDisplayMode = .never
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc private func didTapCompose(){
        let vc = NewConversationViewController()
        vc.title = "New Conversation"
        vc.newUserSelected = { [weak self] newUser in
            self?.createNewChat(with: newUser)
        }
        present(UINavigationController(rootViewController: vc), animated: true)
    }
}

// MARK: TableView

extension ConversationViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return chats.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = chats[indexPath.row].lastMessage.message
        cell.accessoryType = .disclosureIndicator
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let vc = ChatViewController(receiver: AuthManager.shared.currentUser, sender: AuthManager.shared.currentUser, id: nil)
        vc.navigationItem.largeTitleDisplayMode = .never
        navigationController?.pushViewController(vc, animated: true)
    }
}


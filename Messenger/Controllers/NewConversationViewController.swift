//
//  NewConversationViewController.swift
//  Messenger
//
//  Created by user on 14/04/2021.
//

import UIKit

class NewConversationViewController: UIViewController, Dialog {
    
    // MARK: Properties
    private var users: [ChatAppUser] = []
    private var filteredUsers: [ChatAppUser] = []
    
    let searchController: UISearchController = {
        let vc = UISearchController()
        vc.obscuresBackgroundDuringPresentation = false
        vc.definesPresentationContext = true
        vc.searchBar.placeholder = "Search for Users"
        return vc
    }()
    
    let tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.register(UserTableViewCell.self, forCellReuseIdentifier: UserTableViewCell.identifier)
        tableView.separatorStyle = .none
        return tableView
    }()
    
    private let noChatsLabel: UILabel = {
        let label = UILabel()
        label.text = "No Users"
        label.textColor = .gray
        label.font = .systemFont(ofSize: 21, weight: .medium)
        return label
    }()
    
    private let loadingView: UIActivityIndicatorView = {
        let loadingView = UIActivityIndicatorView()
        loadingView.hidesWhenStopped = true
        return loadingView
    }()
    
    // MARK: LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        fetchAllUsers()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
        noChatsLabel.center = view.center
        loadingView.center = view.center
    }
    
    private func configureUI(){
        view.backgroundColor = .systemBackground
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(close))
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        searchController.searchResultsUpdater = self
        view.addSubview(tableView)
        view.addSubview(noChatsLabel)
        view.addSubview(loadingView)
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    private func fetchAllUsers(){
        showLoading(isLoading: true)
        DatabaseManager.shared.getAllUsers { [weak self] result in
            guard let strongSelf = self else {
                return
            }
            DispatchQueue.main.async {
                strongSelf.showLoading(isLoading: false)
                switch result{
                case .success(let users):
                    if users.isEmpty{
                        strongSelf.tableView.isHidden = true
                        return
                    }
                    strongSelf.noChatsLabel.isHidden = true
                    strongSelf.users = users
                    strongSelf.filteredUsers = users
                    strongSelf.tableView.reloadData()
                    break
                case .failure(let error):
                    strongSelf.present(strongSelf.showErrorDialog(message: error.localizedDescription), animated: true)
                }
            }
        }
    }
    
    private func showLoading(isLoading: Bool) {
        if isLoading {
            loadingView.startAnimating()
        } else {
            loadingView.stopAnimating()
        }
        noChatsLabel.isHidden = isLoading
        tableView.isHidden = isLoading
    }
    
    @objc func close (){
        dismiss(animated: true)
    }
    
    
    private func fetchUsers (){
        tableView.isHidden = true
    }
    
}

// MARK: UISeachResultsUpdating

extension NewConversationViewController: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        guard let query = searchController.searchBar.text, !query.trimmingCharacters(in: .whitespaces).isEmpty else {
            filteredUsers = users
            tableView.reloadData()
            return
        }
        let newFilteredUsers = users.filter { $0.firstName.lowercased().contains(query.lowercased()) || $0.lastName.lowercased().contains(query.lowercased())}
        filteredUsers = newFilteredUsers
        tableView.reloadData()
    }
}

extension NewConversationViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredUsers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: UserTableViewCell.identifier, for: indexPath) as? UserTableViewCell else {
            return UITableViewCell()
        }
       
        let user = filteredUsers[indexPath.row]
        let viewModel = UserViewModel(fullName: user.fullName, photoURL: URL(string: user.photoURL))
        cell.configure(with: viewModel)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
}

//
//  NewConversationViewController.swift
//  Messenger
//
//  Created by user on 14/04/2021.
//

import UIKit
import JGProgressHUD

class NewConversationViewController: UIViewController{
    
    // MARK: Properties
    
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
        return tableView
    }()
    
    private let noChatsLabel: UILabel = {
        let label = UILabel()
        label.text = "No Users"
        label.textColor = .gray
        label.font = .systemFont(ofSize: 21, weight: .medium)
        return label
    }()
    
    private let loadingView: JGProgressHUD = {
        let loadingView = JGProgressHUD()
        loadingView.textLabel.text = "Logging In"
        return loadingView
    }()
    
    // MARK: LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
        noChatsLabel.center = view.center
    }
    
    private func configureUI(){
        view.backgroundColor = .systemBackground
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(close))
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        searchController.searchResultsUpdater = self
        view.addSubview(tableView)
        view.addSubview(noChatsLabel)
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    private func showLoading(isLoading: Bool) {
        if isLoading {
            loadingView.show(in: view, animated: true)
        } else {
            loadingView.dismiss(animated: true)
        }
        noChatsLabel.isHidden = !isLoading
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
        //
    }
}

extension NewConversationViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = "Welcome to Switzerland"
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        print("Hello")
    }
}

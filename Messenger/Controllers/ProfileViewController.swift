//
//  ProfileViewController.swift
//  Messenger
//
//  Created by user on 09/04/2021.
//

import UIKit

class ProfileViewController: UIViewController, Dialog {
    
    // MARK: Properties
    let data = ["Sign Out"]
    
    // MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    // MARK: Methods
    
    private func configureUI() {
        view.backgroundColor = .systemBackground
    }
    
    private func signOut(){
        let alert = UIAlertController(title: "LOG OUT", message: "Are you sure you want to sign out?", preferredStyle: .actionSheet)
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        alert.addAction(UIAlertAction(title: "Sign Out", style: .destructive, handler: { [weak self] _ in
            guard let strongSelf = self else { return }
            
            AuthManager.shared.signOut { error in
                guard error == nil else {
                    strongSelf.present(strongSelf.showErrorDialog(message: "Failed to sign out"), animated: true)
                    return
                }
                
                let vc = UINavigationController(rootViewController: LoginViewController())
                vc.navigationItem.largeTitleDisplayMode = .always
                vc.navigationBar.prefersLargeTitles = true
                vc.modalPresentationStyle = .fullScreen
                strongSelf.present(vc, animated: true)
                strongSelf.tabBarController?.selectedIndex = 0
            }
        }))
        present(alert, animated: true)
    }
}

// MARK: - TableView

extension ProfileViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = data[indexPath.row]
        cell.textLabel?.textColor = .systemRed
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if indexPath.row == 0 {
            signOut()
        }
    }
}

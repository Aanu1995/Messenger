//
//  ProfileViewController.swift
//  Messenger
//
//  Created by user on 09/04/2021.
//

import UIKit
import SDWebImage

class ProfileViewController: UIViewController, Dialog {
    
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: Properties
    
    let data = ["Sign Out"]
    var user: ChatAppUser!
    
    // MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        user = AuthManager.shared.currentUser
        createHeaderView()
    }
    
    
    // MARK: Methods
    
    private func configureUI() {
        view.backgroundColor = .systemBackground
        tableView.backgroundColor = .systemGray6
    }
    
    private func createHeaderView(){
        let profileView = UIView(frame: CGRect(x: 0, y: 0, width: view.width, height: 200))
        profileView.backgroundColor = .systemGray6
        
        // profile image
        let imageSize: CGFloat = 104
        let imageView = UIImageView(frame: CGRect(x: (view.width - imageSize)/2, y: 20, width: imageSize, height: imageSize))
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = imageSize/2
        imageView.sd_setImage(with: URL(string: user.photoURL), placeholderImage: UIImage(systemName: "person.crop.circle", withConfiguration: UIImage.SymbolConfiguration(pointSize: 28, weight: .regular)))
        
        // full name
        let fullNameLabel = UILabel(frame: CGRect(x: 0, y: imageView.bottom + 10, width: view.width, height: 30))
        fullNameLabel.text = user.fullName
        fullNameLabel.textAlignment = .center
        fullNameLabel.font = .systemFont(ofSize: 28, weight: .regular)
        
        // email
        let emailLabel = UILabel(frame: CGRect(x: 0, y: fullNameLabel.bottom, width: view.width, height: 20))
        emailLabel.text = user.email
        emailLabel.textColor = .lightGray
        emailLabel.textAlignment = .center
        emailLabel.font = .systemFont(ofSize: 14, weight: .regular)
        
        // add all views to UIView
        profileView.addSubview(imageView)
        profileView.addSubview(fullNameLabel)
        profileView.addSubview(emailLabel)
        tableView.tableHeaderView = profileView
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
        if indexPath.row == 0 {
            cell.textLabel?.textColor = .systemRed
            cell.textLabel?.textAlignment = .center
        } else {
            cell.accessoryType = .disclosureIndicator
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if indexPath.row == 0 {
            signOut()
        }
    }
}

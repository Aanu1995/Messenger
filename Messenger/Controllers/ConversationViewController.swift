//
// ConversationViewController.swift
//  Messenger
//
//  Created by user on 09/04/2021.
//

import UIKit

class ConversationViewController: UIViewController {
    // MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        checkIfUserIsLoggedIn()
    }
    
    // MARK: Methods
    
    private func configureUI() {
        view.backgroundColor = .systemBackground
    }
    
    private func checkIfUserIsLoggedIn(){
        if !AuthManager.shared.isSignedIn {
            let navC = UINavigationController(rootViewController: LoginViewController())
            navC.modalPresentationStyle = .fullScreen
            navC.navigationBar.prefersLargeTitles = true
            navC.navigationItem.largeTitleDisplayMode = .always
            present(navC, animated: false)
        }
    }
}


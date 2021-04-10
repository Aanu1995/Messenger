//
//  LoginViewController.swift
//  Messenger
//
//  Created by user on 09/04/2021.
//

import UIKit

class LoginViewController: UIViewController, Dialog {
    
    // MARK: UI Properties
    
    private let loadingView: LoadingView = {
        let loadingView = LoadingView()
        return loadingView
    }()
    
    private let logoView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(named: "Logo")
        return imageView
    }()
    
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        return scrollView
    }()
    
    private let emailField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Email Address"
        textField.autocorrectionType = .no
        textField.autocapitalizationType = .none
        textField.returnKeyType = .continue
        textField.layer.cornerRadius = 12
        textField.layer.borderWidth = 1
        textField.keyboardType = .emailAddress
        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 0))
        textField.leftViewMode = .always
        textField.rightView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 0))
        textField.rightViewMode = .always
        textField.backgroundColor = .white
        textField.layer.borderColor = UIColor.gray.cgColor
        return textField
    }()
    
    private let passwordField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Password"
        textField.autocorrectionType = .no
        textField.autocapitalizationType = .none
        textField.returnKeyType = .done
        textField.layer.cornerRadius = 12
        textField.layer.borderWidth = 1
        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 0))
        textField.leftViewMode = .always
        textField.rightView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 0))
        textField.rightViewMode = .always
        textField.backgroundColor = .white
        textField.isSecureTextEntry = true
        textField.layer.borderColor = UIColor.gray.cgColor
        return textField
    }()
    
    private let loginButton: UIButton = {
        let button = UIButton()
        button.setTitle("Log In", for: .normal)
        button.backgroundColor = .link
        button.layer.masksToBounds = true
        button.layer.cornerRadius = 12
        button.setTitleColor(.white, for: .normal)
        return button
    }()
    
    // MARK: Properties
    
    private weak var currentSelectedTextField: UITextField?
    
    // MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        scrollView.frame = view.bounds
        let imageSize = scrollView.width / 4
        logoView.frame = CGRect(x: (scrollView.width - imageSize)/2, y: 20, width: imageSize, height: imageSize)
        emailField.frame = CGRect(x: 30, y: view.height/4.5, width: scrollView.width - 60, height: 52)
        passwordField.frame = CGRect(x: emailField.left, y: emailField.bottom + 10, width: emailField.width, height: emailField.height)
        loginButton.frame = CGRect(x: emailField.left, y: passwordField.bottom + 30, width: emailField.width, height: emailField.height)
        loadingView.frame = CGRect(x: (view.width - 100)/2, y: (view.height - 90)/2, width: 100, height: 90)
    }
    
    // MARK: Methods
    
    private func configureUI() {
        title = "Log In"
        view.backgroundColor = .systemBackground
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Register", style: .done, target: self, action: #selector(didTapRegister))
        
        // add subview
        view.addSubview(scrollView)
        scrollView.addSubview(logoView)
        scrollView.addSubview(emailField)
        scrollView.addSubview(passwordField)
        scrollView.addSubview(loginButton)
        
        emailField.delegate = self
        passwordField.delegate = self
        
        loginButton.addTarget(self, action: #selector(loginButtonTap), for: .touchUpInside)
        loadingView.configure(with: "Logging In")
    }
    
    @objc private func loginButtonTap(){
        // dismiss the keyboard
        currentSelectedTextField?.resignFirstResponder()
        
        guard let email = emailField.text, !email.isEmpty else {
            return showValidationError(with: "Please enter a valid email address")
        }
        
        guard let password = passwordField.text, !password.isEmpty else {
            return showValidationError(with: "Password can not be empty")
        }
        
        showLoading(isLoading: true)
        AuthManager.shared.signIn(email: email, password: password) { [weak self] result in
            self?.showLoading(isLoading: false)
            guard let strongSelf = self else { return }

            switch result {
            case .success:
                break
            case .failure(let error):
                strongSelf.present(strongSelf.showErrorDialog(message: error.localizedDescription), animated: true)
            }
        }
    }
    
    private func showLoading(isLoading: Bool) {
        if isLoading {
            view.addSubview(loadingView)
        } else {
            loadingView.removeFromSuperview()
        }
        emailField.isEnabled = !isLoading
        passwordField.isEnabled = !isLoading
        loginButton.isEnabled = !isLoading
    }
    
    private func showValidationError(with message: String){
        present(showErrorDialog(title: "Woops!", message: message), animated: true)
    }
    
    
    @objc private func didTapRegister() {
        let vc = RegisterViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
}

// MARK: UITextFieldDelegate

extension LoginViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        currentSelectedTextField = textField
        
        if textField == emailField {
            passwordField.becomeFirstResponder()
        } else if textField == passwordField {
            loginButtonTap()
        }
        return true
    }
}

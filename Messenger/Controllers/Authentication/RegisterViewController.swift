//
//  RegisterViewController.swift
//  Messenger
//
//  Created by user on 09/04/2021.
//

import UIKit
import FirebaseAuth

class RegisterViewController: UIViewController, Dialog {
    
    // MARK: UI Properties
    
    private let loadingView: LoadingView = {
        let loadingView = LoadingView()
        return loadingView
    }()
    
    private let profileView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(systemName: "person.crop.circle.fill")
        imageView.layer.masksToBounds = true
        return imageView
    }()
    
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        return scrollView
    }()
    
    private let firstNameField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "First Name"
        textField.returnKeyType = .continue
        textField.layer.cornerRadius = 12
        textField.layer.borderWidth = 1
        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 0))
        textField.leftViewMode = .always
        textField.rightView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 0))
        textField.rightViewMode = .always
        textField.layer.borderColor = UIColor.gray.cgColor
        return textField
    }()
    
    private let lastNameField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Last Name"
        textField.returnKeyType = .continue
        textField.layer.cornerRadius = 12
        textField.layer.borderWidth = 1
        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 0))
        textField.leftViewMode = .always
        textField.rightView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 0))
        textField.rightViewMode = .always
        textField.layer.borderColor = UIColor.gray.cgColor
        return textField
    }()
    
    private let emailField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Email Address"
        textField.returnKeyType = .continue
        textField.layer.cornerRadius = 12
        textField.layer.borderWidth = 1
        textField.keyboardType = .emailAddress
        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 0))
        textField.leftViewMode = .always
        textField.rightView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 0))
        textField.rightViewMode = .always
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
        textField.isSecureTextEntry = true
        textField.layer.borderColor = UIColor.gray.cgColor
        return textField
    }()
    
    private let registerButton: UIButton = {
        let button = UIButton()
        button.setTitle("Create Account", for: .normal)
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
        let imageSize = scrollView.width / 3.5
        profileView.frame = CGRect(x: (scrollView.width - imageSize)/2, y: 20, width: imageSize, height: imageSize)
        profileView.layer.cornerRadius = imageSize/2
        
        firstNameField.frame = CGRect(x: 30, y: view.height/5, width: scrollView.width - 60, height: 52)
        lastNameField.frame = CGRect(x: firstNameField.left, y: firstNameField.bottom + 10, width: firstNameField.width, height: firstNameField.height)
        emailField.frame = CGRect(x: firstNameField.left, y: lastNameField.bottom + 10, width: firstNameField.width, height: firstNameField.height)
        passwordField.frame = CGRect(x: firstNameField.left, y: emailField.bottom + 10, width: firstNameField.width, height: firstNameField.height)
        registerButton.frame = CGRect(x: firstNameField.left, y: passwordField.bottom + 30, width: firstNameField.width, height: firstNameField.height)
        loadingView.sizeToFit()
        loadingView.frame = CGRect(x: (view.width - 120)/2, y: (view.height - 90)/2, width: 130, height: 90)
    }
    
    // MARK: Methods
    
    private func configureUI() {
        title = "Create Account"
        view.backgroundColor = .systemBackground
        
        let gesture = UITapGestureRecognizer(target: self, action: #selector(didTapProfile))
        gesture.numberOfTapsRequired = 1
        gesture.numberOfTapsRequired = 1
        profileView.addGestureRecognizer(gesture)
        
        // add subview
        view.addSubview(scrollView)
        scrollView.addSubview(profileView)
        scrollView.addSubview(firstNameField)
        scrollView.addSubview(lastNameField)
        scrollView.addSubview(emailField)
        scrollView.addSubview(passwordField)
        scrollView.addSubview(registerButton)
        
        firstNameField.delegate = self
        lastNameField.delegate = self
        emailField.delegate = self
        passwordField.delegate = self
        
        scrollView.isUserInteractionEnabled = true
        profileView.isUserInteractionEnabled = true
        
        registerButton.addTarget(self, action: #selector(registerButtonTap), for: .touchUpInside)
        loadingView.configure(with: "Creating Account")
    }
    
    @objc private func registerButtonTap() {
        // dismiss the keyboard
        currentSelectedTextField?.resignFirstResponder()
        
        guard let firstName = firstNameField.text, !firstName.isEmpty else {
            return showValidationError(with: "Please enter a valid first name")
        }
        guard let lastName = lastNameField.text, !lastName.isEmpty else {
            return showValidationError(with: "Please enter a valid last name")
        }
        guard let email = emailField.text, !email.isEmpty else {
            return showValidationError(with: "Please enter a valid email address")
        }
        guard let password = passwordField.text, !password.isEmpty else {
            return showValidationError(with: "Password can not be empty")
        }
        
        showLoading(isLoading: true)
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) { [weak self] in
            self?.showLoading(isLoading: false)
        }
        
        AuthManager.shared.createAccount(email: email, password: password) { [weak self] result in
            guard let strongSelf = self else { return }

            switch result {
            case .success(let user):
                let chatAppUser = ChatAppUser(uid: user.uid, firstName: firstName, lastName: lastName, email: email, photoURL: "")
                DatabaseManager.shared.insertUser(user: chatAppUser) {
                    strongSelf.navigationController?.popViewController(animated: true)
                }
                break
            case .failure(let error):
                strongSelf.showLoading(isLoading: false)
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
        firstNameField.isEnabled = !isLoading
        lastNameField.isEnabled = !isLoading
        emailField.isEnabled = !isLoading
        passwordField.isEnabled = !isLoading
        registerButton.isEnabled = !isLoading
    }
    
    @objc private func didTapProfile(){
       presentActionSheetForProfile()
    }
    
    private func showValidationError(with message: String){
       present(showErrorDialog(message: message), animated: true)
    }
}

// MARK: UITextFieldDelegate

extension RegisterViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        currentSelectedTextField = textField
        
        if textField == firstNameField {
            lastNameField.becomeFirstResponder()
        } else if textField == lastNameField {
            emailField.becomeFirstResponder()
        } else if textField == emailField {
            passwordField.becomeFirstResponder()
        } else if textField == passwordField {
            registerButtonTap()
        }
        return true
    }
}

// MARK: UIImagePickerControllerDelegate, UINavigationControllerDelegate

extension RegisterViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    private func presentActionSheetForProfile(){
        let actionSheet = UIAlertController(title: "Profile Picture", message: "Please select picture via: ", preferredStyle: .actionSheet)
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        actionSheet.addAction(UIAlertAction(title: "Take Photo", style: .default, handler: { [weak self] _ in
            self?.initiateImagePicker(sourceType: .camera)
        }))
        actionSheet.addAction(UIAlertAction(title: "Choose Photo", style: .default, handler: { [weak self] _ in
            self?.initiateImagePicker(sourceType: .photoLibrary)
        }))
        
        present(actionSheet, animated: true)
    }
    
    private func initiateImagePicker(sourceType: UIImagePickerController.SourceType){
        let picker = UIImagePickerController()
        picker.sourceType = sourceType
        if sourceType == .camera {
            picker.showsCameraControls = true
        }
        picker.delegate = self
        picker.allowsEditing = true
        present(picker, animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let image = info[.editedImage] as? UIImage {
            self.profileView.image = image
        }
        
        picker.dismiss(animated: true)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }
}

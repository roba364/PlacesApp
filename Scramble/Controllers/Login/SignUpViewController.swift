//
//  SignUpViewController.swift
//  Scramble
//
//  Created by SofiaBuslavskaya on 13/02/2020.
//  Copyright © 2020 Sergey Borovkov. All rights reserved.
//

import UIKit
import Firebase

class SignUpViewController: UIViewController {
    
    //MARK: - Outlets
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var alreadyHaveAnAccountButton: UIButton!
    
    let currentAuthUser = Auth.auth().currentUser
    
    //MARK: - Properties
    
    lazy var emailContainerView: UIView = {
        let view = UIView()
        return view.textContainerView(view: view, UIImage(named: "email")!, emailTextField)
    }()
    
    lazy var usernameContainerView: UIView = {
        let view = UIView()
        return view.textContainerView(view: view, UIImage(named: "username")!, usernameTextField)
    }()
    
    lazy var passwordContainerView: UIView = {
        let view = UIView()
        return view.textContainerView(view: view, UIImage(named: "lock")!, passwordTextField)
    }()
    
    lazy var emailTextField: UITextField = {
        let tf = UITextField()
        tf.addTarget(self, action: #selector(emailPasswordValidation), for: .editingChanged)
        return tf.textField(withPlaceolder: "Email", isSecureTextEntry: false)
    }()
    
    lazy var usernameTextField: UITextField = {
        let tf = UITextField()
        return tf.textField(withPlaceolder: "Username", isSecureTextEntry: false)
    }()
    
    lazy var passwordTextField: UITextField = {
        let tf = UITextField()
        return tf.textField(withPlaceolder: "Password", isSecureTextEntry: true)
    }()
    
    //MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
    }
    
    //MARK: - Actions
    
    @objc private func emailPasswordValidation() {
        
        guard
            let email = emailTextField.text,
            let password = passwordTextField.text
            else { return }
        
        if email.isValid(.email) && password.isValid(.password) {
            signUpButton.isEnabled = false
        }
    }
    @IBAction func signUpButtonDidTapped(_ sender: Any) {
        
        guard
            let email = emailTextField.text,
            let password = passwordTextField.text
            else { return }
        
        Auth.auth().createUser(withEmail: email, password: password) { [weak self]
            (result, error) in
            
            guard
                let self = self,
                let username = self.usernameTextField.text,
                let uid = result?.user.uid
                else { return }
            
            if error == nil {
                let imageName = NSUUID().uuidString
                let storageRef = Storage.storage().reference().child("profileImages/\(imageName).png")
                
                guard
                    let imageData = self.profileImageView.image?.jpegData(compressionQuality: 0.3)
                    else { return }
                
                storageRef.putData(imageData, metadata: nil) { (metadata, error) in
                    
                    if error != nil, metadata != nil {
                        
                        print("Failed creating user because of: ", error?.localizedDescription as Any)
                        return
                        
                    } else {
                        
                        storageRef.downloadURL { (url, error) in
                            
                            if error != nil {
                                print("Failed to downlaodURL: ", error?.localizedDescription as Any)
                            }
                            
                            if let profileImageUrl = url?.absoluteString {
                                let friends = [String: Any]()
                                let values = ["username" : username, "email" : email, "id" : uid, "profileUrl" : profileImageUrl, "friends" : friends] as [String : Any]
                                self.registerUserIntoDatabase(uid, values: values as [String : AnyObject])
                            }
                        }
                    }
                    
                    print("--->>> CURRENT USER \(self.currentAuthUser)")
                }
            }
        }
    }
    
    @IBAction func alreadyHaveAnAccountDidTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    //MARK: - Selectors
    
    @objc func textFieldDidChange() {
        guard let username = usernameTextField.text, !username.isEmpty else {
            signUpButton.setTitleColor(.black, for: .normal)
            return }
        guard let email = emailTextField.text, !email.isEmpty, email.isValid(.email) else { signUpButton.setTitleColor(.black, for: .normal)
                return }
        guard let password = passwordTextField.text, password.isValid(.password) else {
            signUpButton.setTitleColor(.black, for: .normal)
                return }
        
        signUpButton.isEnabled = true
        signUpButton.setTitleColor(.black, for: .normal)
    }
    

    
    //MARK: - Setup UI
    
    private func setupUI() {
        
        setupProfileImage()
        setupSignUpButton()
        setupAlreadyHaveAnAccountButton()
        handleTextField()
        setupConstraints()
    }
    
    private func setupProfileImage() {
        
        profileImageView.clipsToBounds = true
        profileImageView.image = UIImage(named: "gen_user")
        profileImageView.isUserInteractionEnabled = true
        profileImageView.contentMode = .scaleAspectFill
        profileImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handeSelectProfileImage)))
        
    }
    
    private func setupSignUpButton() {
        signUpButton.setTitle("REGISTER", for: .normal)
        signUpButton.titleLabel?.font = UIFont(name: "Copperplate", size: 22)
        signUpButton.setTitleColor(UIColor.lightGray, for: .normal)
        signUpButton.backgroundColor = .white
        signUpButton.layer.cornerRadius = 15
    }
    
    private func setupAlreadyHaveAnAccountButton() {
        
        let attributedTitle = NSMutableAttributedString(string: "Already have an account?  ", attributes: [NSAttributedString.Key.font: UIFont(name: "Copperplate", size: 18) as Any, NSAttributedString.Key.foregroundColor: UIColor.white])
        attributedTitle.append(NSAttributedString(string: "Log in", attributes: [NSAttributedString.Key.font: UIFont(name: "Copperplate", size: 18) as Any, .underlineStyle: NSUnderlineStyle.single.rawValue, NSAttributedString.Key.foregroundColor: UIColor.white]))
            alreadyHaveAnAccountButton.setAttributedTitle(attributedTitle, for: .normal)
    }
    
    //MARK: - Helper functions
    
    private func configureTextFieldsDelegate() {
        emailTextField.delegate = self
        usernameTextField.delegate = self
        passwordTextField.delegate = self
    }
    
    private func handleTextField() {
        emailTextField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        usernameTextField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        passwordTextField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
    }
    
    private func registerUserIntoDatabase(_ uid: String, values: [String: AnyObject]) {
        
        let ref = Database.database().reference(fromURL: "https://scramble-93a69.firebaseio.com/")
        let usersRef = ref.child("users").child(uid)
        usersRef.updateChildValues(values) { (error, databaseRef) in
            
            if error != nil {
                
                print("Failed to save user in database: ", error?.localizedDescription)
            }
            
            self.performSegue(withIdentifier: "FromSignUpToTabbar", sender: self)
        }
        
    }
    
    //MARK: - Constraints
    
    private func setupConstraints() {
        view.backgroundColor = UIColor.darkGray
        navigationController?.navigationBar.isHidden = true
        
        view.addSubview(emailContainerView)
        emailContainerView.anchor(top: profileImageView.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 100, paddingLeft: 32, paddingBottom: 0, paddingRight: 32, width: 0, height: 50)
        
        view.addSubview(usernameContainerView)
        usernameContainerView.anchor(top: emailContainerView.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 24, paddingLeft: 32, paddingBottom: 0, paddingRight: 32, width: 0, height: 50)
        
        view.addSubview(passwordContainerView)
        passwordContainerView.anchor(top: usernameContainerView.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 16, paddingLeft: 32, paddingBottom: 0, paddingRight: 32, width: 0, height: 50)
    }
    
    deinit {
        print("SignInVC deinit", SignInViewController.self)
    }
    
}

    //MARK: - Extensions

extension SignUpViewController: UITextFieldDelegate {
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        switch textField {
        case emailTextField:
            emailTextField.resignFirstResponder()
            usernameTextField.becomeFirstResponder()
        case usernameTextField:
            usernameTextField.resignFirstResponder()
            passwordTextField.becomeFirstResponder()
        default:
            passwordTextField.resignFirstResponder()
        }
        
        return true
    }
}

extension SignUpViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @objc func handeSelectProfileImage() {
        
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.allowsEditing = true
        
        present(picker, animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        var selectedImageFromPicker: UIImage?
        
        if let editedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            selectedImageFromPicker = editedImage
        } else if let originalImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            selectedImageFromPicker = originalImage
        }
        
        if let selectedImage = selectedImageFromPicker {
            profileImageView.image = selectedImage
        }
        
        dismiss(animated: true, completion: nil)
    }
}

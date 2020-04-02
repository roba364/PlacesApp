//
//  SignInViewController.swift
//  Scramble
//
//  Created by SofiaBuslavskaya on 13/02/2020.
//  Copyright © 2020 Sergey Borovkov. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase
import FBSDKLoginKit
import FBSDKCoreKit

class SignInViewController: UIViewController {
    
    //MARK: - Outlets
    
    @IBOutlet weak var scrambleLabel: UILabel!
    @IBOutlet weak var logoImageView: UIImageView!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var forgotPassword: UIButton!
    @IBOutlet weak var googleButton: UIButton!
    @IBOutlet weak var orLabel: UILabel!
    @IBOutlet weak var facebookButton: UIButton!
    @IBOutlet weak var dontHaveAnAccountButton: UIButton!
    
    //MARK: - Properties
    
    
    lazy var emailContainerView: UIView = {
        guard let emailImage = UIImage(named: "email") else { fatalError() }
        
        let view = UIView()
        return view.textContainerView(view: view, emailImage, emailTextField)
    }()
    
    lazy var passwordContainerView: UIView = {
        guard let passwordImage = UIImage(named: "lock") else { fatalError() }
        let view = UIView()
        return view.textContainerView(view: view, passwordImage, passwordTextField)
    }()
    
    lazy var emailTextField: UITextField = {
        let tf = UITextField()
        return tf.textField(withPlaceolder: "Email", isSecureTextEntry: false)
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
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        checkUserAuth()
    }

    //MARK: - Actions
    
    @IBAction func loginButtonDidTapped(_ sender: Any) {
        guard
            let email = emailTextField.text,
            let password = passwordTextField.text
            else { return }
        
        Auth.auth().signIn(withEmail: email, password: password) { [weak self] (result, error) in
            
            guard let self = self else { return }
            
            if error == nil {
                self.displayMainScene()
                
            } else {
                
                print(error?.localizedDescription)
            }
        }
        
    }
    @IBAction func forgotPasswordDidTapped(_ sender: Any) {
        
    }
    @IBAction func googleButtonDidTapped(_ sender: Any) {
    }
    
    
    @IBAction func facebookButtonDidTapped(_ sender: Any) {
        
        let loginManager = LoginManager()
        
        loginManager.logIn(permissions: ["public_profile", "email"], from: self) { (result, error) in
            if let error = error {
                print("Failed to login :", error.localizedDescription)
            }
            
            guard let accessToken = AccessToken.current else {
                print("Failed to get access token")
                return
            }
            
            let credential = FacebookAuthProvider.credential(withAccessToken: accessToken.tokenString)
            
            Auth.auth().signIn(with: credential) { [weak self] (user, error) in
                
                guard let self = self else { return }
                
                if let error = error {
                    print("Login error :", error.localizedDescription)
                    let alertController = UIAlertController(title: "Login Error", message: error.localizedDescription, preferredStyle: .alert)
                    let okAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                    alertController.addAction(okAction)
                    self.present(alertController, animated: true, completion: nil)
                    return
                } else {
                    guard let currentUser = Auth.auth().currentUser else { return }
                    let ref = Database.database().reference().child("users")
                    
                    guard let userProfilePhoto = user?.user.photoURL else { return }
            

                    ref.child(currentUser.uid).updateChildValues(["username" : currentUser.displayName, "email" : currentUser.email, "id" : currentUser.uid, "profileUrl": "\(userProfilePhoto)", "friends" : [currentUser.displayName : false]])
                
                    self.currentUserName()
                    
                }
            }
        }
        
    }
    @IBAction func dontHaveAnAccountDidTapped(_ sender: Any) {
    
    }
    
    //MARK: - Selectors
    
    @objc func textFieldDidChange() {
        guard let email = emailTextField.text, !email.isEmpty, email.isValid(.email) else { loginButton.setTitleColor(.lightGray, for: .normal)
                return }
        guard let password = passwordTextField.text, password.isValid(.password) else {
            loginButton.setTitleColor(.lightGray, for: .normal)
                return }
        
        loginButton.isEnabled = true
        loginButton.setTitleColor(.black, for: .normal)
    }
    
    
    //MARK: - Setup UI
    
    private func setupUI() {
        
        setupLogo()
        setupLoginButton()
        setupForgotPasswordButton()
        setupSignInWithGoogleButton()
        signInWithFacebookButton()
        setupDontHaveAnAccountButton()
        handleTextField()
        setupConstraints()
    }
    
    private func setupLogo() {
        
        logoImageView.contentMode = .scaleAspectFit
        logoImageView.clipsToBounds = true
        logoImageView.layer.masksToBounds = true
        logoImageView.layer.cornerRadius = 75
        logoImageView.layer.borderColor = UIColor.white.cgColor
        logoImageView.layer.borderWidth = 2
        logoImageView.image = UIImage(named: "logo")
    }
    
    private func setupLoginButton() {
        loginButton.isEnabled = false
        loginButton.setTitle("START", for: .normal)
        loginButton.titleLabel?.font = UIFont(name: "Copperplate", size: 22)
        loginButton.setTitleColor(UIColor.lightGray, for: .normal)
        loginButton.backgroundColor = .white
        loginButton.layer.cornerRadius = 15
    }
    
    private func setupForgotPasswordButton() {
        forgotPassword.setTitleColor(UIColor.white, for: .normal)
        
        let yourAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont(name: "Copperplate", size: 20) as Any,
        .foregroundColor: UIColor.white,
        .underlineStyle: NSUnderlineStyle.single.rawValue]
        let attributeString = NSMutableAttributedString(string: "Forgot password?",
                                                        attributes: yourAttributes)
        forgotPassword.setAttributedTitle(attributeString, for: .normal)
        
    }
    
    private func setupSignInWithGoogleButton() {
            googleButton.layer.cornerRadius = 15
            googleButton.tintColor = .white
            
            googleButton.imageView?.contentMode = .scaleAspectFit
            googleButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        }
    
    private func signInWithFacebookButton() {

        facebookButton.layer.cornerRadius = 15
        facebookButton.tintColor = .white
        
        facebookButton.imageView?.contentMode = .scaleAspectFit
        facebookButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    private func setupDontHaveAnAccountButton() {
        let attributedTitle = NSMutableAttributedString(string: "Don't have an account?  ", attributes: [NSAttributedString.Key.font: UIFont(name: "Copperplate", size: 18) as Any, NSAttributedString.Key.foregroundColor: UIColor.white])
    attributedTitle.append(NSAttributedString(string: "Register", attributes: [NSAttributedString.Key.font: UIFont(name: "Copperplate", size: 18) as Any, .underlineStyle: NSUnderlineStyle.single.rawValue, NSAttributedString.Key.foregroundColor: UIColor.white]))
        dontHaveAnAccountButton.setAttributedTitle(attributedTitle, for: .normal)
    }
    
    //MARK: - Helper functions

    private func handleTextField() {
        emailTextField.addTarget(self, action: #selector(SignInViewController.textFieldDidChange), for: .editingChanged)
        passwordTextField.addTarget(self, action: #selector(SignInViewController.textFieldDidChange), for: .editingChanged)
    }
    
    private func currentUserName() {
        
        if let currentUser = Auth.auth().currentUser {
            print("USER LOGGED IN :", currentUser)
            displayMainScene()
        }
    }
    
    private func checkUserAuth() {
        
        DispatchQueue.main.async {
            Auth.auth().addStateDidChangeListener { [weak self] (auth, user) in
                guard let self = self else { return }
                if user != nil {
                    print("CURRENT USER LOG IN ->>> \(Auth.auth().currentUser?.email) <---")
                    self.displayMainScene()
                } else {
                    print("->>> NO CURRENT USER")
                }
            }
        }
    }

    private func displayMainScene() {
        let keyWindow = UIApplication.shared.windows.first { $0.isKeyWindow }
        let main = UIStoryboard.init(name: "Main", bundle: nil)
        let tabbarVC = main.instantiateViewController(identifier: "TabbarVC")
        keyWindow?.rootViewController = tabbarVC
//        performSegue(withIdentifier: "FromLoginToTabbar", sender: nil)
    }
    
    //MARK: - Constraints
    
    private func setupConstraints() {
        
        view.backgroundColor = .darkGray
        navigationController?.navigationBar.isHidden = true
        
        view.addSubview(emailContainerView)
        emailContainerView.anchor(top: logoImageView.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 24, paddingLeft: 32, paddingBottom: 0, paddingRight: 32, width: 0, height: 50)
        
        
        view.addSubview(passwordContainerView)
        passwordContainerView.anchor(top: emailContainerView.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 16, paddingLeft: 32, paddingBottom: 0, paddingRight: 32, width: 0, height: 50)
        
        
    }
    
    deinit {
        print("SignInVC deinit", SignInViewController.self)
    }

}

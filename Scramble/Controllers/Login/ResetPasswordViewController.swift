//
//  ResetPasswordViewController.swift
//  Scramble
//
//  Created by SofiaBuslavskaya on 13/02/2020.
//  Copyright © 2020 Sergey Borovkov. All rights reserved.
//

import UIKit
import Firebase

class ResetPasswordViewController: UIViewController {
    
    //MARK: - Outlets
    @IBOutlet weak var resetMyPassword: UIButton!
    @IBOutlet weak var backButton: UIButton!
    
    //MARK: - Properties
    
    lazy var emailContainerView: UIView = {
        guard let emailImage = UIImage(named: "email") else { fatalError() }
        
        let view = UIView()
        return view.textContainerView(view: view, emailImage, emailTextField)
    }()
    
    lazy var emailTextField: UITextField = {
        let tf = UITextField()
        return tf.textField(withPlaceolder: "Email", isSecureTextEntry: false)
    }()
    
    //MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
    }
    
    //MARK - Selectors
    
    @objc func textFieldDidChange() {
        guard let email = emailTextField.text, !email.isEmpty, email.isValid(.email) else { resetMyPassword.setTitleColor(.lightGray, for: .normal)
                return }
        
        resetMyPassword.isEnabled = true
        resetMyPassword.setTitleColor(.black, for: .normal)
    }
    
    //MARK: - Actions
    
    @IBAction func backButtonDidTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func resetMyPasswordTapped(_ sender: Any) {
        guard let email = emailTextField.text, !email.isEmpty else { return }
        
        resetPassword(email: email, onSuccess: { [weak self] in
            guard let self = self else { return }
            print("DONE")
            self.view.endEditing(true)
            self.navigationController?.popViewController(animated: true)
        }) { (errorMessage) in
            print(errorMessage)
        }
    }
    
    //MARK: - Setup UI
    
    private func setupUI() {
        
        setupResetMyPasswordButton()
        handleTextField()
        setupConstraints()
    }
    
    private func setupResetMyPasswordButton() {
        resetMyPassword.isEnabled = false
        resetMyPassword.setTitle("Reset my password", for: .normal)
        resetMyPassword.titleLabel?.font = UIFont(name: "Copperplate", size: 22)
        resetMyPassword.setTitleColor(UIColor.lightGray, for: .normal)
        resetMyPassword.backgroundColor = .white
        resetMyPassword.layer.cornerRadius = 15
    }
    
    //MARK: - Helper functions
    
    private func resetPassword(email: String, onSuccess: @escaping() -> Void, onError: @escaping(_ errorMessage: String) -> Void) {
        Auth.auth().sendPasswordReset(withEmail: email) { (error) in
            if error == nil {
                onSuccess()
            } else {
                onError(error!.localizedDescription)
            }
        }
    }
    
    private func handleTextField() {
    emailTextField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
    }

    //MARK: - Constraints

    private func setupConstraints() {
        view.backgroundColor = .darkGray
        navigationController?.navigationBar.isHidden = true
        
        view.addSubview(emailContainerView)
        emailContainerView.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 350, paddingLeft: 20, paddingBottom: 0, paddingRight: 20, width: 0, height: 50)
        
    }
}

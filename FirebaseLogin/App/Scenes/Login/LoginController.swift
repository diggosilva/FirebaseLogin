//
//  ViewController.swift
//  FirebaseLogin
//
//  Created by Diggo Silva on 02/02/25.
//

import UIKit
import FirebaseAuth

class LoginController: UIViewController {
    
    // MARK: - Properties
    let loginView = LoginView()
    
    // MARK: - Lifecycle
    override func loadView() {
        super.loadView()
        view = loginView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setNavBar()
        setDelegates()
        navigateToFeedIfUserIsLoggedIn()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        setupLoginButtonWhenTapped(setTitle: "Logar", startAnimating: false)
        clearTextFields()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    // MARK: - Setup Methods
    private func setNavBar() {
        title = "TELA DE LOGIN"
    }
    
    private func setDelegates() {
        loginView.delegate = self
    }
    
    private func clearTextFields() {
        loginView.emailTextField.text = ""
        loginView.passwordTextField.text = ""
    }
    
    private func navigateToFeedIfUserIsLoggedIn() {
        let firebaseAuth = Auth.auth()
        if let user = firebaseAuth.currentUser {
            if let email = user.email {
                print(email)
                let feedVC = FeedController()
                feedVC.feedView.email = email
                navigationController?.pushViewController(feedVC, animated: true)
            }
        }
    }
    
    // MARK: - Actions
    func showAlertError(message: String) {
        let alert = UIAlertController(title: "Erro", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { action in
            self.setupLoginButtonWhenTapped(setTitle: "Logar", startAnimating: false)
        }))
        present(alert, animated: true)
    }
    
    // MARK: - UI Configuration
    func setupLoginButtonWhenTapped(setTitle: String = "", startAnimating: Bool = true) {
        if startAnimating {
            loginView.loginButton.setTitle(setTitle, for: .normal)
            loginView.spinner.startAnimating()
        } else {
            loginView.loginButton.setTitle(setTitle, for: .normal)
            loginView.spinner.stopAnimating()
        }
    }
}

// MARK: - LoginViewDelegate
extension LoginController: LoginViewDelegate {
    func loginButtonTapped() {
        setupLoginButtonWhenTapped()
        guard let email = loginView.emailTextField.text, !email.trimmingCharacters(in: .whitespaces).isEmpty else {
            showAlertError(message: "Digite um e-mail válido")
            loginView.emailTextField.text = ""
            return
        }
        
        guard let password = loginView.passwordTextField.text, !password.trimmingCharacters(in: .whitespaces).isEmpty else {
            showAlertError(message: "Digita sua senha")
            return
        }
        
        let firebaseAuth = Auth.auth()
        firebaseAuth.signIn(withEmail: email, password: password) { [weak self] authResult, error in
            guard let self = self else { return }
            
            if let error = error {
                self.showAlertError(message: "Erro ao realizar o login: \(error.localizedDescription)")
                return
            } else {
                let feedVC = FeedController()
                let firebaseAuth = Auth.auth()
                if let email = firebaseAuth.currentUser?.email {
                    feedVC.feedView.email = email
                    self.navigationController?.pushViewController(feedVC, animated: true)
                }
            }
        }
    }
    
    func signupButtonTapped() {
        let signupVC = SignupController()
        navigationController?.pushViewController(signupVC, animated: true)
    }
}

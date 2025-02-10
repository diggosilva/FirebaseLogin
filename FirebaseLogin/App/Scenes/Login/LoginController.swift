//
//  ViewController.swift
//  FirebaseLogin
//
//  Created by Diggo Silva on 02/02/25.
//

import UIKit
//import FirebaseAuth

class LoginController: UIViewController {
    
    // MARK: - Properties
    let loginView = LoginView()
    let viewModel = LoginViewModel()
    
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
        if let userModel = viewModel.checkIfUserIsLoggedIn() {
            let email = userModel.email
            let feedVC = FeedController()
            feedVC.feedView.email = email
            navigationController?.pushViewController(feedVC, animated: true)
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
        
        // Validar email
        guard let email = loginView.emailTextField.text else { return }
        switch viewModel.validateEmail(email) {
        case .failure(let error):
            return showAlertError(message: error.localizedDescription)
        case .success(let validEmail):
            
            // Validar senha
            guard let password = loginView.passwordTextField.text else { return }
            switch viewModel.validatePassword(password) {
            case .failure(let error):
                return showAlertError(message: error.localizedDescription)
            case .success(let validPassword):
                
                // Autenticar usuário
                viewModel.authenticateUser(email: validEmail, password: validPassword) { [weak self] result in
                    guard let self = self else { return }
                    switch result {
                    case .success(let email):
                        let feedVC = FeedController()
                        feedVC.feedView.email = email
                        navigationController?.pushViewController(feedVC, animated: true)
                    case .failure(let error):
                        return showAlertError(message: error.localizedDescription)
                    }
                }
            }
        }
    }
    
    func signupButtonTapped() {
        let signupVC = SignupController()
        navigationController?.pushViewController(signupVC, animated: true)
    }
}

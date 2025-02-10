//
//  SignupController.swift
//  FirebaseLogin
//
//  Created by Diggo Silva on 02/02/25.
//

import UIKit

class SignupController: UIViewController {
    
    // MARK: - Properties
    let signupView = SignupView()
    let viewModel = SignupViewModel()
    
    // MARK: - Lifecycle
    override func loadView() {
        super.loadView()
        view = signupView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setNavBar()
        setDelegates()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        setupSignupButtonWhenTapped(setTitle: "Cadastrar", startAnimating: false)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    // MARK: - Configuration
    private func setNavBar() {
        title = "TELA DE CADASTRO"
        navigationItem.hidesBackButton = true
    }
    
    private func setDelegates() {
        signupView.delegate = self
    }
    
    // MARK: - Alerts
    private func showAlertError(message: String) {
        let alert = UIAlertController(title: "Erro", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { action in
            self.setupSignupButtonWhenTapped(setTitle: "Cadastrar", startAnimating: false)
        }))
        present(alert, animated: true)
    }
    
    private func showAlertSuccess() {
        let alert = UIAlertController(title: "Cadastrado com sucesso!", message: "Faça o login para continuar", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { action in
            self.viewModel.logoutUser()
            self.navigationController?.popToRootViewController(animated: true)
        }))
        present(alert, animated: true)
    }
    
    // MARK: - UI Configuration
    private func setupSignupButtonWhenTapped(setTitle: String = "", startAnimating: Bool = true) {
        if startAnimating {
            signupView.signupButton.setTitle(setTitle, for: .normal)
            signupView.spinner.startAnimating()
        } else {
            signupView.signupButton.setTitle(setTitle, for: .normal)
            signupView.spinner.stopAnimating()
        }
    }
}

// MARK: - SignupViewDelegate
extension SignupController: SignupViewDelegate {
    func signupButtonTapped() {
        setupSignupButtonWhenTapped()
        
        // Validar email
        guard let email = signupView.emailTextField.text else { return }
        switch viewModel.validateEmail(email) {
        case .failure(let error):
            return showAlertError(message: error.localizedDescription)
        case .success(let validEmail):
           
            // Validar senha
            guard let password = signupView.passwordTextField.text else { return }
            switch viewModel.validatePassword(password) {
            case .failure(let error):
                return showAlertError(message: error.localizedDescription)
            case .success(let validPassword):
                
                // Confirmar senha
                guard let confirmPassword = signupView.confirmPasswordTextField.text else { return }
                switch viewModel.validateConfirmPassword(confirmPassword, validPassword) {
                case .failure(let error):
                    showAlertError(message: error.localizedDescription)
                case .success(let validConfirmPassword):
                    
                    // Deslogar usuário e encaminhar para tela de Login
                    viewModel.registerUser(email: validEmail, password: validConfirmPassword) { [weak self] result in
                        guard let self = self else { return }
                        switch result {
                        case .success( _):
                            return showAlertSuccess()
                        case .failure(let error):
                            return showAlertError(message: error.localizedDescription)
                        }
                    }
                }
            }
        }
    }
    
    func loginButtonTapped() {
        navigationController?.popToRootViewController(animated: true)
    }
}

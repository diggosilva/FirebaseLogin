//
//  SignupController.swift
//  FirebaseLogin
//
//  Created by Diggo Silva on 02/02/25.
//

import UIKit
import FirebaseAuth

class SignupController: UIViewController {
    
    let signupView = SignupView()
    
    override func loadView() {
        super.loadView()
        view = signupView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setNavBar()
        setDelegatesAndDataSources()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        setupSignupButtonWhenTapped(setTitle: "Cadastrar", startAnimating: false)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    private func setNavBar() {
        title = "TELA DE CADASTRO"
        navigationItem.hidesBackButton = true
    }
    
    private func setDelegatesAndDataSources() {
        signupView.delegate = self
    }
    
    func showAlertError(message: String) {
        let alert = UIAlertController(title: "Erro", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { action in
            self.setupSignupButtonWhenTapped(setTitle: "Cadastrar", startAnimating: false)
        }))
        present(alert, animated: true)
    }
    
    func showAlertSuccess(message: String) {
        let alert = UIAlertController(title: "Cadastrado com sucesso!", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { action in
                do {
                    try Auth.auth().signOut()
                    self.navigationController?.popToRootViewController(animated: true)
                } catch {
                    self.showAlertError(message: "Erro ao fazer logout: \(error.localizedDescription)")
            }
            self.navigationController?.popToRootViewController(animated: true)
        }))
        present(alert, animated: true)
    }
    
    func setupSignupButtonWhenTapped(setTitle: String = "", startAnimating: Bool = true) {
        if startAnimating {
            signupView.signupButton.setTitle(setTitle, for: .normal)
            signupView.spinner.startAnimating()
        } else {
            signupView.signupButton.setTitle(setTitle, for: .normal)
            signupView.spinner.stopAnimating()
        }
    }
}

extension SignupController: SignupViewDelegate {
    func signupButtonTapped() {
        setupSignupButtonWhenTapped()
        guard let email = signupView.emailTextField.text, !email.trimmingCharacters(in: .whitespaces).isEmpty else {
            showAlertError(message: "Digite um e-mail válido")
            signupView.emailTextField.text = ""
            return
        }
        
        guard let password = signupView.passwordTextField.text, !password.trimmingCharacters(in: .whitespaces).isEmpty else {
            showAlertError(message: "Digite uma senha")
            return
        }
        
        guard let confirmPassword = signupView.confirmPasswordTextField.text, !confirmPassword.trimmingCharacters(in: .whitespaces).isEmpty, confirmPassword == password else {
            showAlertError(message: "As senhas não coincidem. Digite novamente")
            signupView.confirmPasswordTextField.text = ""
            return
        }
        
        let firebaseAuth = Auth.auth()
        firebaseAuth.createUser(withEmail: email, password: password) { authResult, error in
            if let error = error {
                self.showAlertError(message: "Falha ao cadastrar usuário: \(error.localizedDescription)")
            } else {
                self.showAlertSuccess(message: "Faça o login para continuar")
            }
        }
    }
    
    func loginButtonTapped() {
        navigationController?.popToRootViewController(animated: true)
    }
}

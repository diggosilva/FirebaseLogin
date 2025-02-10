//
//  SignupController.swift
//  FirebaseLogin
//
//  Created by Diggo Silva on 02/02/25.
//

import UIKit
import FirebaseAuth

class SignupController: UIViewController {
    
    // MARK: - Properties
    let signupView = SignupView()
    
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
                    self.showAlertError(message: SignupError.signupFailed.localizedDescription)
            }
            self.navigationController?.popToRootViewController(animated: true)
        }))
        present(alert, animated: true)
    }
    
    // MARK: - UI Configuration
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

// MARK: - SignupViewDelegate
extension SignupController: SignupViewDelegate {
    func signupButtonTapped() {
        setupSignupButtonWhenTapped()
        guard let email = signupView.emailTextField.text, !email.trimmingCharacters(in: .whitespaces).isEmpty else {
            showAlertError(message: SignupError.invalidEmail.localizedDescription)
            signupView.emailTextField.text = ""
            return
        }
        
        if !isValidEmail(email) {
            showAlertError(message: SignupError.invalidEmail.localizedDescription)
            signupView.emailTextField.text = ""
        }
        
        guard let password = signupView.passwordTextField.text, !password.trimmingCharacters(in: .whitespaces).isEmpty else {
            showAlertError(message: SignupError.invalidPassword.localizedDescription)
            return
        }
        
        if password.count < 6 {
            showAlertError(message: SignupError.invalidPassword.localizedDescription)
            return
        }
        
        guard let confirmPassword = signupView.confirmPasswordTextField.text, !confirmPassword.trimmingCharacters(in: .whitespaces).isEmpty, confirmPassword == password else {
            showAlertError(message: SignupError.passwordMismatch.localizedDescription)
            signupView.confirmPasswordTextField.text = ""
            return
        }
        
        let firebaseAuth = Auth.auth()
        firebaseAuth.createUser(withEmail: email, password: password) { authResult, error in
            if error != nil {
                self.showAlertError(message: SignupError.signupFailed.localizedDescription)
            } else {
                self.showAlertSuccess(message: "Faça o login para continuar")
            }
        }
    }
    
    func loginButtonTapped() {
        navigationController?.popToRootViewController(animated: true)
    }
    // Função para validar formato de email
    private func isValidEmail(_ email: String) -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailTest = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return emailTest.evaluate(with: email)
    }
}

enum SignupError: String, Error {
    case invalidEmail = "O e-mail informado é inválido. Ex: exemplo@dominio.com"
    case invalidPassword = "A senha deve ter pelo menos 6 caracteres"
    case passwordMismatch = "As senhas não coincidem. Por favor, verifique."
    case signupFailed = "Falha ao tentar cadastrar o usuário. Tente novamente."
    case logoutFailed = "Erro ao fazer logout. Tente novamente."
    
    var localizedDescription: String {
        return rawValue
    }
}

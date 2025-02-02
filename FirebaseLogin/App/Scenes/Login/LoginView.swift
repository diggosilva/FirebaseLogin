//
//  LoginView.swift
//  FirebaseLogin
//
//  Created by Diggo Silva on 02/02/25.
//

import UIKit

class LoginView: UIView {
    lazy var logoImage: UIImageView = {
        let img = UIImageView()
        img.translatesAutoresizingMaskIntoConstraints = false
        img.contentMode = .scaleAspectFit
        img.image = UIImage(named: "logo")
        return img
    }()
    
    lazy var emailTextField: UITextField = {
        let tf = UITextField()
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.autocapitalizationType = .none
        tf.autocorrectionType = .no
        tf.placeholder = "Email"
        tf.borderStyle = .roundedRect
        tf.clearButtonMode = .whileEditing
        tf.keyboardType = .emailAddress
        return tf
    }()
    
    lazy var passwordTextField: UITextField = {
        let tf = UITextField()
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.autocapitalizationType = .none
        tf.autocorrectionType = .no
        tf.placeholder = "Senha"
        tf.borderStyle = .roundedRect
        tf.clearButtonMode = .whileEditing
        tf.isSecureTextEntry = true
        return tf
    }()
    
    lazy var loginButton = buildButton(title: "Logar", color: .systemBlue, selector: #selector(loginButtonTapped))
    lazy var signupButton = buildButtonWith2Texts(title1: "Não tem uma conta?  ", title2: "Cadastre-se!", selector: #selector(signupButtonTapped))
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        setupView()
    }
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    @objc func loginButtonTapped() {
        print("Clicou no botão LOGAR")
    }
    
    @objc func signupButtonTapped() {
        print("Clicou no botão CADASTRAR")
    }
    
    private func setupView() {
        setHierarchy()
        setConstraints()
    }
    
    private func setHierarchy() {
        backgroundColor = .systemBackground
        addSubviews([logoImage, emailTextField, passwordTextField, loginButton, signupButton])
    }
    
    private func setConstraints() {
        NSLayoutConstraint.activate([
            logoImage.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            logoImage.centerXAnchor.constraint(equalTo: centerXAnchor),
            logoImage.widthAnchor.constraint(equalToConstant: 200),
            logoImage.heightAnchor.constraint(equalTo: logoImage.widthAnchor),
            
            emailTextField.topAnchor.constraint(equalTo: logoImage.bottomAnchor, constant: 20),
            emailTextField.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            emailTextField.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            
            passwordTextField.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: 20),
            passwordTextField.leadingAnchor.constraint(equalTo: emailTextField.leadingAnchor),
            passwordTextField.trailingAnchor.constraint(equalTo: emailTextField.trailingAnchor),
            
            loginButton.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 20),
            loginButton.leadingAnchor.constraint(equalTo: emailTextField.leadingAnchor),
            loginButton.trailingAnchor.constraint(equalTo: emailTextField.trailingAnchor),
            
            signupButton.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor),
            signupButton.leadingAnchor.constraint(equalTo: emailTextField.leadingAnchor),
            signupButton.trailingAnchor.constraint(equalTo: emailTextField.trailingAnchor),
        ])
    }
}

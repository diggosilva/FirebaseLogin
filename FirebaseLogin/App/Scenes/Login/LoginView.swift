//
//  LoginView.swift
//  FirebaseLogin
//
//  Created by Diggo Silva on 02/02/25.
//

import UIKit

protocol LoginViewDelegate: AnyObject {
    func loginButtonTapped()
    func signupButtonTapped()
}

class LoginView: UIView {
    
    // MARK: - UI Elements
    
    lazy var logoImage = buildLogoImageView()
    lazy var emailTextField = buildTextfield(placeholder: "Email")
    lazy var passwordTextField = buildTextfield(placeholder: "Senha", keyboardType: .default, isSecureTextEntry: true)
    lazy var loginButton = buildButton(title: "Logar", color: .systemBlue, selector: #selector(loginButtonTapped))
    lazy var signupButton = buildButtonWith2Texts(title1: "Não tem uma conta?  ", title2: "Cadastre-se!", selector: #selector(signupButtonTapped))
    lazy var spinner = buildSpinner()
    
    // MARK: - Properties
    
    weak var delegate: LoginViewDelegate?
    
    // MARK: - Initializer
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        setupView()
    }
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    // MARK: - Button Actions
    
    @objc private func loginButtonTapped() {
        delegate?.loginButtonTapped()
    }
    
    @objc private func signupButtonTapped() {
        delegate?.signupButtonTapped()
    }
    
    // MARK: - Setup Methods
    
    private func setupView() {
        setHierarchy()
        setConstraints()
    }
    
    // MARK: - Layout Methods
    
    private func setHierarchy() {
        backgroundColor = .secondarySystemBackground
        addSubviews([logoImage, emailTextField, passwordTextField, loginButton, signupButton, spinner])
    }
    
    private func setConstraints() {
        let padding: CGFloat = 20
        
        NSLayoutConstraint.activate([
            logoImage.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            logoImage.centerXAnchor.constraint(equalTo: centerXAnchor),
            logoImage.widthAnchor.constraint(equalToConstant: 200),
            logoImage.heightAnchor.constraint(equalTo: logoImage.widthAnchor),
            
            emailTextField.topAnchor.constraint(equalTo: logoImage.bottomAnchor, constant: padding),
            emailTextField.leadingAnchor.constraint(equalTo: leadingAnchor, constant: padding),
            emailTextField.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -padding),
            
            passwordTextField.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: padding),
            passwordTextField.leadingAnchor.constraint(equalTo: emailTextField.leadingAnchor),
            passwordTextField.trailingAnchor.constraint(equalTo: emailTextField.trailingAnchor),
            
            loginButton.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: padding),
            loginButton.leadingAnchor.constraint(equalTo: emailTextField.leadingAnchor),
            loginButton.trailingAnchor.constraint(equalTo: emailTextField.trailingAnchor),
            
            signupButton.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -padding),
            signupButton.leadingAnchor.constraint(equalTo: emailTextField.leadingAnchor),
            signupButton.trailingAnchor.constraint(equalTo: emailTextField.trailingAnchor),
            
            spinner.centerXAnchor.constraint(equalTo: loginButton.centerXAnchor),
            spinner.centerYAnchor.constraint(equalTo: loginButton.centerYAnchor),
        ])
    }
}

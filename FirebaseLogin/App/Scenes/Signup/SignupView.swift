//
//  SignupView.swift
//  FirebaseLogin
//
//  Created by Diggo Silva on 02/02/25.
//

import UIKit

protocol SignupViewDelegate: AnyObject {
    func signupButtonTapped()
    func loginButtonTapped()
}

class SignupView: UIView {
    
    // MARK: - UI Elements
    
    lazy var logoImage = buildLogoImageView()
    lazy var emailTextField = buildTextfield(placeholder: "Email")
    lazy var passwordTextField = buildTextfield(placeholder: "Senha", keyboardType: .default, isSecureTextEntry: true)
    lazy var confirmPasswordTextField = buildTextfield(placeholder: "Confirmar senha", keyboardType: .default, isSecureTextEntry: true)
    lazy var signupButton = buildButton(title: "Cadastrar", color: .systemBlue, selector: #selector(signupButtonTapped))
    lazy var loginButton = buildButtonWith2Texts(title1: "Já tem uma conta?  ", title2: "Logar!", selector: #selector(loginButtonTapped))
    lazy var spinner = buildSpinner()
    
    // MARK: - Properties
    
    weak var delegate: SignupViewDelegate?
    
    // MARK: - Initializer
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        setupView()
    }
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    // MARK: - Button Actions
    
    @objc private func signupButtonTapped() {
        delegate?.signupButtonTapped()
    }
    
    @objc private func loginButtonTapped() {
        delegate?.loginButtonTapped()
    }
    
    // MARK: - Setup Methods
    
    private func setupView() {
        setHierarchy()
        setConstraints()
    }
    
    // MARK: - Layout Methods
    
    private func setHierarchy() {
        backgroundColor = .secondarySystemBackground
        addSubviews([logoImage, emailTextField, passwordTextField, confirmPasswordTextField, signupButton, loginButton, spinner])
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
            
            confirmPasswordTextField.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: padding),
            confirmPasswordTextField.leadingAnchor.constraint(equalTo: emailTextField.leadingAnchor),
            confirmPasswordTextField.trailingAnchor.constraint(equalTo: emailTextField.trailingAnchor),
            
            signupButton.topAnchor.constraint(equalTo: confirmPasswordTextField.bottomAnchor, constant: padding),
            signupButton.leadingAnchor.constraint(equalTo: emailTextField.leadingAnchor),
            signupButton.trailingAnchor.constraint(equalTo: emailTextField.trailingAnchor),
            
            loginButton.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor),
            loginButton.leadingAnchor.constraint(equalTo: emailTextField.leadingAnchor),
            loginButton.trailingAnchor.constraint(equalTo: emailTextField.trailingAnchor),
            
            spinner.centerXAnchor.constraint(equalTo: signupButton.centerXAnchor),
            spinner.centerYAnchor.constraint(equalTo: signupButton.centerYAnchor),
        ])
    }
}

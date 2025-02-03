//
//  SignupController.swift
//  FirebaseLogin
//
//  Created by Diggo Silva on 02/02/25.
//

import UIKit

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
    
    private func setNavBar() {
        title = "TELA DE CADASTRO"
        navigationItem.hidesBackButton = true
    }
    
    private func setDelegatesAndDataSources() {
        signupView.delegate = self
    }
}

extension SignupController: SignupViewDelegate {
    func signupButtonTapped() {
        print("Tela de CADASTRO: Clicou no botão CADASTRAR")
    }
    
    func loginButtonTapped() {
        navigationController?.popToRootViewController(animated: true)
    }
}

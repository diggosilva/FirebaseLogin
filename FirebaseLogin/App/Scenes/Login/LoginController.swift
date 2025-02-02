//
//  ViewController.swift
//  FirebaseLogin
//
//  Created by Diggo Silva on 02/02/25.
//

import UIKit

class LoginController: UIViewController {
    
    let loginView = LoginView()
    
    override func loadView() {
        super.loadView()
        view = loginView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setNavBar()
        setDelegatesAndDataSources()
    }
    
    private func setNavBar() {
        title = "TELA DE LOGIN"
    }
    
    private func setDelegatesAndDataSources() {
        
    }
}

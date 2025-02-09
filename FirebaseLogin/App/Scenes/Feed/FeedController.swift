//
//  FeedController.swift
//  FirebaseLogin
//
//  Created by Diggo Silva on 03/02/25.
//

import UIKit
import FirebaseAuth

class FeedController: UIViewController {
    
    // MARK: - Properties
    let feedView = FeedView()
    
    // MARK: - Lifecycle
    override func loadView() {
        super.loadView()
        view = feedView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setNavBar()
        setDelegates()
    }
    
    // MARK: - Configuration
    private func setNavBar() {
        title = "VOCÊ ESTÁ LOGADO"
        navigationItem.hidesBackButton = true
    }
    
    private func setDelegates() {
        feedView.delegate = self
    }
}

// MARK: - FeedViewDelegate
extension FeedController: FeedViewDelegate {
    func signoutButtonTapped() {
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
            navigationController?.popToRootViewController(animated: true)
        } catch let signOutError as NSError {
            print("Erro ao tentar se desconectar: \(signOutError.localizedDescription)")
        }
    }
}

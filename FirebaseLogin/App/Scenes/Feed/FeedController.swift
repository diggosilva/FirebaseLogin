//
//  FeedController.swift
//  FirebaseLogin
//
//  Created by Diggo Silva on 03/02/25.
//

import UIKit
import FirebaseAuth

class FeedController: UIViewController {
    
    let feedView = FeedView()
    
    override func loadView() {
        super.loadView()
        view = feedView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setNavBar()
        setDelegatesAndDataSources()
    }
    
    private func setNavBar() {
        title = "VOCÊ ESTÁ LOGADO"
        navigationItem.hidesBackButton = true
    }
    
    private func setDelegatesAndDataSources() {
        feedView.delegate = self
    }
}

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

//
//  AuthService.swift
//  FirebaseLogin
//
//  Created by Diggo Silva on 09/02/25.
//

import UIKit
import FirebaseAuth

protocol AuthServiceProtocol {
    func checkIfUserIsLoggedIn() -> UserModel?
    func signIn(email: String, password: String, completion: @escaping(Result<String, LoginError>) -> Void)
}

class AuthService: AuthServiceProtocol {
    func checkIfUserIsLoggedIn() -> UserModel? {
        if let user = Auth.auth().currentUser {
            return UserModel(email: user.email ?? "")
        }
        return nil
    }
    
    func signIn(email: String, password: String, completion: @escaping (Result<String, LoginError>) -> Void) {
        let firebaseAuth = Auth.auth()
        firebaseAuth.signIn(withEmail: email, password: password) { authResult, error in
            if error != nil {
                completion(.failure(.loginFailed))
                return
            }
            if let userEmail = authResult?.user.email {
                completion(.success(userEmail))
            }
        }
    }
}
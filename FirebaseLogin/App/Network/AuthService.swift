//
//  AuthService.swift
//  FirebaseLogin
//
//  Created by Diggo Silva on 09/02/25.
//

import FirebaseAuth

protocol AuthServiceProtocol {
    func checkIfUserIsLoggedIn() -> UserModel?
    func loginUser(email: String, password: String, completion: @escaping(Result<String, LoginError>) -> Void)
    func registerUser(email: String, password: String, completion: @escaping(Result<String, SignupError>) -> Void)
    func logoutUser()
}

class AuthService: AuthServiceProtocol {
    let firebaseAuth = Auth.auth()
    
    func checkIfUserIsLoggedIn() -> UserModel? {
        guard let user = firebaseAuth.currentUser else { return nil }
        return UserModel(email: user.email ?? "")
    }
    
    func loginUser(email: String, password: String, completion: @escaping (Result<String, LoginError>) -> Void) {
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
    
    func registerUser(email: String, password: String, completion: @escaping(Result<String, SignupError>) -> Void) {
        firebaseAuth.createUser(withEmail: email, password: password) { authResult, error in
            if error != nil {
                completion(.failure(.signupFailed))
                return
            }
            if let userEmail = authResult?.user.email {
                completion(.success(userEmail))
                return
            }
        }
    }
    
    func logoutUser() {
        do {
            try firebaseAuth.signOut()
        } catch {
            print("Erro ao fazer logout: \(error.localizedDescription)")
        }
    }
}

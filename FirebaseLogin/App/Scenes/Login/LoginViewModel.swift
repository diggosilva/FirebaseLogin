//
//  LoginViewModel.swift
//  FirebaseLogin
//
//  Created by Diggo Silva on 09/02/25.
//

import UIKit

enum LoginError: String, Error {
    case invalidEmail = "O e-mail informado é inválido. Ex: exemplo@dominio.com"
    case invalidPassword = "A senha deve ter pelo menos 6 caracteres"
    case loginFailed = "Erro ao realizar o login. Por favor verifique suas credenciais e tente novamente."
    
    var localizedDescription: String {
        return self.rawValue
    }
}

protocol LoginViewModelProtocol {
    func checkIfUserIsLoggedIn() -> UserModel?
    func validateEmail(_ email: String) -> Result<String, LoginError>
    func validatePassword(_ password: String) -> Result<String, LoginError>
    func authenticateUser(email: String, password: String, completion: @escaping(Result<String, LoginError>) -> Void)
}

class LoginViewModel: LoginViewModelProtocol {
    
    // MARK: - Properties
    private let authService: AuthServiceProtocol
    
    init(authService: AuthServiceProtocol = AuthService()) {
        self.authService = authService
    }
    
    func checkIfUserIsLoggedIn() -> UserModel? {
        return authService.checkIfUserIsLoggedIn()
    }
    
    // MARK: - Validation Methods
    func validateEmail(_ email: String) -> Result<String, LoginError> {
        guard !email.trimmingCharacters(in: .whitespaces).isEmpty else {
            return .failure(.invalidEmail)
        }
        
        guard isValidEmail(email) else {
            return .failure(.invalidEmail)
        }
        return .success(email)
    }
    
    func validatePassword(_ password: String) -> Result<String, LoginError> {
        guard password.count >= 6 else {
            return .failure(.invalidPassword)
        }
        return .success(password)
    }
    
    // MARK: - Authentication Method
    func authenticateUser(email: String, password: String, completion: @escaping(Result<String, LoginError>) -> Void) {
        authService.loginUser(email: email, password: password) { result in
            switch result {
            case .success(let email):
                completion(.success(email))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    // MARK: - Helper Methods
    private func isValidEmail(_ email: String) -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailTest = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return emailTest.evaluate(with: email)
    }
}

//
//  SignupViewModel.swift
//  FirebaseLogin
//
//  Created by Diggo Silva on 10/02/25.
//

import Foundation

enum SignupError: String, Error {
    case invalidEmail = "O e-mail informado é inválido. Ex: exemplo@dominio.com"
    case invalidPassword = "A senha deve ter pelo menos 6 caracteres"
    case passwordMismatch = "As senhas não coincidem. Por favor, verifique."
    case signupFailed = "Falha ao tentar cadastrar o usuário. Tente novamente."
    case logoutFailed = "Erro ao fazer logout. Tente novamente."
    
    var localizedDescription: String {
        return rawValue
    }
}

protocol SignupViewModelProtocol {
    func validateEmail(_ email: String) -> Result<String, SignupError>
    func validatePassword(_ password: String) -> Result<String, SignupError>
    func validateConfirmPassword(_ confirmPassword: String, _ password: String) -> Result<String, SignupError>
    func registerUser(email: String, password: String, completion: @escaping (Result<String, SignupError>) -> Void)
    func logoutUser()
}

class SignupViewModel: SignupViewModelProtocol {
    
    // MARK: - Properties
    private let authService: AuthServiceProtocol
    
    init(authService: AuthServiceProtocol = AuthService()) {
        self.authService = authService
    }
    
    // MARK: - Validation Methods
    func validateEmail(_ email: String) -> Result<String, SignupError> {
        guard !email.trimmingCharacters(in: .whitespaces).isEmpty else {
            return .failure(.invalidEmail)
        }
        
        guard isValidEmail(email) else {
            return .failure(.invalidEmail)
        }
        return .success(email)
    }
    
    func validatePassword(_ password: String) -> Result<String, SignupError> {
        guard password.count >= 6 else {
            return .failure(.invalidPassword)
        }
        return .success(password)
    }
    
    func validateConfirmPassword(_ confirmPassword: String, _ password: String) -> Result<String, SignupError> {
        guard confirmPassword == password else {
            return .failure(.passwordMismatch)
        }
        return .success(confirmPassword)
    }
    
    // MARK: - Register Method
    func registerUser(email: String, password: String, completion: @escaping (Result<String, SignupError>) -> Void) {
        authService.registerUser(email: email, password: password) { result in
            switch result {
            case .success(let email):
                completion(.success(email))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func logoutUser() {
        authService.logoutUser()
    }
    
    // MARK: - Helper Methods
    private func isValidEmail(_ email: String) -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailTest = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return emailTest.evaluate(with: email)
    }
}

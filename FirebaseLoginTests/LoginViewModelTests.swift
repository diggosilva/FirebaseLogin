//
//  LoginViewModelTests.swift
//  FirebaseLoginTests
//
//  Created by Diggo Silva on 14/03/25.
//

import XCTest
@testable import FirebaseLogin

class MockLogin: AuthServiceProtocol {
    var isSuccess: Bool = true
    
    func checkIfUserIsLoggedIn() -> UserModel? { return UserModel(email: "test@email.com") }
    
    func loginUser(email: String, password: String, completion: @escaping (Result<String, LoginError>) -> Void) {
        if !isSuccess {
            completion(.failure(.loginFailed))
        } else if !isValidEmail(email) {
            completion(.failure(.invalidEmail))
        } else if password.count < 6 {
            completion(.failure(.invalidPassword))
        } else {
            completion(.success(email))
        }
    }
    
    func registerUser(email: String, password: String, completion: @escaping (Result<String, SignupError>) -> Void) {}
    
    func logoutUser() {}
    
    func isValidEmail(_ email: String) -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailTest = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return emailTest.evaluate(with: email)
    }
}

final class LoginViewModelTests: XCTestCase {
    
    //MARK: TESTS SUCCESS
    func testWhenValidateEmailIsSuccess() {
        let authService = MockLogin()
        let sut = LoginViewModel(authService: authService)
        
        let result = sut.validateEmail("test@email.com")
        
        switch result {
        case .success(let email):
            XCTAssertEqual(email, "test@email.com")
        case .failure(_):
            XCTFail("A validação não deveria falhar, mas falhou!")
        }
    }
    
    func testWhenValidateEmailIsFailure() {
        let authService = MockLogin()
        let sut = LoginViewModel(authService: authService)
        
        let result = sut.validateEmail("invalidEmail.com")
        
        switch result {
        case .success(_):
            XCTFail("Deveria retornar um erro de email inválido. Mas a validação foi bem-sucedida.")
        case .failure(let error):
            XCTAssertEqual(error, .invalidEmail)
        }
    }
    
    func testWhenValidateEmailIsEmpty() {
        let authService = MockLogin()
        let sut = LoginViewModel(authService: authService)
        
        let result = sut.validateEmail("")
        
        switch result {
        case .success(_):
            XCTFail("Deveria retornar um erro de email inválido. Mas a validação foi bem-sucedida.")
        case .failure(let error):
            XCTAssertEqual(error, .invalidEmail)
        }
    }
    
    func testWhenValidateEmailHasWhiteSpaces() {
        let authService = MockLogin()
        let sut = LoginViewModel(authService: authService)
        
        let result = sut.validateEmail(" ")
        
        switch result {
        case .success(_):
            XCTFail("Deveria retornar um erro de email inválido. Mas a validação foi bem-sucedida.")
        case .failure(let error):
            XCTAssertEqual(error, .invalidEmail)
        }
    }
    
    func testWhenValidatePasswordIsSuccess() {
        let authService = MockLogin()
        let sut = LoginViewModel(authService: authService)
        
        let result = sut.validatePassword("123456")
        
        switch result {
        case .success(let password):
            XCTAssertEqual(password, "123456")
        case .failure(_):
            XCTFail("A validação deveria ser sucesso, mas FALHOU!")
        }
    }
    
    func testWhenValidatePasswordIsEmpty() {
        let authService = MockLogin()
        let sut = LoginViewModel(authService: authService)
        
        let result = sut.validatePassword("")
        
        switch result {
        case .success(_):
            XCTFail("Deveria retornar um erro de senha inválida. Mas a validação foi bem-sucedida.")
        case .failure(let error):
            XCTAssertEqual(error, .invalidPassword)
        }
    }
    
    func testWhenValidatePasswordHasWhiteSpaces() {
        let authService = MockLogin()
        let sut = LoginViewModel(authService: authService)
        
        let result = sut.validatePassword(" ")
        
        switch result {
        case .success(_):
            XCTFail("Deveria retornar um erro de senha inválida. Mas a validação foi bem-sucedida.")
        case .failure(let error):
            XCTAssertEqual(error, .invalidPassword)
        }
    }
    
    func testWhenValidatePasswordHasLessThanSixDigits() {
        let authService = MockLogin()
        let sut = LoginViewModel(authService: authService)
        
        let result = sut.validatePassword("12345")
        
        switch result {
        case .success(_):
            XCTFail("Deveria retornar um erro de senha inválida. Mas a validação foi bem-sucedida.")
        case .failure(let error):
            XCTAssertEqual(error, .invalidPassword)
        }
    }
    
    func testWhenAuthenticateIsSuccess() {
        let authService = MockLogin()
        let sut = LoginViewModel(authService: authService)
        
        let _ = sut.authenticateUser(email: "test@email.com", password: "123456") { result in
            
            switch result {
            case .success(let email):
                XCTAssertEqual(email, "test@email.com")
            case .failure(_):
                XCTFail("A autenticação deveria ser sucesso, mas FALHOU!")
            }
        }
    }
    
    func testWhenAuthenticateHasInvalidEmail() {
        let authService = MockLogin()
        let sut = LoginViewModel(authService: authService)
        
        let _ = sut.authenticateUser(email: "testemail.com", password: "123456") { result in
            
            switch result {
            case .success(_):
                XCTFail("A autenticação deveria falhar, mas teve SUCESSO!")
            case .failure(let error):
                XCTAssertEqual(error, .invalidEmail)
            }
        }
    }
    
    func testWhenAuthenticateHasInvalidpassword() {
        let authService = MockLogin()
        let sut = LoginViewModel(authService: authService)
        
        let _ = sut.authenticateUser(email: "test@mail.com", password: "12345") { result in
            
            switch result {
            case .success(_):
                XCTFail("A autenticação deveria falhar, mas teve SUCESSO!")
            case .failure(let error):
                XCTAssertEqual(error, .invalidPassword)
            }
        }
    }
    
    func testWhenAuthenticateCalledWithoutParameters() {
        let authService = MockLogin()
        let sut = LoginViewModel(authService: authService)
        let _ = sut.authenticateUser(email: "", password: "") { result in
            
            switch result {
            case .success(_):
                XCTFail("Deveria ter sido um erro de validação de email e senha, mas teve SUCESSO!")
            case .failure(let error):
                XCTAssertEqual(error, .invalidEmail)
            }
        }
    }
    
    func testWhenAuthenticateCalledWithoutPassword() {
        let authService = MockLogin()
        let sut = LoginViewModel(authService: authService)
        let _ = sut.authenticateUser(email: "test@mail.com", password: "") { result in
            
            switch result {
            case .success(_):
                XCTFail("Deveria ter sido um erro de validação de email e senha, mas teve SUCESSO!")
            case .failure(let error):
                XCTAssertEqual(error, .invalidPassword)
            }
        }
    }
    
    //MARK: TESTS FAILURE
    func testWhenAuthenticateIsFailure() {
        let authService = MockLogin()
        authService.isSuccess = false
        
        let sut = LoginViewModel(authService: authService)
        
        let _ = sut.authenticateUser(email: "test@email.com", password: "123456") { result in
            
            switch result {
            case .success(_):
                XCTFail("A autenticação deveria falhar, mas teve SUCESSO!")
            case .failure(let error):
                XCTAssertEqual(error, .loginFailed)
            }
        }
    }
}

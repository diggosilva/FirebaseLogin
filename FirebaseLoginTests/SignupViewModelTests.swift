//
//  SignupViewModelTests.swift
//  FirebaseLoginTests
//
//  Created by Diggo Silva on 13/03/25.
//

import XCTest
@testable import FirebaseLogin

class MockSignup: AuthServiceProtocol {
    var isSuccess: Bool = true
    var logoutCalled: Bool = false
    
    func checkIfUserIsLoggedIn() -> UserModel? {
        return nil
    }
    
    func loginUser(email: String, password: String, completion: @escaping (Result<String, LoginError>) -> Void) {}
    
    func registerUser(email: String, password: String, completion: @escaping (Result<String, SignupError>) -> Void) {
        if isSuccess {
            completion(.success(email))
        } else {
            completion(.failure(.signupFailed))
        }
    }
    
    func logoutUser() {logoutCalled = true }
}

final class SignupViewModelTests: XCTestCase {
    
    //MARK: TESTS SUCCESS
    func testWhenValidateEmailIsSuccess() {
        let mockAuthService = MockSignup()
        let sut = SignupViewModel(authService: mockAuthService)
        let result = sut.validateEmail("test@email.com")
        
        switch result {
        case .success(let email):
            XCTAssertEqual(email, "test@email.com")
            
        case .failure:
            XCTFail("A validação do email deveria ter sido bem-sucedida para um email válido.")
        }
    }
    
    func testWhenValidateEmailIsFailure() {
        let mockAuthService = MockSignup()
        let sut = SignupViewModel(authService: mockAuthService)
        let result = sut.validateEmail("invalidemail.com")
        
        switch result {
        case .success(_):
            XCTFail("Deveria retornar um erro de email inválido. Mas a validação foi bem-sucedida.")
            
        case .failure(let error):
            XCTAssertEqual(error, .invalidEmail)
        }
    }
    
    func testWhenValidateEmailIsEmpty() {
        let mockAuthService = MockSignup()
        let sut = SignupViewModel(authService: mockAuthService)
        let result = sut.validateEmail("")
        
        switch result {
        case .success(_):
            XCTFail("A validação do email deveria ter falhado para um email vazio.")
        case .failure(let error):
            XCTAssertEqual(error, .invalidEmail)
        }
    }
    
    func testWhenValidateEmailHasWhiteSpaces() {
        let mockAuthService = MockSignup()
        let sut = SignupViewModel(authService: mockAuthService)
        let result = sut.validateEmail(" ")
        
        switch result {
        case .success(_):
            XCTFail("A validação do email deveria ter falhado para um email vazio.")
        case .failure(let error):
            XCTAssertEqual(error, .invalidEmail)
        }
    }
    
    func testWhenValidatePasswordIsSuccess() {
        let mockAuthService = MockSignup()
        let sut = SignupViewModel(authService: mockAuthService)
        let result = sut.validatePassword("123456")
        
        switch result {
        case .success(let password):
            XCTAssertEqual(password, "123456")
            
        case .failure:
            XCTFail("A validação da senha deveria ter sido bem-sucedida para uma senha válida.")
        }
    }
    
    func testWhenPasswordIsLessThanSixCharacters() {
        let mockAuthService = MockSignup()
        let sut = SignupViewModel(authService: mockAuthService)
        let result = sut.validatePassword("12345")
        
        switch result {
        case .success(_):
            XCTFail("Deveria retornar um erro de senha inválida. Mas a validação foi bem-sucedida.")
        case .failure(let error):
            XCTAssertEqual(error, .invalidPassword)
        }
    }
    
    func testWhenConfirmPasswordIsSuccess() {
        let mockAuthService = MockSignup()
        let sut = SignupViewModel(authService: mockAuthService)
        let result = sut.validateConfirmPassword("123456", "123456")
        
        switch result {
        case .success(let confirmPassword):
            XCTAssertEqual(confirmPassword, "123456")
        case .failure:
            XCTFail("A validação da confirmação de senha deveria ter sido bem-sucedida para uma senha válida.")
        }
    }
    
    func testWhenConfirmPasswordMismatch() {
        let mockAuthService = MockSignup()
        let sut = SignupViewModel(authService: mockAuthService)
        let result = sut.validateConfirmPassword("123456", "654321")
        
        switch result {
        case .success(_):
            XCTFail("Deveria retornar um erro de senha inválida. Mas a validação foi bem-sucedida.")
        case .failure(let error):
            XCTAssertEqual(error, .passwordMismatch)
        }
    }
    
    func testWhenRegisterIsSuccess() {
        let mockAuthService = MockSignup()
        let sut = SignupViewModel(authService: mockAuthService)
        
        sut.registerUser(email: "test@email.com", password: "123456") { result in
            
            switch result {
            case .success(let email):
                XCTAssertEqual(email, "test@email.com")
            case .failure(_):
                XCTFail("O registro deveria ter sido bem-sucedido.")
            }
        }
    }
    
    func testWhenLogoutUserIsCalled() {
        let mockAuthService = MockSignup()
        let sut = SignupViewModel(authService: mockAuthService)
        
        sut.logoutUser()
        
        XCTAssertTrue(mockAuthService.logoutCalled, "O método logoutUser deveria ter sido chamado.")
    }

    
    //MARK: TESTS FAILURE
    func testWhenRegisterIsFailure() {
        let mockAuthService = MockSignup()
        mockAuthService.isSuccess = false
        
        let sut = SignupViewModel(authService: mockAuthService)
        
        sut.registerUser(email: "test@email.com", password: "123456") { result in
            
            switch result {
            case .success(_):
                XCTFail("O registro deveria ter falhado.")
            case .failure(let error):
                XCTAssertEqual(error, .signupFailed)
            }
        }
    }
    
    func testWhenRegisterIsCalledWithoutParameters() {
        let mockAuthService = MockSignup()
        mockAuthService.isSuccess = false
        
        let sut = SignupViewModel(authService: mockAuthService)
        
        sut.registerUser(email: "", password: "") { result in
            
            switch result {
            case .success(_):
                XCTFail("O registro deveria ter falhado.")
            case .failure(let error):
                XCTAssertEqual(error, .signupFailed)
            }
        }
    }
}

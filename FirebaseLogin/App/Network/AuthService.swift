class AuthService: AuthServiceProtocol {
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
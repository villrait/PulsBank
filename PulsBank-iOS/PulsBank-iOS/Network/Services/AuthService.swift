import Foundation

final class AuthService {
    private let apiClient: APIClient
    
    init(apiClient: APIClient) {
        print("🔧 [AuthService] init - создание")
        self.apiClient = apiClient
    }
    
    func register(email: String, password: String, completion: @escaping (Result<AuthResponse, APIError>) -> Void) {
        print("🔧 [AuthService] register(email:) - запрос для email: \(email)")
        let request = RegisterRequest(email: email, password: password)
        apiClient.request(.register, body: request, completion: completion)
    }
    
    func login(email: String, password: String, completion: @escaping (Result<AuthResponse, APIError>) -> Void) {
        print("🔧 [AuthService] login(email:) - запрос для email: \(email)")
        let request = LoginRequest(email: email, password: password)
        apiClient.request(.login, body: request, completion: completion)
    }
}

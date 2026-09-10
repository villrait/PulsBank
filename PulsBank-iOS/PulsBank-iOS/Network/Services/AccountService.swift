import Foundation

final class AccountService: AccountServiceProtocol {
    private let apiClient: APIClient
    
    init(apiClient: APIClient) {
        print("🔧 [AccountService] init - создание")
        self.apiClient = apiClient
    }
    
    func getBalance(userId: Int, completion: @escaping (Result<Decimal, APIError>) -> Void) {
        print("💰 [AccountService] getBalance(userId:) - запрос для userId: \(userId)")
        apiClient.request(.balance(userId: userId)) { (result: Result<BalanceResponse, APIError>) in
            switch result {
            case .success(let response):
                completion(.success(response.balance))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}

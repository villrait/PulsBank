import Foundation

protocol AccountServiceProtocol {
    func getBalance(userId: Int, completion: @escaping (Result<Decimal, APIError>) -> Void)
}

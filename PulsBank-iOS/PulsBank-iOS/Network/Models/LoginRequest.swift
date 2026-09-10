import Foundation

// DTO для отправки запроса логина
struct LoginRequest: Encodable {
    let email: String
    let password: String
}

import Foundation

/// Все эндпоинты приложения
enum APIEndpoint {
    case register
    case login
    case balance(userId: Int)
    case transfer
    
    /// Относительный путь
    var path: String {
        switch self {
        case .register:
            return "/auth/register"
        case .login:
            return "/auth/login"
        case .balance:
            return "/account/balance"
        case .transfer:
            return "/transfer"
        }
    }
    
    /// HTTP метод
    var method: String {
        switch self {
        case .balance:
            return "GET"
        case .register, .login, .transfer:
            return "POST"
        }
    }
}

import Foundation
import Alamofire

/// Управляет настройками сети: baseURL, заголовки, сессия.
/// Содержит всю конфигурацию, необходимую для выполнения сетевых запросов.
final class APIManager {
    // MARK: - Singleton
    /// Единый экземпляр менеджера, доступный во всём приложении.
    static let shared = APIManager()
    
    // MARK: - Network Configuration
    /// Базовый URL бэкенда (локальный сервер для разработки).
    /// В будущем можно будет переключать между DEV, STAGE, PROD.
    //let baseURL = "http://localhost:8080"
    let baseURL = "http://192.168.0.193:8080"
    
    /// Общие заголовки, добавляемые к каждому запросу.
    /// Здесь указываются постоянные параметры, например Content-Type.
    /// Позже сюда добавится авторизационный токен (Bearer).
    var headers: HTTPHeaders {
        let headers: HTTPHeaders = [
            "Content-Type": "application/json"
        ]
        // Пример добавления токена:
        // if let token = TokenManager.shared.token {
        //     headers["Authorization"] = "Bearer \(token)"
        // }
        return headers
    }
    
    /// Настроенная сессия Alamofire.
    /// Используется для выполнения всех запросов. В ней заданы таймауты и другие параметры.
    let session: Session
    
    // MARK: - Initialization
    private init() {
        print("🌐 [APIManager] init - baseURL: \(baseURL)")
        // Базовая конфигурация URLSession
        let configuration = URLSessionConfiguration.default
        // Таймаут для одного запроса (в секундах)
        configuration.timeoutIntervalForRequest = 30
        // Таймаут для загрузки ресурса (общее время выполнения запроса)
        configuration.timeoutIntervalForResource = 60
        // Создаём сессию Alamofire с нашей конфигурацией
        session = Session(configuration: configuration)
    }
}

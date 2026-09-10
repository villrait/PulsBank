import Foundation
import Alamofire

/// Кастомные ошибки сети.
/// Используются для унификации обработки ошибок на уровне приложения.
enum APIError: Error {
    
    /// Неверный URL (не удалось сформировать)
    case invalidURL
    
    /// Сервер вернул пустой ответ (data == nil)
    case noData
    
    /// Ошибка при декодировании JSON в модель (например, несоответствие типов)
    case decodingError(Error)
    
    /// Ошибка на стороне сервера (4xx, 5xx) с конкретным кодом статуса
    case serverError(statusCode: Int)
    
    /// Ошибка сети (таймаут, отсутствие соединения, проблемы с сертификатом и т.д.)
    case networkError(Error)
    
    /// Преобразует ошибку, полученную от Alamofire (AFError), в наш тип APIError.
    /// - Parameters:
    ///   - error: Исходная ошибка (обычно AFError или другая Error)
    ///   - data: Данные ответа (могут пригодиться для логирования или дополнительной обработки)
    /// - Returns: Экземпляр APIError, соответствующий исходной ошибке.
    static func from(error: Error, data: Data?) -> APIError {
        // Пытаемся привести ошибку к Alamofire.AFError
        if let afError = error.asAFError {
            // Если это ошибка валидации (например, статус код не 2xx)
            switch afError {
            case .responseValidationFailed(reason: .unacceptableStatusCode(let code)):
                // Возвращаем serverError с полученным кодом
                return .serverError(statusCode: code)
            default:
                // Любые другие ошибки Alamofire (таймауты, отсутствие сети, проблемы с SSL) — networkError
                return .networkError(afError)
            }
        } else {
            // Если ошибка не от Alamofire (например, возникла на уровне URLSession), тоже networkError
            return .networkError(error)
        }
    }
}

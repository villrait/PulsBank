import Foundation
import Alamofire

final class APIClient {
    static let shared = APIClient()
    private let manager = APIManager.shared
    private let encoder = JSONEncoder()
    private let decoder = JSONDecoder()
    
    private struct Empty: Encodable {}
    
    private init() {}
    
    func request<T: Decodable>(
        _ endpoint: APIEndpoint,
        completion: @escaping (Result<T, APIError>) -> Void
    ) {
        request(endpoint, body: nil as Empty?, completion: completion)
    }
    
    func request<T: Decodable, U: Encodable>(
        _ endpoint: APIEndpoint,
        body: U? = nil,
        completion: @escaping (Result<T, APIError>) -> Void
    ) {
        print("🌐 [APIClient] request - эндпоинт: \(endpoint), метод: \(endpoint.method)")
        
        let urlString = manager.baseURL + endpoint.path
        guard let url = URL(string: urlString) else {
            print("❌ [APIClient] Неверный URL: \(urlString)")
            completion(.failure(.invalidURL))
            return
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = endpoint.method
        urlRequest.allHTTPHeaderFields = manager.headers.dictionary
        
        if let body = body {
            do {
                urlRequest.httpBody = try encoder.encode(body)
                urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
            } catch {
                completion(.failure(.decodingError(error)))
                return
            }
        }
        
#if DEBUG
        var bodyString = "nil"
        if let body = body,
           let data = try? encoder.encode(body),
           let str = String(data: data, encoding: .utf8) {
            bodyString = str
        }
        APILogger.logRequest(url: urlString, method: endpoint.method, body: bodyString)
#endif
        
        manager.session.request(urlRequest)
            .validate()
            .responseData { response in
                
#if DEBUG
                APILogger.logResponse(
                    data: response.data,
                    statusCode: response.response?.statusCode
                )
#endif
                print("🌐 [APIClient] Получен ответ для \(endpoint)")
                switch response.result {
                case .success(let data):
                    print("✅ [APIClient] Успешный ответ, декодируем \(T.self)")
                    do {
                        let decoded = try JSONDecoder().decode(T.self, from: data)
                        completion(.success(decoded))
                    } catch {
                        completion(.failure(.decodingError(error)))
                    }
                    
                case .failure(let error):
                    print("❌ [APIClient] Ошибка запроса: \(error)")
                    let apiError = APIError.from(error: error, data: response.data)
                    completion(.failure(apiError))
                }
            }
    }
}

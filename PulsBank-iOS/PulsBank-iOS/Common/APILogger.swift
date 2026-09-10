import Foundation

struct APILogger {
    // Существующий метод (не трогаем)
    static func logRequest(url: String, method: String, body: String) {
        #if DEBUG
        print("\n📡 ---------- REQUEST ----------")
        print("🔹 [\(method)] \(url)")
        print("🔸 Body: \(body)")
        print("-------------------------------\n")
        #endif
    }
    
    // Новый метод, принимающий строку body
    static func logResponse(data: Data?, statusCode: Int?) {
        #if DEBUG
        print("\n✅ ---------- RESPONSE ----------")
        print("🔹 Status code: \(statusCode ?? 0)")
        if let data = data,
           let json = try? JSONSerialization.jsonObject(with: data, options: .mutableContainers) {
            print("🔸 Response: \(json)")
        }
        print("--------------------------------\n")
        #endif
    }
    
    // logResponse без изменений
}

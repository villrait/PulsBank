import Alamofire

/// Расширение для конвертации строки в HTTPMethod Alamofire
extension String {
    func toHTTPMethod() -> HTTPMethod {
        switch self.uppercased() {
        case "GET":
            return .get
        case "POST":
            return .post
        case "PUT":
            return .put
        case "DELETE":
            return .delete
        default:
            return .get
        }
    }
}

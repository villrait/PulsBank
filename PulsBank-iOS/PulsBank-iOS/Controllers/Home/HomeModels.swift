import Foundation

enum Home {
    struct Request {}
    struct Response {
        let balance: Decimal
    }
    struct ViewModel {
        let balance: String
    }
}

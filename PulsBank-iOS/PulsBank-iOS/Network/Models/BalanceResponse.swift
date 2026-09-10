import Foundation

struct BalanceResponse: Decodable {
    let userId: Int
    let balance: Decimal
}

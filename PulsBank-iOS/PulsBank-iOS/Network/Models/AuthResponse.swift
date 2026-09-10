// Модель ответа сервера на регистрацию/логин
struct AuthResponse: Decodable {
    let userId: Int
    let email: String
    let message: String
}

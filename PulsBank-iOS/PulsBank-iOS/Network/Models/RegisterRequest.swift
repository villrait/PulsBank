// Модель для отправки запроса регистрации на сервер
struct RegisterRequest: Encodable {
    let email: String
    let password: String
}

import Foundation

final class LoginPresenter {
    weak var view: LoginViewProtocol?
    private let authService: AuthService

    init(authService: AuthService) {
        print("📝 [LoginPresenter] init - создание")
        self.authService = authService
    }

    func login(email: String?, password: String?) {
        print("📝 [LoginPresenter] login(email:) - попытка входа для email: \(email ?? "nil")")
        guard let email = email, !email.isEmpty,
              let password = password, !password.isEmpty else {
            view?.showError(message: "Заполните все поля")
            return
        }
        guard email.contains("@") else {
            view?.showError(message: "Некорректный email")
            return
        }

        view?.showLoading(true)

        authService.login(email: email, password: password) { [weak self] result in
            DispatchQueue.main.async {
                self?.view?.showLoading(false)
                switch result {
                case .success(let response):
                    print("📝 [LoginPresenter] login - успех, userId: \(response.userId)")
                    // Проверяем, что сервер вернул "ok" (логин успешен)
                    if response.message == "ok" {
                        self?.view?.navigateToMain(userId: response.userId, email: response.email)
                    } else {
                        self?.view?.showError(message: "Неверный email или пароль")
                    }
                case .failure(let error):
                    print("📝 [LoginPresenter] login - ошибка: \(error)")
                    let errorMessage: String
                    switch error {
                    case .serverError(let code):
                        errorMessage = "Ошибка сервера: \(code)"
                    default:
                        errorMessage = "Ошибка сети: \(error.localizedDescription)"
                    }
                    self?.view?.showError(message: errorMessage)
                }
            }
        }
    }
}

import Foundation

// Презентер для экрана регистрации
final class RegisterPresenter {
    weak var view: RegisterViewProtocol?
    private let authService: AuthService

    init(authService: AuthService) {
        print("📝 [RegisterPresenter] init - создание")
        self.authService = authService
    }

    // Вызывается, когда пользователь нажал кнопку "Зарегистрироваться"
    func register(email: String?, password: String?) {
        print("📝 [RegisterPresenter] register(email:) - попытка регистрации для email: \(email ?? "nil")")
        // Простая валидация
        guard let email = email, !email.isEmpty,
              let password = password, !password.isEmpty else {
            view?.showError(message: "Пожалуйста, заполните все поля")
            return
        }
        guard email.contains("@") else {
            view?.showError(message: "Введите корректный email")
            return
        }

        // Показываем индикатор загрузки
        view?.showLoading(true)

        authService.register(email: email, password: password) { [weak self] result in
            DispatchQueue.main.async {
                self?.view?.showLoading(false)
                switch result {
                case .success(let response):
                    print("📝 [RegisterPresenter] register - успех, userId: \(response.userId)")
                    // Успешно зарегистрированы – можно перейти на главный экран
                    self?.view?.navigateToMain(userId: response.userId, email: response.email)
                case .failure(let error):
                    print("📝 [RegisterPresenter] register - ошибка: \(error)")
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

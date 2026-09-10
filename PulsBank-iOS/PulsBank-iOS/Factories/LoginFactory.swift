import UIKit

final class LoginFactory {
    private let authService: AuthService
    
    init(authService: AuthService) {
        self.authService = authService
    }
    
    func make() -> LoginViewController {
        print("🏭 [LoginFactory] make() - Создание LoginViewController")
        let presenter = LoginPresenter(authService: authService)
        return LoginViewController(presenter: presenter)
    }
}

import UIKit

final class RegisterFactory {
    private let authService: AuthService
    init(authService: AuthService) { self.authService = authService }
    
    func make() -> RegisterViewController {
        print("🏭 [RegisterFactory] make() - Создание RegisterViewController")
        let presenter = RegisterPresenter(authService: authService)
        return RegisterViewController(presenter: presenter)
    }
}

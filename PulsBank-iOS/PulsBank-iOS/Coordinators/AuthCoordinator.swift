import UIKit

final class AuthCoordinator: Coordinator {
    var childCoordinators: [Coordinator] = []
    let navigationController: UINavigationController
    
    private let authService: AuthService
    private let accountService: AccountService
    private let loginFactory: LoginFactory
    private let registerFactory: RegisterFactory
    private let onAuthSuccess: (Int) -> Void
    
    init(navigationController: UINavigationController,
         authService: AuthService,
         accountService: AccountService,
         loginFactory: LoginFactory,
         registerFactory: RegisterFactory,
         onAuthSuccess: @escaping (Int) -> Void) {
        print("🔐 [AuthCoordinator] init - Создание координатора авторизации")
        self.navigationController = navigationController
        self.authService = authService
        self.accountService = accountService
        self.loginFactory = loginFactory
        self.registerFactory = registerFactory
        self.onAuthSuccess = onAuthSuccess
    }
    
    func start() {
        print("🔐 [AuthCoordinator] start() - Запуск")
        let loginVC = loginFactory.make()
        print("🔐 [AuthCoordinator] LoginViewController установлен в стек")
        loginVC.onLoginSuccess = { [weak self] userId in
            print("🔐 [AuthCoordinator] onLoginSuccess - userId: \(userId)")
            self?.onAuthSuccess(userId)
        }
        loginVC.onRegisterTap = { [weak self] in
            print("🔐 [AuthCoordinator] onRegisterTap - Переход к регистрации")
            self?.showRegister()
        }
        navigationController.setViewControllers([loginVC], animated: false)
    }
    
    func showRegister() {
        print("🔐 [AuthCoordinator] showRegister() - Показываем RegisterViewController")
        let registerVC = registerFactory.make()
        registerVC.onRegisterSuccess = { [weak self] userId in
            print("🔐 [AuthCoordinator] onRegisterSuccess - userId: \(userId)")
            self?.onAuthSuccess(userId)
        }
        self.navigationController.pushViewController(registerVC, animated: false)
    }
    
    func finish() {
        childCoordinators.removeAll()
    }
    
    deinit {
        print("🗑️ [AuthCoordinator] deinit - координатор авторизации удалён из памяти")
    }
}

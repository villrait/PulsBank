import UIKit

protocol AuthCoordinatorFactory {
    func makeAuthCoordinator(
        navigationController: UINavigationController,
        onAuthSuccess: @escaping (Int) -> Void
    ) -> AuthCoordinator
}

final class AuthCoordinatorFactoryImpl: AuthCoordinatorFactory {
    private let authService: AuthService
    private let accountService: AccountService
    private let loginFactory: LoginFactory
    private let registerFactory: RegisterFactory

    init(authService: AuthService,
         accountService: AccountService,
         loginFactory: LoginFactory,
         registerFactory: RegisterFactory) {
        self.authService = authService
        self.accountService = accountService
        self.loginFactory = loginFactory
        self.registerFactory = registerFactory
    }

    func makeAuthCoordinator(navigationController: UINavigationController, onAuthSuccess: @escaping (Int) -> Void) -> AuthCoordinator {
        print("🏭 [AuthCoordinatorFactoryImpl] makeAuthCoordinator - создание AuthCoordinator")
        return AuthCoordinator(
            navigationController: navigationController,
            authService: authService,
            accountService: accountService,
            loginFactory: loginFactory,
            registerFactory: registerFactory,
            onAuthSuccess: onAuthSuccess
        )
    }
}

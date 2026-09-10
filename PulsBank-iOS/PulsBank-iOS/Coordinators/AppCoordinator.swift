import UIKit

final class AppCoordinator: Coordinator {
    var childCoordinators: [Coordinator] = []
    let navigationController: UINavigationController

    private let authCoordinatorFactory: AuthCoordinatorFactory
    private let mainCoordinatorFactory: MainTabBarCoordinatorFactory

    init(navigationController: UINavigationController,
         authCoordinatorFactory: AuthCoordinatorFactory,
         mainCoordinatorFactory: MainTabBarCoordinatorFactory) {
        print("🏛️ [AppCoordinator] init - Создание AppCoordinator")
        self.navigationController = navigationController
        self.authCoordinatorFactory = authCoordinatorFactory
        self.mainCoordinatorFactory = mainCoordinatorFactory
    }

    func start() {
        print("🏛️ [AppCoordinator] start() - Запуск")
        showAuth()
    }

    private func showAuth() {
        print("🏛️ [AppCoordinator] showAuth() - Показываем авторизацию")
        let authCoordinator = authCoordinatorFactory.makeAuthCoordinator(
            navigationController: navigationController,
            onAuthSuccess: { [weak self] userId in
                print("🏛️ [AppCoordinator] onAuthSuccess - userId: \(userId)")
                self?.showMainFlow(userId: userId)
            }
        )
        childCoordinators.append(authCoordinator)
        authCoordinator.start()
    }

    private func showMainFlow(userId: Int) {
        print("🏛️ [AppCoordinator] showMainFlow(userId:) - Переход к главному потоку, userId: \(userId)")
        print("🏛️ [AppCoordinator] Удаляем AuthCoordinator из childCoordinators")
        childCoordinators.removeAll { $0 is AuthCoordinator }
        print("🏛️ [AppCoordinator] childCoordinators теперь: \(childCoordinators)")
        let mainCoordinator = mainCoordinatorFactory.makeMainTabBarCoordinator(
            navigationController: navigationController,
            userId: userId
        )
        childCoordinators.append(mainCoordinator)
        mainCoordinator.start()
    }

    func finish() {
        childCoordinators.removeAll()
    }
}

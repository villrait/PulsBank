import UIKit

protocol MainTabBarCoordinatorFactory {
    func makeMainTabBarCoordinator(
        navigationController: UINavigationController,
        userId: Int
    ) -> MainTabBarCoordinator
}

final class MainTabBarCoordinatorFactoryImpl: MainTabBarCoordinatorFactory {
    private let homeFactory: HomeFactory
    
    init(homeFactory: HomeFactory) {
        self.homeFactory = homeFactory
    }
    
    func makeMainTabBarCoordinator(
        navigationController: UINavigationController,
        userId: Int
    ) -> MainTabBarCoordinator {
        print("🏭 [MainTabBarCoordinatorFactoryImpl] makeMainTabBarCoordinator - userId: \(userId)")
        return MainTabBarCoordinator(
            navigationController: navigationController,
            userId: userId,
            homeFactory: homeFactory
        )
    }
}

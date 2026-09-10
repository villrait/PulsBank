import UIKit

class HomeCoordinator: Coordinator {
    
    var childCoordinators: [Coordinator] = []
    let navigationController: UINavigationController
    private let factory: HomeFactory
    private let userId: Int
    
    init(navigationController: UINavigationController, factory: HomeFactory, userId: Int) {
        print("🏠 [HomeCoordinator] init - userId: \(userId)")
        self.navigationController = navigationController
        self.factory = factory
        self.userId = userId
    }
    
    func start() {
        print("🏠 [HomeCoordinator] start() - Запуск координатора главного экрана")
        let vc = factory.make(userId: userId)
        navigationController.viewControllers = [vc]
        print("🏠 [HomeCoordinator] HomeViewController установлен в стек")
    }
    
    func finish() {
        childCoordinators.removeAll()
    }
}

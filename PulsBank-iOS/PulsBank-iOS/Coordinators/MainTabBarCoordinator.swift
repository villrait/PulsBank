import UIKit

final class MainTabBarCoordinator: Coordinator {
    var childCoordinators: [Coordinator] = []
    let navigationController: UINavigationController   // станет не optional
    private let userId: Int
    private let homeFactory: HomeFactory

    private let tabBarController = UITabBarController()

    init(navigationController: UINavigationController, userId: Int, homeFactory: HomeFactory) {
        print("📱 [MainTabBarCoordinator] init - userId: \(userId)")
        self.navigationController = navigationController
        self.userId = userId
        self.homeFactory = homeFactory
    }

    func start() {
        print("📱 [MainTabBarCoordinator] start() - Настройка таббара")
        // 1. Создаём навигационный стек для Home
        let homeNav = UINavigationController()
        let homeCoordinator = HomeCoordinator(
            navigationController: homeNav,
            factory: homeFactory,
            userId: userId
        )
        homeCoordinator.start()
        childCoordinators.append(homeCoordinator)
        
        print("📱 [MainTabBarCoordinator] HomeCoordinator создан и запущен")

        // 2. Настраиваем вкладки (остальные – временные заглушки)
        homeNav.tabBarItem = UITabBarItem(title: "Главная", image: UIImage(systemName: "house"), tag: 0)

        let emptyVC2 = UIViewController()
        emptyVC2.view.backgroundColor = .lightGray
        emptyVC2.tabBarItem = UITabBarItem(title: "Вкладка 2", image: nil, tag: 1)

        let emptyVC3 = UIViewController()
        emptyVC3.view.backgroundColor = .gray
        emptyVC3.tabBarItem = UITabBarItem(title: "Вкладка 3", image: nil, tag: 2)

        let emptyVC4 = UIViewController()
        emptyVC4.view.backgroundColor = .darkGray
        emptyVC4.tabBarItem = UITabBarItem(title: "Вкладка 4", image: nil, tag: 3)

        let emptyVC5 = UIViewController()
        emptyVC5.view.backgroundColor = .black
        emptyVC5.tabBarItem = UITabBarItem(title: "Вкладка 5", image: nil, tag: 4)

        tabBarController.viewControllers = [homeNav, emptyVC2, emptyVC3, emptyVC4, emptyVC5]
        tabBarController.tabBar.tintColor = .systemBlue
        tabBarController.tabBar.backgroundColor = .white

        // 3. Устанавливаем таббар как единственный контроллер в навигационном стеке
        navigationController.setViewControllers([tabBarController], animated: false)
        print("📱 [MainTabBarCoordinator] Таббар установлен в navigationController")
        print("📱 [MainTabBarCoordinator] Старый стек навигации заменён на таббар")
    }

    func finish() {
        childCoordinators.removeAll()
    }
}

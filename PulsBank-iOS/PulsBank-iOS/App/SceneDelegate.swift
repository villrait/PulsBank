//
//  SceneDelegate.swift
//  PulsBank-iOS
//
//  Created by м on 31.03.2026.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    var appCoordinator: AppCoordinator?
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        
        print("📱 [SceneDelegate] Начало настройки сцены")
        
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: windowScene)
        print("📱 [SceneDelegate] Создано окно")
        
        let navController = UINavigationController()
        print("📱 [SceneDelegate] Создан UINavigationController")
        
        print("📱 [SceneDelegate] Вызываем DIContainer.main.setupDIContainer()")
        DIContainer.main.setupDIContainer()
        print("📱 [SceneDelegate] DIContainer настроен")
        
        print("📱 [SceneDelegate] Разрешаем фабрики координаторов из контейнера")
        let authCoordinatorFactory = DIContainer.main.resolve(AuthCoordinatorFactory.self)
        let mainCoordinatorFactory = DIContainer.main.resolve(MainTabBarCoordinatorFactory.self)
        print("📱 [SceneDelegate] Фабрики получены")
        
        print("📱 [SceneDelegate] Создаём AppCoordinator вручную")
        let appCoordinator = AppCoordinator(
            navigationController: navController,
            authCoordinatorFactory: authCoordinatorFactory,
            mainCoordinatorFactory: mainCoordinatorFactory
        )
        
        self.appCoordinator = appCoordinator
        print("📱 [SceneDelegate] Запускаем AppCoordinator.start()")
        appCoordinator.start()
        
        window?.rootViewController = navController
        window?.makeKeyAndVisible()
        print("📱 [SceneDelegate] Окно установлено и видимо")
    }
    
    // Остальные методы жизненного цикла (без изменений)
    func sceneDidDisconnect(_ scene: UIScene) {}
    func sceneDidBecomeActive(_ scene: UIScene) {}
    func sceneWillResignActive(_ scene: UIScene) {}
    func sceneWillEnterForeground(_ scene: UIScene) {}
    func sceneDidEnterBackground(_ scene: UIScene) {}
}

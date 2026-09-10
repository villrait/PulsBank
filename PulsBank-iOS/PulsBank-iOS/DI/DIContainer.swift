// DI/DIContainer.swift
import Foundation

/// Простой DI-контейнер (Inversion of Control Container).
/// Позволяет регистрировать зависимости и получать их в любой части приложения.
/// Реализован как синглтон для простоты использования.
final class DIContainer {
    
    // MARK: - Singleton
    
    /// Единственный экземпляр контейнера на всё приложение.
    static let main = DIContainer()
    
    // MARK: - Private Storage
    
    /// Словарь, где ключ — строковое имя типа (например, "AuthService"),
    /// а значение — фабрика, которая создаёт экземпляр этого типа.
    /// Фабрика принимает сам контейнер (чтобы разрешать вложенные зависимости) и возвращает Any.
    private var factories: [String: (DIContainer) -> Any] = [:]
    
    private init() {}  // Закрытый инициализатор — синглтон
    
    // MARK: - Public API: Регистрация
    
    /// Регистрирует зависимость в контейнере.
    /// - Parameters:
    ///   - type: Тип регистрируемого сервиса (например, `AuthService.self`).
    ///   - scope: Время жизни объекта (`.singleton` — один экземпляр на весь контейнер,
    ///            `.transient` — новый при каждом запросе).
    ///   - factory: Замыкание, которое создаёт экземпляр. Внутри можно вызывать
    ///              `container.resolve(...)` для получения других зависимостей.
    func register<Service>(
        _ type: Service.Type,
        scope: Scope = .transient,
        _ factory: @escaping (DIContainer) -> Service
    ) {
        let key = String(describing: type)
        switch scope {
        case .singleton:
            // Для синглтона создаём кэширующую обёртку.
            // При первом вызове создаём объект и сохраняем, при последующих возвращаем сохранённый.
            var cachedService: Service?
            factories[key] = { container in
                if let existing = cachedService {
                    return existing
                }
                let newService = factory(container)
                cachedService = newService
                return newService
            }
        case .transient:
            // Для transient просто сохраняем фабрику как есть — каждый вызов create новый объект.
            factories[key] = { container in factory(container) }
        }
        print("🏭 [DIContainer] register - Зарегистрирован \(type), scope: \(scope)")
    }
    
    // MARK: - Public API: Разрешение
    
    /// Получает зависимость зарегистрированного типа.
    /// - Parameter type: Тип запрашиваемого сервиса.
    /// - Returns: Экземпляр сервиса (согласно зарегистрированной фабрике и скоупу).
    func resolve<Service>(_ type: Service.Type) -> Service {
        print("🔍 [DIContainer] resolve - Запрошен тип: \(String(describing: type))")
        let key = String(describing: type)
        guard let factory = factories[key] else {
            fatalError("❌ \(type) не зарегистрирован в DIContainer. Проверьте вызов register.")
        }
        guard let service = factory(self) as? Service else {
            fatalError("❌ Не удалось привести тип для \(type). Возможно, фабрика возвращает не тот тип.")
        }
        print("✅ [DIContainer] resolve - Возвращён экземпляр: \(type)")
        return service
    }
    
    // MARK: - Composition Root (все регистрации приложения)
    
    /// Этот метод вызывается один раз при старте приложения (в SceneDelegate).
    /// Здесь регистрируются все сервисы, фабрики и прочие зависимости.
    func setupDIContainer() {
        print("🏭 [DIContainer] setupDIContainer() - Начало регистрации")
        
        // ----- 1. Сетевые сервисы (обычно синглтоны) -----
        
        // APIClient – общий клиент для всех запросов. Должен быть один на всё приложение.
        register(APIClient.self, scope: .singleton) { _ in
            APIClient.shared
        }
        
        // ----- 2. Бизнес-сервисы (транзиент или синглтон — зависит от задачи) -----
        
        // AuthService – отвечает за логин/регистрацию. Не хранит состояние, можно создавать новый каждый раз.
        // Зависит от APIClient – получаем его через container.resolve.
        register(AuthService.self) { container in
            let apiClient = container.resolve(APIClient.self)
            return AuthService(apiClient: apiClient)
        }
        
        // AccountService – загружает баланс. Тоже не хранит состояние, transient.
        register(AccountService.self) { container in
            let apiClient = container.resolve(APIClient.self)
            return AccountService(apiClient: apiClient)
        }
        
        // ----- 3. Фабрики экранов (создают ViewController) -----
        // Каждая фабрика нужна для создания конкретного экрана.
        // Фабрики получают необходимые сервисы через контейнер и передают их в презентеры/интеракторы.
        
        // LoginFactory – создаёт LoginViewController с его презентером.
        // Ей нужен AuthService, чтобы передать его в LoginPresenter.
        register(LoginFactory.self) { container in
            let authService = container.resolve(AuthService.self)
            return LoginFactory(authService: authService)
        }
        
        // RegisterFactory – аналогично для регистрации.
        register(RegisterFactory.self) { container in
            let authService = container.resolve(AuthService.self)
            return RegisterFactory(authService: authService)
        }
        
        // HomeFactory – создаёт главный экран с балансом.
        // Ей нужен AccountService для загрузки баланса.
        register(HomeFactory.self) { container in
            let accountService = container.resolve(AccountService.self)
            return HomeFactory(accountService: accountService)
        }
        
        // ----- 4. Фабрики координаторов (создают координаторы, которые управляют навигацией) -----
        
        // AuthCoordinatorFactory – создаёт координатор авторизации.
        // Он нуждается в AuthService (для логина/регистрации),
        // AccountService (возможно, для будущих нужд, хотя сейчас не используется – можно удалить),
        // а также в фабриках экранов LoginFactory и RegisterFactory.
        register(AuthCoordinatorFactory.self) { container in
            let authService = container.resolve(AuthService.self)
            let accountService = container.resolve(AccountService.self)   // ⚠️ мёртвая зависимость, можно убрать
            let loginFactory = container.resolve(LoginFactory.self)
            let registerFactory = container.resolve(RegisterFactory.self)
            return AuthCoordinatorFactoryImpl(
                authService: authService,
                accountService: accountService,   // если не используется – удалите параметр из фабрики и координатора
                loginFactory: loginFactory,
                registerFactory: registerFactory
            )
        }
        
        // MainTabBarCoordinatorFactory – создаёт координатор главного таббара.
        // Ему нужна HomeFactory для создания экрана первой вкладки.
        register(MainTabBarCoordinatorFactory.self) { container in
            let homeFactory = container.resolve(HomeFactory.self)
            return MainTabBarCoordinatorFactoryImpl(homeFactory: homeFactory)
        }
        
        // ⚠️ AppCoordinator НЕ регистрируем, потому что он требует navigationController,
        // который мы передаём только в момент создания (в SceneDelegate).
        // Это нормально – корневой координатор создаётся вручную.
        print("🏭 [DIContainer] setupDIContainer() - Регистрация завершена")
    }
}

// MARK: - Вспомогательные типы

/// Стратегия управления временем жизни зависимости.
enum Scope {
    /// Один экземпляр на весь контейнер (создаётся при первом запросе и живёт пока жив контейнер).
    case singleton
    /// Новый экземпляр при каждом запросе (создаётся каждый раз при вызове resolve).
    case transient
}

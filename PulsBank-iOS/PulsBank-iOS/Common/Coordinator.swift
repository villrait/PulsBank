import UIKit
/// Базовый протокол для всех координаторов приложения.
protocol Coordinator: AnyObject {
    /// Дочерние координаторы (для управления иерархией).
    var childCoordinators: [Coordinator] { get set }
    /// Навигационный контроллер, которым управляет координатор.
    var navigationController: UINavigationController { get }
    /// Запуск координатора (начало работы).
    func start()
    /// Опционально: завершение координатора (удаление из иерархии).
    func finish()
}

extension Coordinator {
    func finish() {
        print("🧹 [Coordinator] finish() - завершение \(Self.self)")
        childCoordinators.removeAll()
    }
}

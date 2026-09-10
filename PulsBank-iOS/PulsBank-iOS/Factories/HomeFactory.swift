import UIKit

final class HomeFactory {
    private let accountService: AccountService
    
    init(accountService: AccountService) {
        self.accountService = accountService
    }
    
    func make(userId: Int) -> HomeViewController {
        print("🏭 [HomeFactory] make(userId:) - Создание HomeViewController для userId: \(userId)")
        let viewController = HomeViewController()
        let interactor = HomeInteractor(accountService: accountService, userId: userId)
        let presenter = HomePresenter()
        viewController.interactor = interactor
        interactor.presenter = presenter
        presenter.view = viewController
        print("🏭 [HomeFactory] HomeViewController собран с интерактором и презентером")
        return viewController
    }
}

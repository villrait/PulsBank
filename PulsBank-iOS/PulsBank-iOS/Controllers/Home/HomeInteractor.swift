protocol HomeBusinessLogic {
    func loadBalance()
}

class HomeInteractor: HomeBusinessLogic {
    var presenter: HomePresentationLogic?
    private let accountService: AccountServiceProtocol
    private let userId: Int
    
    init(accountService: AccountServiceProtocol, userId: Int) {
        print("🏠 [HomeInteractor] init - userId: \(userId)")
        self.accountService = accountService
        self.userId = userId
    }
    
    func loadBalance() {
        print("🏠 [HomeInteractor] loadBalance() - загрузка баланса")
        accountService.getBalance(userId: userId) { [weak self] result in
            switch result {
            case .success(let balance):
                let response = Home.Response(balance: balance)
                self?.presenter?.presentBalance(response: response)
            case .failure(let error):
                print("Ошибка загрузки баланса: \(error)")
                // Можно показать алерт
            }
        }
    }
}

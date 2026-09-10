protocol HomePresentationLogic {
    func presentBalance(response: Home.Response)
}

class HomePresenter: HomePresentationLogic {
    weak var view: HomeDisplayLogic?
    
    func presentBalance(response: Home.Response) {
        print("🏠 [HomePresenter] presentBalance - баланс: \(response.balance)")
        let viewModel = Home.ViewModel(balance: "\(response.balance)")
        view?.displayBalance(viewModel: viewModel)
    }
}

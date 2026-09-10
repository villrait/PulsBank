import UIKit

protocol HomeDisplayLogic: AnyObject {
    func displayBalance(viewModel: Home.ViewModel)
}

class HomeViewController: UIViewController, HomeDisplayLogic {
    var interactor: HomeBusinessLogic?
    
    private let balanceLabel = UILabel()
    
    override func viewDidLoad() {
        print("🏠 [HomeViewController] viewDidLoad - загрузка главного экрана")
        super.viewDidLoad()
        setupUI()
        interactor?.loadBalance()
    }
    
    private func setupUI() {
        view.backgroundColor = .white
        balanceLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(balanceLabel)
        NSLayoutConstraint.activate([
            balanceLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            balanceLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    func displayBalance(viewModel: Home.ViewModel) {
        print("🏠 [HomeViewController] displayBalance - отображаем баланс: \(viewModel.balance)")
        balanceLabel.text = "Баланс: \(viewModel.balance) ₽"
    }
}

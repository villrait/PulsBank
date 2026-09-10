// Протокол для связи Presenter → View
protocol RegisterViewProtocol: AnyObject {
    func showLoading(_ show: Bool)
    func showError(message: String)
    func navigateToMain(userId: Int, email: String)
}

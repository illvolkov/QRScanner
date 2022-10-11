//
//  WebPresenter.swift
//  QRScanner
//
//  Created by Ilya Volkov on 30.09.2022.
//

import WebKit

class WebPresenter {
    
    //MARK: - References
    
    weak var delegate: WebPresenterDelegate?
    
    //MARK: - Functions
    
    func load(webView: WKWebView, with url: String) {
        guard let url = URL(string: url) else { return }
        let request = URLRequest(url: url)
        webView.load(request)
    }
    
    func handleClose() {
        delegate?.dismission()
    }
    
    func handleForwardTap() {
        delegate?.moveForwardPage()
    }
    
    func handleBackwardTap() {
        delegate?.moveBackwardPage()
    }
    
    func handleReloadTap() {
        delegate?.reloadPage()
    }
    
    func handleShareTap() {
        delegate?.sharePage()
    }
    
    func showLoadingErrorAlert(with error: Error) {
        let alert = UIAlertController(title: Strings.loadingErrorAlertTitle, message: error.localizedDescription, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: Strings.loadingErrorAlertButtonTitle, style: .cancel) { _ in
            self.handleClose()
        })
        delegate?.presentError(alert: alert)
    }
    
    func showResultOfSaveAlert(title: String) {
        let alert = UIAlertController(title: title, message: nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: Strings.resultOfSaveAlertButtonTitle, style: .cancel))
        delegate?.presentSaveResult(alert: alert)
    }
}

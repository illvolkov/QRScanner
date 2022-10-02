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
        if let delegate {
            delegate.dismission()
        }
    }
    
    func handleForwardTap() {
        if let delegate {
            delegate.moveForwardPage()
        }
    }
    
    func handleBackwardTap() {
        if let delegate {
            delegate.moveBackwardPage()
        }
    }
    
    func handleReloadTap() {
        if let delegate {
            delegate.reloadPage()
        }
    }
    
    func handleShareTap() {
        if let delegate {
            delegate.sharePage()
        }
    }
    
    func showLoadingErrorAlert(with error: Error) {
        let alert = UIAlertController(title: "Loading failed", message: error.localizedDescription, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel) { _ in
            self.handleClose()
        })
        if let delegate {
            delegate.presentError(alert: alert)
        }
    }
    
    func showResultAlert(title: String) {
        let alert = UIAlertController(title: title, message: nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .cancel))
        if let delegate {
            delegate.presentSaveResult(alert: alert)
        }
    }
}

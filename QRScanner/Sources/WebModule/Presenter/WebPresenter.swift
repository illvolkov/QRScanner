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
}

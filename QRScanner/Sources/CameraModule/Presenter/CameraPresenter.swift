//
//  CameraPresenter.swift
//  QRScanner
//
//  Created by Ilya Volkov on 29.09.2022.
//

import UIKit

class CameraPresenter {
    
    //MARK: - References
    
    weak var delegate: CameraPresenterDelegate?
    var cameraManager: CameraManagerProtocol?
    
    //MARK: - Functions
    
    func configureCamera(on view: UIView, delegate: UIViewController) {
        if let cameraManager {
            cameraManager.setupVideoPreviewLayer(with: view, delegate: delegate)
        }
    }
    
    func handleFlashButtonEnabledState() {
        if let cameraManager {
            cameraManager.switchFlash(torchMode: .on)
        }
    }
    
    func handleFlashButtonDisabledState() {
        if let cameraManager {
            cameraManager.switchFlash(torchMode: .off)
        }
    }
    
    func showWebController(with qrUrl: String) {
        let webController = ModuleBuilder.buildWebModule(with: qrUrl)
        if let delegate {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                delegate.presenting(webController: webController)
            }
        }
    }
}

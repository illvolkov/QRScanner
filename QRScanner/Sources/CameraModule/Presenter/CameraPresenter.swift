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
        cameraManager?.setupVideoPreviewLayer(with: view, delegate: delegate)
    }
    
    func handleFlashButtonEnabledState() {
        cameraManager?.switchFlash(torchMode: .on)
    }
    
    func handleFlashButtonDisabledState() {
        cameraManager?.switchFlash(torchMode: .off)
    }
    
    func showWebController(with qrUrl: String) {
        let webController = ModuleBuilder.buildWebModule(with: qrUrl)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) {
            self.delegate?.presenting(webController: webController)
        }
    }
}

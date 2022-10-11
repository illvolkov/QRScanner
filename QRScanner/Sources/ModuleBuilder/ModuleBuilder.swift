//
//  ModuleBuilder.swift
//  QRScanner
//
//  Created by Ilya Volkov on 29.09.2022.
//

import UIKit

struct ModuleBuilder {
    static func buildCameraModule() -> UIViewController {
        let view = CameraController()
        let presenter = CameraPresenter()
        let cameraManager = CameraManager()
        
        view.presenter = presenter
        presenter.delegate = view
        presenter.cameraManager = cameraManager
        return view
    }
    
    static func buildWebModule(with qrUrl: String) -> UIViewController {
        let view = WebController(qrUrl: qrUrl)
        let presenter = WebPresenter()
        
        view.presenter = presenter
        presenter.delegate = view
        return UINavigationController(rootViewController: view)
    }
}

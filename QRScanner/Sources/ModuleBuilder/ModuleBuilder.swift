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
}

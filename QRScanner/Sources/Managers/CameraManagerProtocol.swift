//
//  CameraManagerProtocol.swift
//  QRScanner
//
//  Created by Ilya Volkov on 30.09.2022.
//

import AVFoundation
import UIKit

protocol CameraManagerProtocol {
    func setupVideoPreviewLayer(with view: UIView, delegate: UIViewController)
    func switchFlash(torchMode: AVCaptureDevice.TorchMode)
}

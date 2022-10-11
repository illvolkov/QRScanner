//
//  CameraManager.swift
//  QRScanner
//
//  Created by Ilya Volkov on 30.09.2022.
//

import AVFoundation
import UIKit

class CameraManager: CameraManagerProtocol {
            
    private var captureSession = AVCaptureSession()
    private var videoPreviewLayer = AVCaptureVideoPreviewLayer()
    private var captureDevice: AVCaptureDevice?
    
    func setupVideoPreviewLayer(with view: UIView, delegate: UIViewController) {
        
        captureDevice = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back)
        
        do {
            if let captureDevice {
                let input = try AVCaptureDeviceInput(device: captureDevice)
                captureSession.addInput(input)
            }
        } catch {
            print(error.localizedDescription)
            return
        }
        
        let captureMetaDataOutput = AVCaptureMetadataOutput()
        captureSession.addOutput(captureMetaDataOutput)
        
        if let delegate = delegate as? AVCaptureMetadataOutputObjectsDelegate {
            captureMetaDataOutput.setMetadataObjectsDelegate(delegate, queue: DispatchQueue.main)
        }
        captureMetaDataOutput.metadataObjectTypes = [AVMetadataObject.ObjectType.qr]
        
        videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        videoPreviewLayer.videoGravity = .resizeAspectFill
        
        view.layer.addSublayer(videoPreviewLayer)
        videoPreviewLayer.frame = view.bounds
        
        let captureSessionQueue = DispatchQueue(label: Strings.captureSessionQueueLabel)
        
        captureSessionQueue.async {
            self.captureSession.startRunning()
        }
    }
    
    func switchFlash(torchMode: AVCaptureDevice.TorchMode) {
        if let captureDevice {
            guard captureDevice.isTorchAvailable else { return }
            
            do {
                try captureDevice.lockForConfiguration()
                captureDevice.torchMode = torchMode
            } catch {
                print(error.localizedDescription)
            }
            
            captureDevice.unlockForConfiguration()
        }
    }
}

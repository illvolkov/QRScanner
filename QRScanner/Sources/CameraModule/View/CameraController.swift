//
//  ViewController.swift
//  QRScanner
//
//  Created by Ilya Volkov on 29.09.2022.
//

import UIKit
import AVFoundation

class CameraController: UIViewController {
    
    //MARK: - References
    
    var presenter: CameraPresenter?
    
    //MARK: - Private properties
        
    private var isFlashOn: Bool = false {
        didSet {
            if isFlashOn {
                setImageForFlashButton(with: "bolt.fill")
                if let presenter {
                    presenter.handleFlashButtonEnabledState()
                }
            } else {
                setImageForFlashButton(with: "bolt.slash.fill")
                if let presenter {
                    presenter.handleFlashButtonDisabledState()
                }
            }
        }
    }
    
    //MARK: - Views
    
    private let previewView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }()
    
    private lazy var flashButton: UIButton = {
        let button = UIButton()
        button.tintColor = .white
        let imageConfiguration = UIImage.SymbolConfiguration(pointSize: view.frame.width * 0.07)
        button.setImage(UIImage(systemName: "bolt.slash.fill")?.withConfiguration(imageConfiguration), for: .normal)
        button.addTarget(self, action: #selector(flashButtonDidTap), for: .touchUpInside)
        return button
    }()
    
    private var qrFrameImage: UIImageView = {
        let qrFrame = UIImageView()
        let configuration = UIImage.SymbolConfiguration(weight: .ultraLight)
        qrFrame.image = UIImage(systemName: "viewfinder")?.withConfiguration(configuration)
        qrFrame.tintColor = .white
        return qrFrame
    }()
    
    //MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let presenter {
            presenter.delegate = self
            presenter.configureCamera(on: view, delegate: self)
        }
        
        setupHierarchy()
        setupLayout()
    }
    
    //MARK: - Settings
    
    private func setupHierarchy() {
        view.addSubview(previewView)
        view.addSubview(flashButton)
        view.addSubview(qrFrameImage)
    }
    
    private func setupLayout() {
        previewView.translatesAutoresizingMaskIntoConstraints = false
        previewView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        previewView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        previewView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        previewView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
                
        flashButton.translatesAutoresizingMaskIntoConstraints = false
        flashButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20).isActive = true
        flashButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        
        qrFrameImage.translatesAutoresizingMaskIntoConstraints = false
        qrFrameImage.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        qrFrameImage.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        qrFrameImage.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8).isActive = true
        qrFrameImage.heightAnchor.constraint(equalTo: qrFrameImage.widthAnchor).isActive = true
    }
    
    //MARK: - Functions
    
    private func setImageForFlashButton(with name: String) {
        let imageConfiguration = UIImage.SymbolConfiguration(pointSize: view.frame.width * 0.07)
        flashButton.setImage(UIImage(systemName: name)?.withConfiguration(imageConfiguration), for: .normal)
    }
    
    private func setSuccessfulQRFrameImageColor() {
        qrFrameImage.tintColor = .green
    }
    
    private func setDefaultQRFrameImageColor() {
        qrFrameImage.tintColor = .white
    }
    
    //MARK: - Actions
    
    @objc private func flashButtonDidTap() {
        isFlashOn.toggle()
    }
}

//MARK: - CameraPresenterDelegate methods

extension CameraController: CameraPresenterDelegate {}

//MARK: - AVCaptureMetadataOutputObjectsDelegate methods

extension CameraController: AVCaptureMetadataOutputObjectsDelegate {
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        guard metadataObjects.count > 0 else { return }
        
        if let object = metadataObjects.first as? AVMetadataMachineReadableCodeObject, object.type == .qr {
            setSuccessfulQRFrameImageColor()
        }
    }
}

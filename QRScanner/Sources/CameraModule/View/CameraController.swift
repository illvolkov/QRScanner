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
                setImageForFlashButton(with: Images.flashOnButtonImage)
                if let presenter {
                    presenter.handleFlashButtonEnabledState()
                }
            } else {
                setImageForFlashButton(with: Images.flashOffButtonImage)
                if let presenter {
                    presenter.handleFlashButtonDisabledState()
                }
            }
        }
    }
    
    //MARK: - Views
    
    private lazy var flashButton: UIButton = {
        let button = UIButton()
        button.tintColor = .white
        let imageConfiguration = UIImage.SymbolConfiguration(pointSize: view.frame.width * Sizes.flashButtonMultipliedImageSize)
        button.setImage(UIImage(systemName: Images.flashOffButtonImage)?.withConfiguration(imageConfiguration), for: .normal)
        button.addTarget(self, action: #selector(flashButtonDidTap), for: .touchUpInside)
        return button
    }()
    
    private var qrFrameImage: UIImageView = {
        let qrFrame = UIImageView()
        let configuration = UIImage.SymbolConfiguration(weight: .ultraLight)
        qrFrame.image = UIImage(systemName: Images.qrFrameImage)?.withConfiguration(configuration)
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
        view.addSubview(flashButton)
        view.addSubview(qrFrameImage)
    }
    
    private func setupLayout() {
        flashButton.translatesAutoresizingMaskIntoConstraints = false
        flashButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: Offsets.offset20).isActive = true
        flashButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: Offsets.offset20).isActive = true
        
        qrFrameImage.translatesAutoresizingMaskIntoConstraints = false
        qrFrameImage.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        qrFrameImage.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        qrFrameImage.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: Sizes.qrFrameImageMultipliedWidthSize).isActive = true
        qrFrameImage.heightAnchor.constraint(equalTo: qrFrameImage.widthAnchor).isActive = true
    }
    
    //MARK: - Functions
    
    private func setImageForFlashButton(with name: String) {
        let imageConfiguration = UIImage.SymbolConfiguration(pointSize: view.frame.width * Sizes.flashButtonMultipliedImageSize)
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

extension CameraController: CameraPresenterDelegate {
    func presenting(webController: UIViewController) {
        webController.modalPresentationStyle = .fullScreen
        present(webController, animated: true)
        setDefaultQRFrameImageColor()
    }
}

//MARK: - AVCaptureMetadataOutputObjectsDelegate methods

extension CameraController: AVCaptureMetadataOutputObjectsDelegate {
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        guard metadataObjects.count > 0 else { return }
        
        if let object = metadataObjects.first as? AVMetadataMachineReadableCodeObject, object.type == .qr {
            setSuccessfulQRFrameImageColor()
            if let presenter {
                presenter.showWebController(with: object.stringValue ?? "")
            }
        }
    }
}


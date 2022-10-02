//
//  Constants.swift
//  QRScanner
//
//  Created by Ilya Volkov on 02.10.2022.
//

import UIKit

enum Offsets {
    //MARK: - WebController
    static let offset10: CGFloat = 10
    static let reloadButtonLeftOffset25: CGFloat = 25
    static let offset15: CGFloat = 15
    static let offset20: CGFloat = 20
}

enum Sizes {
    //MARK: - WebController
    static let titleLabelFontSize: CGFloat = 0.05
    static let multipliedWidthHeight0_6: CGFloat = 0.6
    static let buttonImageMultipliedSize0_05: CGFloat = 0.05
    static let webNavigationPanelMultipliedHeight: CGFloat = 0.2
    
    //MARK: - CameraController
    static let flashButtonMultipliedImageSize: CGFloat = 0.07
    static let qrFrameImageMultipliedWidthSize: CGFloat = 0.8
}

enum Strings {
    //MARK: - CameraManager
    static let captureSessionQueueLabel: String = "captureSessionQueue"
    
    //MARK: - WebPresenter
    static let loadingErrorAlertTitle: String = "Loading failed"
    static let loadingErrorAlertButtonTitle: String = "Cancel"
    static let resultOfSaveAlertButtonTitle: String = "OK"
    
    //MARK: - WebController
    static let fatalErrorMessage: String = "init(coder:) has not been implemented"
    static let webSiteTitle: String = "document.title"
    static let untitledTitlelabel: String = "Untitled"
    static let pdfExtension: String = ".pdf"
    static let saveToFileActivityType: String = "com.apple.DocumentManagerUICore.SaveToFiles"
    static let successResultOfSaveAlertTitle: String = "File saved"
    static let failedResultOfSaveAlertTitle: String = "Saiving failed"
}

enum Images {
    //MARK: - WebController
    static let closeButtonImage: String = "xmark.circle"
    static let forwardButtonImage: String = "arrowshape.turn.up.right"
    static let backwardButtonImage: String = "arrowshape.turn.up.left"
    static let reloadButtonImage: String = "arrow.counterclockwise"
    static let shareButtonImage: String = "square.and.arrow.up"
    
    //MARK: - CameraController
    static let flashOnButtonImage: String = "bolt.fill"
    static let flashOffButtonImage: String = "bolt.slash.fill"
    static let qrFrameImage: String = "viewfinder"
}

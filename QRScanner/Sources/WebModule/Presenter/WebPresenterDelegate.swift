//
//  WebPresenterDelegate.swift
//  QRScanner
//
//  Created by Ilya Volkov on 30.09.2022.
//

import UIKit

protocol WebPresenterDelegate: AnyObject {
    func dismission()
    func moveForwardPage()
    func moveBackwardPage()
    func reloadPage()
    func sharePage()
    func presentError(alert: UIAlertController)
    func presentSaveResult(alert: UIAlertController)
}

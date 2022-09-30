//
//  WebPresenterDelegate.swift
//  QRScanner
//
//  Created by Ilya Volkov on 30.09.2022.
//

protocol WebPresenterDelegate: AnyObject {
    func dismission()
    func moveForwardPage()
    func moveBackwardPage()
    func reloadPage()
    func sharePage()
}

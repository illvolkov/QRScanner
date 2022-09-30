//
//  WebController.swift
//  QRScanner
//
//  Created by Ilya Volkov on 30.09.2022.
//

import UIKit
import WebKit

class WebController: UIViewController {
    
    //MARK: - References
    
    var presenter: WebPresenter?
    
    //MARK: - Properties
    
    var qrUrl: String
    
    //MARK: - Initial
    
    init(qrUrl: String) {
        self.qrUrl = qrUrl
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Views
    
    private lazy var webView: WKWebView = {
        let webView = WKWebView()
        webView.navigationDelegate = self
        webView.allowsBackForwardNavigationGestures = true
        
        return webView
    }()
        
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = .systemFont(ofSize: view.frame.width * 0.05, weight: .bold)
        label.numberOfLines = 1
        label.frame = CGRect(x: 0,
                             y: 0,
                             width: view.frame.width * 0.6,
                             height: view.frame.width * 0.05)
        return label
    }()
    
    private lazy var closeButton: UIButton = {
        let button = UIButton(type: .system)
        let imageConfiguration = UIImage.SymbolConfiguration(pointSize: view.frame.width * 0.05)
        button.setImage(UIImage(systemName: "xmark.circle")?.withConfiguration(imageConfiguration), for: .normal)
        button.tintColor = .white
        button.addTarget(self, action: #selector(closeButtonDidTap), for: .touchUpInside)
        return button
    }()
    
    private lazy var webNavigationPanel: UIView = {
        let view = UIView()
        view.backgroundColor = .black
        return view
    }()
    
    private lazy var forwardButton = createButtonForBottomPanel(with: "arrowshape.turn.up.right", action: #selector(forwardButtonDidTap))
    private lazy var backwardButton = createButtonForBottomPanel(with: "arrowshape.turn.up.left", action: #selector(backwardButtonDidTap))
    private lazy var reloadButton = createButtonForBottomPanel(with: "arrow.counterclockwise", action: #selector(reloadButtonDidTap))
    private lazy var shareButton = createButtonForBottomPanel(with: "square.and.arrow.up", action: #selector(shareButtonDidTap))
    
    private lazy var activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView()
        indicator.hidesWhenStopped = true
        return indicator
    }()
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let presenter {
            presenter.delegate = self
            presenter.load(webView: webView, with: qrUrl)
        }
        
        setupHierarchy()
        setupLayout()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setupNavigationBar()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        activityIndicator.startAnimating()
    }
    
    //MARK: - Settings
    
    private func setupHierarchy() {
        view.addSubview(webView)
        view.addSubview(webNavigationPanel)
        webNavigationPanel.addSubview(activityIndicator)
        webNavigationPanel.addSubview(forwardButton)
        webNavigationPanel.addSubview(backwardButton)
        webNavigationPanel.addSubview(reloadButton)
        webNavigationPanel.addSubview(shareButton)
    }
    
    private func setupLayout() {
        webView.translatesAutoresizingMaskIntoConstraints = false
        webView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        webView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        webView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        webView.bottomAnchor.constraint(equalTo: webNavigationPanel.topAnchor).isActive = true
        
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.centerYAnchor.constraint(equalTo: webNavigationPanel.centerYAnchor, constant: -10).isActive = true
        activityIndicator.centerXAnchor.constraint(equalTo: webNavigationPanel.centerXAnchor).isActive = true
        
        webNavigationPanel.translatesAutoresizingMaskIntoConstraints = false
        webNavigationPanel.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        webNavigationPanel.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        webNavigationPanel.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        webNavigationPanel.heightAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.2).isActive = true
        
        backwardButton.translatesAutoresizingMaskIntoConstraints = false
        backwardButton.centerYAnchor.constraint(equalTo: webNavigationPanel.centerYAnchor, constant: -10).isActive = true
        backwardButton.leftAnchor.constraint(equalTo: webNavigationPanel.leftAnchor, constant: 15).isActive = true
        
        forwardButton.translatesAutoresizingMaskIntoConstraints = false
        forwardButton.centerYAnchor.constraint(equalTo: webNavigationPanel.centerYAnchor, constant: -10).isActive = true
        forwardButton.leftAnchor.constraint(equalTo: backwardButton.rightAnchor, constant: 15).isActive = true
        
        shareButton.translatesAutoresizingMaskIntoConstraints = false
        shareButton.centerYAnchor.constraint(equalTo: webNavigationPanel.centerYAnchor, constant: -10).isActive = true
        shareButton.rightAnchor.constraint(equalTo: webNavigationPanel.rightAnchor, constant: -15).isActive = true
        
        reloadButton.translatesAutoresizingMaskIntoConstraints = false
        reloadButton.centerYAnchor.constraint(equalTo: webNavigationPanel.centerYAnchor, constant: -10).isActive = true
        reloadButton.rightAnchor.constraint(equalTo: shareButton.leftAnchor, constant: -25).isActive = true
    }
    
    private func setupNavigationBar() {
        navigationItem.titleView = titleLabel
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: closeButton)
        
        let appearance = UINavigationBarAppearance()
        appearance.backgroundColor = .black
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
    }
    
    //MARK: - Functions
    
    private func setTitle() {
        webView.evaluateJavaScript("document.title") { result, error in
            if let error = error {
                print("Error: \(error.localizedDescription)")
                self.titleLabel.text = "Untitled"
                return
            }

            if let result = result as? String {
                self.titleLabel.text = result
            }
        }
    }
    
    private func createButtonForBottomPanel(with image: String, action: Selector) -> UIButton {
        let button = UIButton(type: .system)
        let imageConfiguration = UIImage.SymbolConfiguration(pointSize: view.frame.width * 0.05)
        button.setImage(UIImage(systemName: image)?.withConfiguration(imageConfiguration), for: .normal)
        button.tintColor = .white
        button.addTarget(self, action: action, for: .touchUpInside)
        return button
    }
    
    //MARK: - Actions
    
    @objc private func closeButtonDidTap() {
        if let presenter {
            presenter.handleClose()
        }
    }
    
    @objc private func forwardButtonDidTap() {
        if let presenter {
            presenter.handleForwardTap()
        }
    }
    
    @objc private func backwardButtonDidTap() {
        if let presenter {
            presenter.handleBackwardTap()
        }
    }
    
    @objc private func reloadButtonDidTap() {
        if let presenter {
            presenter.handleReloadTap()
        }
    }
    
    @objc private func shareButtonDidTap() {
        if let presenter {
            presenter.handleShareTap()
        }
    }
}

//MARK: - WebPresenterDelegate methods

extension WebController: WebPresenterDelegate {
    func moveForwardPage() {
        if webView.canGoForward {
            webView.goForward()
        }
    }
    
    func moveBackwardPage() {
        if webView.canGoBack {
            webView.goBack()
        }
    }
    
    func reloadPage() {
        webView.reload()
    }
    
    func sharePage() {
        print("share")
    }
    
    func dismission() {
        dismiss(animated: true)
    }
}

extension WebController: WKNavigationDelegate {
    
    func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
        activityIndicator.startAnimating()
    }

    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        activityIndicator.stopAnimating()
        setTitle()
        forwardButton.isEnabled = webView.canGoForward
        backwardButton.isEnabled = webView.canGoBack
    }
    
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        activityIndicator.stopAnimating()
        
        let alert = UIAlertController(title: "Loading error", message: error.localizedDescription, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel) { _ in
            self.presenter?.handleClose()
        })
        present(alert, animated: true)
    }
}

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
        fatalError(Strings.fatalErrorMessage)
    }
    
    //MARK: - Views
    
    private lazy var webView: WKWebView = {
        let webView = WKWebView()
        webView.navigationDelegate = self
        return webView
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = .systemFont(ofSize: view.frame.width * Sizes.titleLabelFontSize, weight: .bold)
        label.textAlignment = .center
        label.numberOfLines = 1
        label.frame = CGRect(x: 0,
                             y: 0,
                             width: view.frame.width * Sizes.multipliedWidthHeight0_6,
                             height: view.frame.width * Sizes.multipliedWidthHeight0_6)
        return label
    }()
    
    private lazy var closeButton: UIButton = {
        let button = UIButton(type: .system)
        let imageConfiguration = UIImage.SymbolConfiguration(pointSize: view.frame.width * Sizes.buttonImageMultipliedSize0_05)
        button.setImage(UIImage(systemName: Images.closeButtonImage)?.withConfiguration(imageConfiguration), for: .normal)
        button.tintColor = .white
        button.addTarget(self, action: #selector(closeButtonDidTap), for: .touchUpInside)
        return button
    }()
    
    private lazy var webNavigationPanel: UIView = {
        let view = UIView()
        view.backgroundColor = .black
        return view
    }()
    
    private lazy var forwardButton = createButtonForBottomPanel(with: Images.forwardButtonImage, action: #selector(forwardButtonDidTap))
    private lazy var backwardButton = createButtonForBottomPanel(with: Images.backwardButtonImage, action: #selector(backwardButtonDidTap))
    private lazy var reloadButton = createButtonForBottomPanel(with: Images.reloadButtonImage, action: #selector(reloadButtonDidTap))
    private lazy var shareButton = createButtonForBottomPanel(with: Images.shareButtonImage, action: #selector(shareButtonDidTap))
    
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
        webView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        webView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        webView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        webView.bottomAnchor.constraint(equalTo: webNavigationPanel.topAnchor).isActive = true
        
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.centerYAnchor.constraint(equalTo: webNavigationPanel.centerYAnchor, constant: -Offsets.offset10).isActive = true
        activityIndicator.centerXAnchor.constraint(equalTo: webNavigationPanel.centerXAnchor).isActive = true
        
        webNavigationPanel.translatesAutoresizingMaskIntoConstraints = false
        webNavigationPanel.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        webNavigationPanel.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        webNavigationPanel.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        webNavigationPanel.heightAnchor.constraint(equalTo: view.widthAnchor, multiplier: Sizes.webNavigationPanelMultipliedHeight).isActive = true
        
        backwardButton.translatesAutoresizingMaskIntoConstraints = false
        backwardButton.centerYAnchor.constraint(equalTo: webNavigationPanel.centerYAnchor, constant: -Offsets.offset10).isActive = true
        backwardButton.leftAnchor.constraint(equalTo: webNavigationPanel.leftAnchor, constant: Offsets.offset15).isActive = true
        
        forwardButton.translatesAutoresizingMaskIntoConstraints = false
        forwardButton.centerYAnchor.constraint(equalTo: webNavigationPanel.centerYAnchor, constant: -Offsets.offset10).isActive = true
        forwardButton.leftAnchor.constraint(equalTo: backwardButton.rightAnchor, constant: Offsets.offset15).isActive = true
        
        shareButton.translatesAutoresizingMaskIntoConstraints = false
        shareButton.centerYAnchor.constraint(equalTo: webNavigationPanel.centerYAnchor, constant: -Offsets.offset10).isActive = true
        shareButton.rightAnchor.constraint(equalTo: webNavigationPanel.rightAnchor, constant: -Offsets.offset15).isActive = true
        
        reloadButton.translatesAutoresizingMaskIntoConstraints = false
        reloadButton.centerYAnchor.constraint(equalTo: webNavigationPanel.centerYAnchor, constant: -Offsets.offset10).isActive = true
        reloadButton.rightAnchor.constraint(equalTo: shareButton.leftAnchor, constant: -Offsets.reloadButtonLeftOffset25).isActive = true
    }
    
    private func setupNavigationBar() {
        navigationItem.titleView = titleLabel
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: closeButton)
        
        let appearance = UINavigationBarAppearance()
        appearance.backgroundColor = .black
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
    }
    
    //MARK: - Functions
    
    // webview title is taken and set to the title label
    private func setTitle() {
        webView.evaluateJavaScript(Strings.webSiteTitle) { result, error in
            if error != nil {
                self.titleLabel.text = Strings.untitledTitlelabel
                return
            }
            
            if let result = result as? String {
                self.titleLabel.text = result
            }
        }
    }
    
    private func createButtonForBottomPanel(with image: String, action: Selector) -> UIButton {
        let button = UIButton(type: .system)
        let imageConfiguration = UIImage.SymbolConfiguration(pointSize: view.frame.width * Sizes.buttonImageMultipliedSize0_05)
        button.setImage(UIImage(systemName: image)?.withConfiguration(imageConfiguration), for: .normal)
        button.tintColor = .white
        button.addTarget(self, action: action, for: .touchUpInside)
        return button
    }
    
    private func updateInteractionUI() {
        activityIndicator.stopAnimating()
        setTitle()
        forwardButton.isEnabled = webView.canGoForward
        backwardButton.isEnabled = webView.canGoBack
    }
    
    // checking if the url is the path to the pdf file so that it can be saved
    private func checkActivityItemTypePdf(with url: URL) -> [Any] {
        var activityItems = [Any]()
        if url.lastPathComponent.contains(Strings.pdfExtension) {
            if let data = try? Data(contentsOf: url) {
                activityItems.append(data)
            }
        } else {
            activityItems.append(url)
        }
        return activityItems
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
    
    // opening UIActivityViewController
    func sharePage() {

        guard let url = URL(string: qrUrl) else { return }
        
        let shareController = UIActivityViewController(activityItems: checkActivityItemTypePdf(with: url), applicationActivities: nil)
        
        shareController.completionWithItemsHandler = { activity, completed, _, _ in
            if let activity {
                
                guard let presenter = self.presenter else { return }
                
                if !completed {
                    return
                }
                
                if activity.rawValue == Strings.saveToFileActivityType && completed {
                    presenter.showResultOfSaveAlert(title: Strings.successResultOfSaveAlertTitle)
                } else {
                    presenter.showResultOfSaveAlert(title: Strings.failedResultOfSaveAlertTitle)
                }
            }
        }
        shareController.popoverPresentationController?.sourceView = self.view
        self.present(shareController, animated: true)
    }
    
    func presentError(alert: UIAlertController) {
        present(alert, animated: true)
    }
    
    func presentSaveResult(alert: UIAlertController) {
        present(alert, animated: true)
    }
    
    func dismission() {
        dismiss(animated: true)
    }
}

//MARK: - WKNavigationDelegate methods

extension WebController: WKNavigationDelegate {
    
    func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
        activityIndicator.startAnimating()
    }

    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        updateInteractionUI()
    }
    
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        activityIndicator.stopAnimating()
        
        if let presenter {
            presenter.showLoadingErrorAlert(with: error)
        }
    }
}

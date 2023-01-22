//
//  WebViewController.swift
//  NineNews
//
//  Created by Aruna Sairam on 21/1/2023.
//

import UIKit
import WebKit

class WebViewController: UIViewController {
    private let progressView = UIProgressView()
    private var progressObservation: NSKeyValueObservation?
    private var titleObservation: NSKeyValueObservation?
    private var urlObservation: NSKeyValueObservation?
    private let footerView = UIView()
    private let backwardButton = UIButton(type: .custom)
    private let forwardButton = UIButton(type: .custom)
    private let shareButton = UIButton(type: .custom)
    private let websiteButton = UIButton(type: .custom)
    
    private var webView = WKWebView(frame: CGRect(x: 0.0, y: 0.0, width: 0.1, height: 0.1))
    
    var viewModel: WebViewModelProvider?
    var coordinator: WebViewCoordinator?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        loadWebsite()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    private func setupUI() {
        setupNavigationBar()
        setupProgressView()
        setupWebView()
        setupFooterView()
    }

    private func setupNavigationBar() {
        navigationController?.interactivePopGestureRecognizer?.delegate = self
        navigationController?.navigationBar.prefersLargeTitles = false
        navigationController?.navigationBar.accessibilityIdentifier = AccessibilityIdentifier.webViewNavigationBar
        
        let appearance = UINavigationBarAppearance()
        appearance.configureWithDefaultBackground()
        appearance.backgroundColor = AppColors.accentColor.color
        appearance.titleTextAttributes = [.foregroundColor : UIColor.white]
        
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        
        setupLeftBarButton()
        setupRightBarButton()
    }
    
    private func setupLeftBarButton() {
        let leftButton = UIBarButtonItem(image: SystemImages.backIcon.systemImage, style: .done, target: self, action: #selector(closeButtonTapped))
        leftButton.tintColor = .white
        leftButton.accessibilityIdentifier = AccessibilityIdentifier.webViewNavigationBarBackButton
        navigationItem.leftBarButtonItem = leftButton
    }

    private func setupRightBarButton() {
        let rightButton = UIBarButtonItem(image: SystemImages.refreshIcon.systemImage, style: .done, target: self, action: #selector(refreshButtonTapped))
        rightButton.tintColor = .white
        rightButton.accessibilityIdentifier = AccessibilityIdentifier.webPageRefreshButton
        navigationItem.rightBarButtonItem = rightButton
    }
    
    private func setupFooterView() {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .equalCentering
        stackView.translatesAutoresizingMaskIntoConstraints = false
        footerView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(footerView)
        footerView.addSubview(stackView)
        footerView.backgroundColor = AppColors.accentColor.color
        
        backwardButton.setBackgroundImage(SystemImages.backwardIcon.systemImage, for: .normal)
        backwardButton.addTarget(self, action: #selector(goBackward), for: .touchUpInside)
        backwardButton.isEnabled = false
        backwardButton.accessibilityIdentifier = AccessibilityIdentifier.webPageNavigateBackButton
        
        forwardButton.setBackgroundImage(SystemImages.forwardIcon.systemImage, for: .normal)
        forwardButton.addTarget(self, action: #selector(goForward), for: .touchUpInside)
        forwardButton.isEnabled = false
        forwardButton.accessibilityIdentifier = AccessibilityIdentifier.webPageNavigateForwardButton
        
        shareButton.setBackgroundImage(SystemImages.shareIcon.systemImage, for: .normal)
        shareButton.addTarget(self, action: #selector(shareButtonTapped), for: .touchUpInside)
        shareButton.accessibilityIdentifier = AccessibilityIdentifier.webPageShareButton
        
        websiteButton.setBackgroundImage(SystemImages.websiteIcon.systemImage, for: .normal)
        websiteButton.addTarget(self, action: #selector(viewInSafariTapped), for: .touchUpInside)
        websiteButton.accessibilityIdentifier = AccessibilityIdentifier.viewInBrowserButton
        
        stackView.addArrangedSubview(shareButton)
        stackView.addArrangedSubview(backwardButton)
        stackView.addArrangedSubview(forwardButton)
        stackView.addArrangedSubview(websiteButton)
        
        [backwardButton, forwardButton, shareButton, websiteButton].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.widthAnchor.constraint(equalToConstant: 26).isActive = true
            $0.heightAnchor.constraint(equalTo: $0.widthAnchor, multiplier: 1).isActive = true
        }
        
        NSLayoutConstraint.activate(
            [
                footerView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
                footerView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 0),
                footerView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: 0),
                footerView.heightAnchor.constraint(equalToConstant: 80),
                stackView.topAnchor.constraint(equalTo: footerView.topAnchor, constant: 15),
                stackView.leftAnchor.constraint(equalTo: footerView.leftAnchor, constant: 20),
                stackView.rightAnchor.constraint(equalTo: footerView.rightAnchor, constant: -20)
            ]
        )
        
        setButtonTintColor()
    }
    
    @objc private func goForward() {
        if webView.canGoForward {
            webView.goForward()
        }
    }
    
    @objc private func goBackward() {
        if webView.canGoBack {
            webView.goBack()
        }
    }
    
    @objc private func shareButtonTapped() {
        guard let url = viewModel?.shareableURL else { return }
        
        let text = self.title
        let activity = UIActivityViewController(activityItems: [url, text ?? ""], applicationActivities: nil)
        present(activity, animated: true)
    }
    
    @objc private func viewInSafariTapped() {
        guard let url = viewModel?.shareableURL else { return }

        UIApplication.shared.open(url)
    }
    
    private func setButtonTintColor() {
        [shareButton, backwardButton, forwardButton, websiteButton].forEach {
            $0.tintColor = $0.isEnabled ? .white : .lightGray
        }
    }

    private func setupProgressView() {
        progressView.translatesAutoresizingMaskIntoConstraints = false
        progressView.tintColor = AppColors.progressBarColor.color
        progressView.trackTintColor = AppColors.progressBarTrackColor.color
        progressView.accessibilityIdentifier = AccessibilityIdentifier.webPageProgressBar
        
        view.addSubview(progressView)
        view.backgroundColor = .white
        
        NSLayoutConstraint.activate(
            [
                progressView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 1),
                progressView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: -2),
                progressView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: 2)
            ]
        )
    }
    
    private func setupWebView() {
        webView.navigationDelegate = self
        webView.allowsBackForwardNavigationGestures = true
        webView.translatesAutoresizingMaskIntoConstraints = false
        webView.accessibilityIdentifier = AccessibilityIdentifier.newsWebView
        
        view.addSubview(webView)
    
        NSLayoutConstraint.activate(
            [
                webView.topAnchor.constraint(equalTo: progressView.bottomAnchor, constant: 0),
                webView.leftAnchor.constraint(equalTo: view.leftAnchor),
                webView.rightAnchor.constraint(equalTo: view.rightAnchor),
                webView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
            ]
        )
        
        progressObservation = webView.observe(\WKWebView.estimatedProgress, options: .new) { [weak self] webView, _ in
            self?.updateProgressView(with: Float(webView.estimatedProgress))
        }
        
        titleObservation = webView.observe(\WKWebView.title, options: .new) { [weak self] _, change in
            self?.title = change.newValue as? String
        }
        
        urlObservation = webView.observe(\WKWebView.url, options: [.old, .new]) { [weak self] _, change in
            if let newURL = change.newValue as? URL {
                self?.viewModel?.shareableURL = newURL
            }
        }
    }
    
    private func loadWebsite() {
        guard let url = viewModel?.mainURL else { return }
        
        self.webView.load(URLRequest(url: url))
    }
    
    private func updateProgressView(with value: Float) {
        progressView.progress = value
        
        UIView.animate(withDuration: 0.2) {
            self.progressView.layoutIfNeeded()
        } completion: { _ in
            self.progressView.isHidden = self.progressView.progress == 1.0
        }
    }
    
    @objc private func closeButtonTapped() {
        coordinator?.pop()
    }
    
    @objc private func refreshButtonTapped() {
        webView.reload()
        HapticFeedback.tapped()
    }

    deinit {
        progressObservation = nil
        titleObservation = nil
        urlObservation = nil
    }
}

extension WebViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {}

    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        backwardButton.isEnabled = webView.canGoBack
        forwardButton.isEnabled = webView.canGoForward
        setButtonTintColor()
    }
}

extension WebViewController: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}



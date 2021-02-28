//
//  WebViewViewController.swift
//  EMMAInAppPlugin-Prism
//
//  Created by Adrián Carrera on 26/02/2021.
//

import WebKit


class EMMAWebViewController: UIViewController, WKNavigationDelegate {
    var webView: WKWebView!
    var url: URL? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .clear
        view.isOpaque = false

        let webViewConfig = WKWebViewConfiguration()
        webViewConfig.allowsInlineMediaPlayback = true

        webView = WKWebView(frame: .zero , configuration: webViewConfig)
        webView.navigationDelegate = self
        webView.backgroundColor = .clear
        
        view.addSubview(webView)
        
        adjustWebviewToView()
        addCloseButton()
        
        view.layoutIfNeeded()
    }
    
    func adjustWebviewToView() {
        webView.translatesAutoresizingMaskIntoConstraints = false;
        
        let constraints = [
            view.leadingAnchor.constraint(equalTo: webView.leadingAnchor),
            view.trailingAnchor.constraint(equalTo: webView.trailingAnchor),
            view.topAnchor.constraint(equalTo: webView.topAnchor),
            view.bottomAnchor.constraint(equalTo: webView.bottomAnchor)
        ]
        
        NSLayoutConstraint.activate(constraints)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if let url = url {
            webView.load(URLRequest(url: url))
        }
    }

    func addCloseButton() {
        let img = UIImage(named: "webview_close_btn",
                                  in: Bundle.init(for: self.classForCoder), compatibleWith: nil)
        let closeButton = UIButton(type: .custom)
        closeButton.setImage(img, for: .normal)
        closeButton.addTarget(self, action: #selector(close), for: .touchUpInside)

        closeButton.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(closeButton)

        var topAnchor = view.topAnchor
        if #available(iOS 11.0, *) {
            topAnchor = view.safeAreaLayoutGuide.topAnchor
        }

        let constraints = [
            closeButton.trailingAnchor.constraint(equalTo: webView.trailingAnchor),
            closeButton.topAnchor.constraint(equalTo: topAnchor),
            closeButton.widthAnchor.constraint(equalToConstant: 40),
            closeButton.heightAnchor.constraint(equalToConstant: 40)
        ]

        NSLayoutConstraint.activate(constraints)
    }
    
    @objc func close() {
        dismiss(animated: true, completion: nil)
    }
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        if let url = navigationAction.request.url, DeepLinkManager.isDeeplink(url: url ) {
            DeepLinkManager.open(url: url)
            close()
        }
        
        decisionHandler(.allow)
    }
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        #if DEBUG
        NSLog("Start loading \(webView.url!.absoluteString)")
        #endif
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        #if DEBUG
        NSLog("Finish loading \(webView.url!.absoluteString)")
        #endif
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        #if DEBUG
        NSLog("Start loading \(webView.url!.absoluteString)")
        #endif
    }
}

//
//  WebViewViewController.swift
//  EMMAInAppPlugin-Prism
//
//  Created by Adrián Carrera on 26/02/2021.
//

import WebKit


class EMMAWebViewController: UIViewController, WKNavigationDelegate {
    var webView: WKWebView!
    var activityIndicator: UIActivityIndicatorView!
    var url: URL? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        view.isOpaque = false

        let webViewConfig = WKWebViewConfiguration()
        webViewConfig.allowsInlineMediaPlayback = true

        webView = WKWebView(frame: .zero , configuration: webViewConfig)
        webView.navigationDelegate = self
        webView.backgroundColor = .clear
        
        activityIndicator = UIActivityIndicatorView()
        activityIndicator.center = self.view.center
        activityIndicator.hidesWhenStopped = true
        
        if #available(iOS 13.0, *) {
            activityIndicator.style = .large
        } else {
            activityIndicator.style = .gray
        }
        
        view.addSubview(webView)
        view.addSubview(activityIndicator)
        
        adjustWebviewToView()
        addCloseButton()
        
        view.layoutIfNeeded()
        
        if let url = url {
            webView.load(URLRequest(url: url))
        }
        
        activityIndicator.startAnimating()
    }
    
    func adjustWebviewToView() {
        webView.translatesAutoresizingMaskIntoConstraints = false
        
        let constraints = [
            view.leadingAnchor.constraint(equalTo: webView.leadingAnchor),
            view.trailingAnchor.constraint(equalTo: webView.trailingAnchor),
            view.topAnchor.constraint(equalTo: webView.topAnchor),
            view.bottomAnchor.constraint(equalTo: webView.bottomAnchor)
        ]
        
        NSLayoutConstraint.activate(constraints)
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
        if let url = navigationAction.request.url, DeepLinkManager.isDeeplink(url: url), url.host != nil {
            DeepLinkManager.open(url: url)
            close()
        }
        
        decisionHandler(.allow)
    }
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        Utils.log(msg: "Start loading \(webView.url!.absoluteString)")
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        Utils.log(msg: "Finish loading \(webView.url!.absoluteString)")
        webView.evaluateJavaScript("document.title") { (result, error) in
            self.activityIndicator.stopAnimating()
        }
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        Utils.log(msg: "Navigation failed \(webView.url!.absoluteString) with error \(error.localizedDescription)")
    }
    
    func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
        Utils.log(msg: "Commit navigation")
    }
    
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        Utils.log(msg: "Provisional navigation failed \(webView.url!.absoluteString) with error \(error.localizedDescription)")
    }
}

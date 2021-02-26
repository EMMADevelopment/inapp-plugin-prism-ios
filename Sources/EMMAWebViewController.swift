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
        webView = WKWebView()
        webView.navigationDelegate = self
        webView.backgroundColor = .white
        
        view.addSubview(webView)
        
        adjustWebviewToView()
        
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
    
    func close() {
        dismiss(animated: true, completion: nil)
    }
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        if let url = navigationAction.request.url, EMMADeepLinkManager.isDeeplink(url: url ) {
            EMMADeepLinkManager.open(url: url)
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

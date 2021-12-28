//
//  WebViewVC.swift
//  Pomelo Test App
//
//  Created by Achyuth Bujjigadu  on 27/12/21.
//

import UIKit
import WebKit

class WebViewVC: UIViewController {

    @IBOutlet var webView: WKWebView!
    @IBOutlet var activity: UIActivityIndicatorView!
    var urlAddress = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addActivityIndicatorView()
        loadUrl()
    }
    
    func addActivityIndicatorView() {
        if #available(iOS 13.0, *) {
            activity.style = .large
        } else {
            activity.style = .whiteLarge
        }
        webView.addSubview(activity)
        activity.startAnimating()
        webView.navigationDelegate = self
        activity.hidesWhenStopped = true
    }
    
    func loadUrl() {
        if let url = URL(string: urlAddress) {
            let urlRequest = URLRequest(url: url)
            webView.load(urlRequest)
        }
    }
}

extension WebViewVC: WKNavigationDelegate {
    func webView(_: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Swift.Void) {
        decisionHandler(.allow)
    }

    func webView(_: WKWebView, didFail _: WKNavigation!, withError _: Error) {
        activity.stopAnimating()
    }

    func webView(_: WKWebView, didFinish _: WKNavigation!) {
        activity.stopAnimating()
    }
}

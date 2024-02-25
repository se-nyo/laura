//
//  ViewController.swift
//  laura
//
//  Created by senyo on 2/21/24.
//

import Foundation
import UIKit
import WebKit

class ViewController: UIViewController, WKUIDelegate, WKNavigationDelegate {
    
    var webView: WKWebView!;
    
    
    override func loadView() {
        let webConfiguration = WKWebViewConfiguration()
        webView = WKWebView(frame: .zero, configuration: webConfiguration)
        webView.uiDelegate = self
        view = webView

    }


    override func viewDidLoad() {
        super.viewDidLoad()
        
        let myURL = URL(string:"https://www.apple.com")
        let myRequest = URLRequest(url: myURL!)
        webView.load(myRequest)
    }
    

    
//    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
//          guard let url = navigationAction.request.url else {
//              decisionHandler(.allow)
//              return
//          }
//          
//          let urlString = url.absoluteString
//          let api = API()
//          
//          // Check if the URL contains your redirect URI
//          if urlString.contains(REDIRECT_STRING) {
//              // Extract the authorization code from the URL
//     
//              }
}

//extension WebViewController: WKNavigationDelegate {
//    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
//        didLoadWebView() // Call back to the presenting view controller
//    }
//}

//
//  loginView.swift
//  laura
//
//  Created by senyo on 2/21/24.
//

import Foundation
import SwiftUI
import WebKit

// Access Shared Defaults Object
let userDefaults = UserDefaults.standard

// Write/Set Value


extension UIApplication {
    var firstKeyWindow: UIWindow? {
        return UIApplication.shared.connectedScenes
            .compactMap { $0 as? UIWindowScene }
            .filter { $0.activationState == .foregroundActive }
            .first?.keyWindow

    }
}


class AuthViewController: UIViewController,  WKNavigationDelegate {
    private var webView = WKWebView()
    
    

    @Binding var url: String
    @Binding var isPresented: Bool
    @Binding var token: String

    
    init(isPresented: Binding<Bool>, url: Binding<String>, token: Binding<String>) {
            _isPresented = isPresented
            _url = url
            _token = token
            print(url, "URL IN INIT")
            super.init(nibName: nil, bundle: nil)
            print(self, "SELF")

        
        
        }
        
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
            setupWebView()
            loadWebView()
    }
    
    private func setupWebView() {

        let webConfiguration = WKWebViewConfiguration()
        print("WEB CONFIGURATION \(webConfiguration)")
        webView = WKWebView(frame: .zero, configuration: webConfiguration)
        webView.navigationDelegate = self
        view = webView
    }
    
    private func loadWebView() {
        print("URL IN GUARD:\( url)")
        guard let url = URL(string: url) else {
            return
        }
        let urlRequest = URLRequest(url: url)
        webView.load(urlRequest)

      
    }

    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        guard let url = navigationAction.request.url else {
            return
        }
        let redirect_string = "access_token"
        
        let urlString = url.absoluteString
//        let api = API()
        print("URL FROM ACTION::\(urlString)")
        // Check if the URL contains your redirect URI
        if urlString.contains(redirect_string) {
            print("CONTAINS TOKEN")
            print(self, "SELF")
            var i = urlString.components(separatedBy: "\(redirect_string)=")
            var d = i[1].components(separatedBy: "&")
            token = d[0]
            
            
            self.dismiss(animated: true)
            print("FINAL KEY \(token)")

            print("SELF IN WEBVIE ", self)
//            let vc = (UIApplication.shared.firstKeyWindow?.rootViewController!)!

//            self.present(vc, animated: true, completion: nil)
//            self.view = profile
//            self.dismiss(animated: true, completion: nil)
            self.navigationController?.popViewController(animated: true)

           
            decisionHandler(.allow)

            // Extract the authorization code from the URL

        }else {
            decisionHandler(.allow)
        }
      
    }
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationResponse: WKNavigationResponse, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        print( "NAVIGATION RESPONSE:::\(navigationResponse)")
        decisionHandler(.allow)
    }
}
struct AuthView: UIViewControllerRepresentable{
    typealias UIViewControllerType = AuthViewController
    
    @State var url = "https://id.twitch.tv/oauth2/authorize?response_type=token&client_id=ijkkc54bexnbnwbor1iadizm2ho11d&redirect_uri=/home"
    @State  var isPresented = true
    @State var token:String = ""
    
    func makeUIViewController(context: Context) -> AuthViewController {
        let viewController = AuthViewController(isPresented: $isPresented, url:$url , token:$token)
        return viewController

    }
    
    func updateUIViewController(_ uiViewController: AuthViewController, context: Context) {
        if token.count > 0{
            
            userDefaults.set(token, forKey: "userToken")
            
        }

    }
    
}

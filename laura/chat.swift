////
////  iFrame.swift
////  laura
////
////  Created by senyo on 2/26/24.
////
//
//import Foundation
//import SwiftUI
//import WebKit
//import JavaScriptCore
//
//
//class chatFrameController: UIViewController,  WKNavigationDelegate  {
//    var streamer: String
//    
//    init(streamer:String) {
//        self.streamer = streamer
//            print(streamer, streamer, "URL IN INIT")
//            super.init(nibName: nil, bundle: nil)
//
//        }
//        
//    required init?(coder aDecoder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//    
//    func script(streamer:String)->String{
//        let url  = "https://www.twitch.tv/embed/\(streamer)/chat?parent=http://localhost"
//        let script =
//"""
//           document.getElementById('twitch-chat-embed').src = \(url);
//"""
//        
//        
//        return script
//    }
//    
//    func htmlString()-> String{
//        
//        
//        let html  =
//     """
//    <html>
//      <body>
//    
//        <iframe id="twitch-chat-embed"
//                src="https://www.twitch.tv/embed/\(streamer)/chat?parent=http://localhost"
//                height="500"
//                width="350">
//        </iframe>
//     WHATS GOING GONNNN \(streamer)
//
//
//       
//      </body>
//
//
//    </html>
//
//
//
//    """
//        
//        
//        print(html)
//        
//        
//        return html
//    }
//
//    
//    var webView = WKWebView()
//    
//    var context = JSContext()
//
//    
//
//    
//    override func viewDidLoad() {
//        print("RERUNNING VIEW DID LOAD")
//        super.viewDidLoad()
//        setupWebView(streamer:streamer)
//        
//    }
////            loadWebView()
//        
//    func setupWebView(streamer:String) {
//
//        print("WE IN CAHT ::: (st", streamer)
//        print(htmlString(), "STRING IN SETUp")
//
////        webView.isOpaque = false
////        webView.backgroundColor = UIColor.clear
////        webView.scrollView.backgroundColor = UIColor.clear
////            webView.contentMode = .scaleToFill
//        
////        let userScript = WKUserScript(source: self.script(streamer: streamer), injectionTime: .atDocumentEnd, forMainFrameOnly: false)
////
////        let contentController = WKUserContentController()
////        contentController.addUserScript(userScript)
////
//        let config = WKWebViewConfiguration()
////      config.ignoresViewportScaleLimits = true
////        config.userContentController = contentController
//        webView = WKWebView(frame: CGRect.zero, configuration: config)
//
//          webView.navigationDelegate = self
//          webView.loadHTMLString(htmlString(), baseURL:URL(string: "https://localhost"))
//        view = webView
//        }
//        func loadWebView() {
//            print("WEB VIEW :\( webView)")
////            webView.reload()
//
//        }
//    
//    
//    }
//    
//
//
//struct chatEmbed: UIViewControllerRepresentable{
//    var streamer:String
//
//    func makeUIViewController(context: Context) -> chatFrameController {
//        print(streamer, "DOUBLE CHECk CHAT")
//        let chatController = chatFrameController(streamer: streamer)
//        return chatController
//    }
//    
//    func updateUIViewController(_ uiViewController: chatFrameController, context: Context) {
//        print(streamer, "STREAMER VAR CHAT")
//        DispatchQueue.main.async {
//            uiViewController.streamer = streamer
//            uiViewController.viewDidLoad()
//          }
//    }
//    
//}

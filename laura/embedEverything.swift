//
//  iFrame.swift
//  laura
//
//  Created by senyo on 2/26/24.
//

import Foundation
import SwiftUI
import WebKit
import JavaScriptCore


class embedController: UIViewController,  WKNavigationDelegate  {
    

    
    
    var streamer: String
    

    init(streamer:String) {
        self.streamer = streamer
            print(streamer, streamer, "URL IN INIT")
            super.init(nibName: nil, bundle: nil)

        }
        
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func script(streamer:String)->String{
        print("in make scriot", streamer)
        
        var script =    """
                              new Twitch.Embed("twitch-embed", {
                                width: 854,
                                height: 480,
                                channel: "\(streamer)",
                                // Only needed if this page is going to be embedded on other websites
                                parent: ["embed.example.com", "othersite.example.com"]
                              });
                        """
        
        return script
        
    }
    
    
    
//    new Twitch.Embed("twitch-embed", {
 ////                        width: 854,
 ////                        height: 480,
 ////                        channel: "central_committee"
 ////                      });
        ///
    ///
    ///
//    let parent="http://noiselab.app"
    
    

    let html:String = """
<html>
  <body>
    <!-- Add a placeholder for the Twitch embed -->
    <div id="twitch-embed"></div>

    <!-- Load the Twitch embed JavaScript file -->
    <script src="https://embed.twitch.tv/embed/v1.js"></script>

    <!-- Create a Twitch.Embed object that will render within the "twitch-embed" element -->
  
  </body>
</html>
"""
    
//
//    let ihtml:String = """
//<iframe
//    src="https://player.twitch.tv/?channel=hiswattson&parent=http://localhost"
//    height="400"
//    width="500"
//    allowfullscreen>
//</iframe>
//
//"""



//    let context = JSContext();
//    context.evaluateScript(script);

    
    var webView = WKWebView()
    
    var context = JSContext()

    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupWebView(streamer:streamer)
        
    }
//            loadWebView()
        
    func setupWebView(streamer:String) {

          print("SCRIPT IN SETUP ::: (st", streamer)
          let userScript = WKUserScript(source: self.script(streamer: streamer), injectionTime: .atDocumentEnd, forMainFrameOnly: false)

          let contentController = WKUserContentController()
          contentController.addUserScript(userScript)

          let config = WKWebViewConfiguration()
        config.ignoresViewportScaleLimits = true
          config.userContentController = contentController
          webView = WKWebView(frame: CGRect.zero, configuration: config)
        
        webView.isOpaque = false
        webView.backgroundColor = UIColor.clear
        webView.scrollView.backgroundColor = UIColor.clear
        
//            webView.contentMode = .scaleAspectFill
//            webView.contentMode = .scaleAspectFit
            webView.contentMode = .scaleToFill





          webView.navigationDelegate = self
          webView.loadHTMLString(html, baseURL:URL(string: "http://localhost"))
        view = webView
        }
        func loadWebView() {
            print("WEB VIEW :\( webView)")
//            webView.reload()

            
        }
    
    
    }
    


struct everything: UIViewControllerRepresentable{
    var streamer:String

//    print(streamerVar, "STREAMER")
    

    func makeUIViewController(context: Context) -> embedController {
//        print("HTML: \(html), SCRIPT: \(script)")
        print(streamer, "DOUBLE CHECk")
        let frameController = embedController(streamer: streamer)
        return frameController
    }
    
    func updateUIViewController(_ uiViewController: embedController, context: Context) {
        //print(streamer, "CONTEXT ENEW STREAMER")
        print(streamer, "STREAMER VAR")
        
//        roller.loadWebView()
        print("TRANSACT", context.transaction)
        print("Coordinator", context.coordinator)
//        print("Environment", context.environment)
//        self.makeUIViewController(context: context)
       
        DispatchQueue.main.async {
            uiViewController.streamer = streamer
            uiViewController.viewDidLoad()
//            uiViewController.setupWebView(streamer: streamer)
//            uiViewController.view = frameController(streamer: streamer)
//            view  = frameController(streamer: streamer)
            
//            self.makeUIViewController(context: context)
         
          }




    }
    
}

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

//
//struct controlState{
//    var playing: Bool
//    var volume: Float
//    
//}


class frameController: UIViewController,  WKNavigationDelegate, WKScriptMessageHandler  {
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        print("MESSAGED RECIEVED", message)
    }
    
    @ObservedObject var twitch : Twitch
    init(twitch : Twitch) {
            self.twitch = twitch
                super.init(nibName: nil, bundle: nil)

            }
            
        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
    
     var web = WKWebView()
     
     var context = JSContext()

     override func viewDidLoad() {
         super.viewDidLoad()
         setupWebView()
         
     }
    let html:String = """
<html>
<style>
#twitch-container {
  padding-top: 56.25%;
   position: relative;
   height: 0;
  }
  #twitch-embed iframe {
  position: absolute;
   width:1832.2222245px ;
   height: 1035px;
   top: 0;
margin: -1.2em 0 0 -1.2em;
  }
</style>
<head>
<script src="https://player.twitch.tv/js/embed/v1.js"></script>
</head>
  <body>
<div id="twitch-container">
  <div id="twitch-embed">
</div>
</div>
  </body>
</html>
"""
    
    func script(streamer:String)->String{
        print("in make scriot", streamer)

        var script =    """
                          var options = {
                            channel: "\(streamer)",
                          muted:false
                         
                          };
                        
                        
                          var player = new Twitch.Player("twitch-embed", options);
                        var vol = document.getElementsByClassName("ScCoreButton-sc-ocjdkq-0 caieTg ScButtonIcon-sc-9yap0r-0 dOOPAe")[0]
                        vol.click()
                        vol.click()
                        

                        player.setMuted(false)
                        return(vol.innerHTML)

                        """
        
        
        return script
    }
    func setupWebView(){
        print("SCRIPT IN SETUP ::: (st",twitch.currentStreamer)
        let userScript = WKUserScript(source:script(streamer: twitch.currentStreamer), injectionTime: .atDocumentEnd, forMainFrameOnly: false)

                  let contentController = WKUserContentController()
                  contentController.addUserScript(userScript)

                  let config = WKWebViewConfiguration()
                config.ignoresViewportScaleLimits = true
        
                  config.userContentController = contentController
        
//        config.userContentController.add(self, name: "playHandler")
        
        config.mediaTypesRequiringUserActionForPlayback = []
//        config.allowsInlineMediaPlayback = true
    
        web = WKWebView(frame: CGRect.zero, configuration: config)
        web.backgroundColor = UIColor.clear
        web.scrollView.backgroundColor = UIColor.clear
        web.contentMode = .scaleToFill

        web.isOpaque = false
//       web.navigationDelegate = self

        
        web.loadHTMLString(self.html, baseURL:URL(string: "http://localhost"))
       view = web
        
    }
}


class vidControl: UIViewController , ObservableObject{
    
    
//    @Published var vidState: controlState
    
    @Published var vidActive: Bool = false
    
    @Published var playing: Bool =  true
    @Published var volume: Float =  0.7
    @Published var volActive : Bool = false

    
  

    
}

struct iframe:UIViewControllerRepresentable{
    
    

  var vidController:vidControl
//    @State vidState =
  
    var streamer:String
    var twitch: Twitch
  



    
    @State var web = WKWebView()

    func makeUIViewController(context: Context) -> frameController {

        return frameController(twitch:twitch)
      
    }
    
    func updateUIViewController(_ uiViewController: frameController, context: Context) {
        var uiView  = uiViewController.web
        if vidController.volActive{
            print("VOL: CONTROLLER IS ACTIVE", vidController.volume)
            
            var rounded  = Float(round(10 * vidController.volume) / 10)
            print(rounded, "ROUNDED VIL")
            DispatchQueue.main.async {
                let script = """
                 document.getElementById("twitch-container").click()

                player.setMuted(false)
                player.setVolume(\(rounded))

                """
                print("VOULUME SCRIPT", script)
                uiView.evaluateJavaScript(script){
                    res , error in
                    print(res, error, "RESULT FROM JAVSCRIPT EXECUTION VOLUME")
                }
                vidController.volActive = false
            }
        }
        if vidController.vidActive{
            let script = """
            
              if (\(vidController.playing)){
            
            if (player.isPaused()){
                        player.play()
            }
            
            
            }else{
            player.pause()
            }
            """
            

            print("VID CONTROLLER IS ACTIVE")
            DispatchQueue.main.async {
           
                uiView.evaluateJavaScript(script){
                    res , error in
                    print(res, error, "RESULT FROM JAVSCRIPT EXECUTION")
                }
                DispatchQueue.main.async {
                    vidController.vidActive = false
                }
            }
        }
        
        if twitch.switchStreamer {
            print("SWITCH STREMER TRUE")
            DispatchQueue.main.async {
                
                let script_ = """
                
                  var options = {
                    channel: "\(twitch.currentStreamer)",
                    controls: false
                  };
                  var player = new Twitch.Player("twitch-embed", options);
                
                """
                let script = """

                    if (player){

                    player.setChannel("\(twitch.currentStreamer)")

player.setMuted(false)

                    } else{
                  var options = {
                    channel: "\(twitch.currentStreamer)",
                    controls: false,
                    muted:false
                  };
                  var player = new Twitch.Player("twitch-embed", options);
                    player.setMuted(false)
                    
}

 
                    if (Twitch.Player.PLAYING){
//            window.webkit.messageHandlers.playHandler.postMessage("IS PLAYING");



}

"""
                print("NEW SCRIPT", script)
                uiView.evaluateJavaScript(script){
                    res , error in
                    print(res, error, "RESULT FROM JAVSCRIPT EXECUTION")}}
            DispatchQueue.main.async {
                twitch.switchStreamer = false
            }
        }
       
    }
    

    
}

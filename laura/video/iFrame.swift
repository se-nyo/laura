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


struct controlState{
    var playing: Bool
    var volume: Float
    
}


class vidControl: UIViewController , ObservableObject{
    
    
//    @Published var vidState: controlState
    @Published var active = false
    @Published var playing: Bool =  true
    @Published var volume: Float =  0.9

    
  

    
}

struct iframe: UIViewRepresentable{

  var vidController:vidControl
//    @State vidState =
  
    var streamer:String
    var twitch: Twitch
  
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
                            channel: "\(streamer)"
                          };
                        
                          var player = new Twitch.Player("twitch-embed", options);
                          player.setVolume(0.5);

                        """
        return script
    }
    
    @State var web = WKWebView()


    func makeUIView(context: Context) -> WKWebView {
//        let initialFrame = CGRect(x: 10, y: 10, width: 600, height: 6000)
//        let myView = UIView(frame: initialFrame)
//        
//        myView.addSubview(web)
//        
        
        print("SCRIPT IN SETUP ::: (st",twitch.currentStreamer)
        let userScript = WKUserScript(source:script(streamer: twitch.currentStreamer), injectionTime: .atDocumentEnd, forMainFrameOnly: false)

                  let contentController = WKUserContentController()
                  contentController.addUserScript(userScript)

                  let config = WKWebViewConfiguration()
                config.ignoresViewportScaleLimits = true
        
                  config.userContentController = contentController

        web = WKWebView(frame: CGRect.zero, configuration: config)
        web.backgroundColor = UIColor.clear
        web.scrollView.backgroundColor = UIColor.clear
        web.contentMode = .scaleToFill

        web.isOpaque = false
//       web.navigationDelegate = self
        
        web.loadHTMLString(self.html, baseURL:URL(string: "http://localhost"))
        
//        var wrapperview :some View{
            
// 
//                .ornament(
//                    visibility: .visible,
//                    attachmentAnchor: .scene(.top),
//                    contentAlignment: .bottom
//                ) {
//                    HStack {
//                        Button("Play", systemImage: "play.fill") {
//                            
//                            
//                            print("button click")
//                            var script =    """
//                                                         
//                                                          player.setMuted(false);
//                                                          player.setVolume(0.6);
//                                                        """
//                            
//                            self.web.evaluateJavaScript(script)
//                            
//                        }}}}
        
        
        return web
      
    }
    
    func updateUIView(_ uiView: WKWebView, context: Context) {
//        let userScript = WKUserScript(source:script(streamer: twitch.currentStreamer), injectionTime: .atDocumentEnd, forMainFrameOnly: false)
//        
//        print(vidController.playing, vidController.volume, "STATE OF VIDEO IN UPATE")

        if vidController.active{
            print("VID CONTROLLER IS ACTIVE")
            DispatchQueue.main.async {
                
                let script = """
                
                  if (\(vidController.playing)){
                player.play()
                
                }else{
                player.pause()
                }
                
                        
                
                """
                print("NEW SCRIPT", script)
                uiView.evaluateJavaScript(script){
                    res , error in
                    print(res, error, "RESULT FROM JAVSCRIPT EXECUTION")
                }
                
                vidController.active = false

            }
            
        }
        
        if twitch.switchStreamer {
            print("SWITCH STREMER TRUE")
            DispatchQueue.main.async {
                
                let script = """
                
                  var options = {
                    channel: "\(twitch.currentStreamer)",
                    controls: false
                  };
                  var player = new Twitch.Player("twitch-embed", options);
                
                                                       player.setMuted(false);
                                                       player.setVolume(0.6);
                
                """
                print("NEW SCRIPT", script)
                uiView.evaluateJavaScript(script){
                    res , error in
                    print(res, error, "RESULT FROM JAVSCRIPT EXECUTION")}}
            twitch.switchStreamer = false
        }
       
    }
    
//
//    func updateUIViewController(_ uiViewController: frameController, context: Context) {
////        
//                DispatchQueue.main.async {
//                    print( uiViewController.streamer, "CONTROLLER STREMER")
//                    print( streamer, "PASSED")
//
//                    uiViewController.streamer = streamer
////                    uiViewController.webview = webview
//                    uiViewController.viewDidLoad()
//
//                    }
//        print("UPDATE")
////        if playerState.playing{
////            
////        }
//        
//  
//        
//    }
    
}

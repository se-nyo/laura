//
//  sock.swift
//  laura
//
//  Created by senyo on 3/4/24.
//

import Foundation
import UIKit
import SwiftUI


class sock: UIViewController, URLSessionWebSocketDelegate{
    
    @ObservedObject var twitch: Twitch
    
    var retryCount = 1
    var token:String?
    private var websocket: URLSessionWebSocketTask?
 
   
//   
    
//    init() {
//        // Keep nil if you are not initializing from XIB
//        super.init(nibName: nil, bundle: nil)
//    }
    init(websocket: URLSessionWebSocketTask? = nil, twitch:Twitch) {
//        self.websocket = websocket

        self.twitch = twitch
        
    super.init(nibName: nil, bundle: nil)

    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func connect(){
        print("CONNECT ATTEMPT")
        let session = URLSession(configuration: .default,
                                 delegate:self,
                                 delegateQueue: OperationQueue()
        )
        let url = URL(string: "wss://irc-ws.chat.twitch.tv:443")
        websocket = session.webSocketTask(with: url!)
        websocket?.resume()
        
    }
    

    func ping() {
        websocket?.sendPing{ error in
                            if let error = error{
            print("Pind error: \(error)")
            
        }}
    }
    
    func close() {
        websocket?.cancel(with: .goingAway, reason: "bye".data(using: .utf8))
    }
    
    func send(message:String) {
        DispatchQueue.global().asyncAfter(deadline: .now()+1) {
//                        self.send()
            print("SENDING \(message)")
            self.websocket?.send(.string(message), completionHandler:{ error in
                if let error = error {
                    print("Send ERROR: \(error)")
                }
                
            })
            //        websocket?.send(.string("message"))
        }}
    
    func recieve() {
        
        let chat_message = laura.ChatMessage(id: UUID.init(), message: "", username: "")

        websocket?.receive(completionHandler:{
            [weak self] result in
//            print("RESULT!", result)
        switch result{
            case.success(let message):
                switch message{
                    case.data(let data):
                        print("Data message" /*data*/)
                    case.string(let str):
                    print(str)

                    if str.contains("@badge-info"){
                        DispatchQueue.main.async {
                            self?.twitch.newmsg = str
                        }
                        
//                        recurse
                        var arr :[Int] = []

                       
                        
                        
//                        let o = str.split(separator: "\r\n")
                        let o = str.components(separatedBy:"\r\n")
                        let f = o[0].components(separatedBy:" :")[2]
                        
                        let name_ = str.components(separatedBy: "display-name=")
                        let name = name_[1].components(separatedBy: ";")[0]
                        
                        let max_messages = 15
                     
                    
//                       ##Dis
                        DispatchQueue.main.async {
                            self?.twitch.chatMessages.append(ChatMessage(id: UUID.init(), message:f, username:name))

                        }
                      
                        if self?.twitch.chatMessages.count ?? 0 > max_messages{
                            DispatchQueue.main.async {
                                self?.twitch.chatMessages.removeFirst(1)
                            }
                        }
                    }
                    if str.contains("You are in a maze of twisty passages, all alike"){
                        print("AUTH SUCCESS")
                        self?.send(message: "JOIN #\(self?.twitch.currentStreamer ?? "")")

//                        twitch.chatAuth = true
                         

                         
                        }
                
//                    print(message)
                    }
            case.failure(let error):
                print("error", error)
                
            }
            
            self?.recieve()
        })
        
    }
    
    func reconnect(){
//        
//        let date = Date.now.addingTimeInterval(TimeInterval(retryCount))
//        let timer = Timer(fireAt: date, interval: 0, target: self, selector: #selector(runCode), userInfo: nil, repeats: false)
//        RunLoop.main.add(timer, forMode: .common)
//        
//        func rec
        
//        print("RETRYING THE CONNECTION IN \(retryCount)")
//        DispatchQueue.main.asyncAfter(deadline: .now + retryCount) {
//            self.websocket?.resume()
//        }

    }

    
    func urlSession(_ session: URLSession, webSocketTask: URLSessionWebSocketTask, didOpenWithProtocol protocol: String?) {
        var coms = "CAP REQ :twitch.tv/membership twitch.tv/tags"
        var ptoken = "PASS oauth:\(self.twitch.accessToken)"
        var username = "NICK \(self.twitch.userName ?? "")"
   
        print("CONNETED TO WEBSOCKET")
        ping()

        
            self.send(message:coms);
        
        DispatchQueue.global().asyncAfter(deadline: .now()+1) {
            self.send(message:ptoken);
        }
        DispatchQueue.global().asyncAfter(deadline: .now()+2) {
            self.send(message: username);
        }
     

        recieve()

    }
    
    func urlSession(_ session: URLSession, webSocketTask: URLSessionWebSocketTask, didCloseWith closeCode: URLSessionWebSocketTask.CloseCode, reason: Data?) {
        print("DISCONNECTED REASON: \(String(describing: reason)))")
    }
    
    func urlSession(_ session: URLSession, webSocketTask: URLSessionWebSocketTask, didCompleteWithError error: Error?) {
        
        print("GOT ERR", error)
        
    }
}

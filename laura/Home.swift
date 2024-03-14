//
//  Home.swift
//  laura
//
//  Created by senyo on 2/24/24.
//

import SwiftUI
import Foundation
import Combine
import WebKit
import JavaScriptCore



struct Home: View {
    //    @StateObject var twitch = Twitch()
    @ObservedObject  var twitch : Twitch
    @ObservedObject var vidController = vidControl()
    @State var sock : sock
  
    
    init(twitch: Twitch, sock: sock) {
        self.twitch = twitch
        self.sock = sock
    }

    func userUrl ()-> String{
        
        var f:[String] = []
        var userUrl = "GET https://api.twitch.tv/helix/users?"
        twitch.followedStreamers?.forEach{ streamer in
            print(streamer)
            userUrl = userUrl + "id=\(streamer.broadcaster_id)&"
            print(userUrl, "URL ADDITION")
        }
        print(userUrl, "URL COMPLETION")
        return userUrl
    }
    
    @State  var vidvolume : Double = 50
    @State  var isEditing = false
    var controls: some View {
        
  
        
       return HStack {
            Button("Play", systemImage: "play.fill") {
                print("button click")
                vidController.active = true
                vidController.playing = true
                print(vidController.playing, vidController.volume, "STATE OF VIDEO ")
            }
            Button("Pause", systemImage: "pause.fill") {
                vidController.active = true
                vidController.playing = false
                print(vidController.playing, vidController.volume, "STATE OF VIDEO ")
                
            }
            VStack{
                Slider(
                    value: $vidvolume,
                    in: 0...100,
                    onEditingChanged: { editing in
                        
                        isEditing = editing
                        print(editing)
                        print($vidvolume)
                        print(vidvolume)
                    }
                )
//                        Text("Level: \(vidvolume)")
            }
         .frame(width: 400)
        }.padding(10)
        .labelStyle(.iconOnly)
            .padding(20)
            .glassBackgroundEffect()
    }

    var body: some View {
            
        iframe(vidController: vidController, streamer:twitch.currentStreamer, twitch: twitch).frame(maxWidth: .infinity)
            .ornament(attachmentAnchor: .scene(.trailing)) {
                        chat(twitch: twitch, chatinput: "", sock: sock)
                    }
            .ornament(
                visibility: .visible,
                attachmentAnchor: .scene(.top),
                contentAlignment: .bottom
            ) {
                controls
            }
    }
}

//
//#Preview {
//    Home()
//}

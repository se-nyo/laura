//
//  liveChannels.swift
//  laura
//
//  Created by senyo on 3/9/24.
//

import SwiftUI

struct liveChannels: View {
    @ObservedObject  var twitch : Twitch
    @State var sock : sock
    let channel_user = laura.ChannelUser(id: "", display_name: "", profile_image_url: "")

//    
//    private var placement: ToolbarItemPlacement {
//         #if os(visionOS)
//         return .bottomOrnament
//         #else
//         return .primaryAction
//         #endif
//     }

    var body: some View {
        
        Text("Live Channels")
            .padding([.bottom, .trailing, .top], 20)
            .multilineTextAlignment(.leading)
            .toolbar{
                ToolbarItemGroup(placement: .bottomOrnament) {
                    Spacer()
                    
                    
                    ForEach(twitch.channelUser ?? [channel_user]) { streamer in
                            AsyncImage(url: URL(string:streamer.profile_image_url)) { image in
                                                       image.resizable()
                                                   } placeholder: {
                                                       ProgressView()
                                                   }
                                                   .frame(width: 50, height: 50)
                                                   .clipShape(Circle())
//                                                   Text(streamer.display_name)
                    }
                }
        
                
                
            }
//
//        ScrollView {
//            LazyVStack(alignment: .leading) {
//                ForEach(twitch.channelUser ?? [channel_user]) { streamer in
//                    HStack(){
//                        AsyncImage(url: URL(string:streamer.profile_image_url)) { image in
//                            image.resizable()
//                        } placeholder: {
//                            ProgressView()
//                        }
//                        .frame(width: 50, height: 50)
//                        .clipShape(Circle())
//                        Text(streamer.display_name)
//                    }
//                    .padding(16)
//                    .onTapGesture {
//                       var previousStreamer = twitch.currentStreamer
//                        var newStreamer = streamer.display_name
//                        twitch.currentStreamer = newStreamer
////                        HAS TO RUN IN ORDER CURRENT DOESNT ALWAYS WILLL breaak
//                        print(twitch.currentStreamer,previousStreamer,  "THE ONE CURRENT AND PREV")
//                        sock.send(message: "PART #\(previousStreamer)")
//                        sock.send(message: "JOIN #\(streamer.display_name)")
//                        twitch.chatMessages = []
//                    }
//                    
//                }}}
    }
}

//#Preview {
//    liveChannels()
//}

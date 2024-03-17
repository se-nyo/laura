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

    }
}


//
//  chat.swift
//  laura
//
//  Created by senyo on 3/9/24.
//

import SwiftUI

struct chat: View {
    @ObservedObject  var twitch : Twitch
    @State var chatinput:String = ""
    @State var sock : sock



    var body: some View {
        VStack{
            Spacer()
            Text("\(twitch.currentStreamer) Chat").font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/).padding(10)
            ScrollView {
                LazyVStack(alignment: .leading) {
                    ForEach(twitch.chatMessages) { message in
                        HStack(){
                            Text("\(message.username):")
                            Text(message.message)
                            
                        }
//                        .cornerRadius(8)
                            .padding([.trailing, .leading], 15)
                            .padding([.top, .bottom], 4)

                        .font(.system(size: 20))
                    }
                   
                    .onSubmit {
                        var msg = "PRIVMSG #\(twitch.currentStreamer.lowercased()) :\(chatinput ?? "")"
                        
                        print(msg,"CHAT MSG")
                        
                        sock.send(message: msg)
                        var c_msg = ChatMessage(id: UUID.init(), message: chatinput ?? "", username: twitch.userName ?? "")
                        
//                        chatinput = ""
                        //                            chat.recieve()
                        //                            SENDS TO IRC  BUT WONT REVIEC MY OWN MESSAGES THIS IS NOT IDEAL SOLUTION
                        twitch.chatMessages.append(c_msg)
                    }
                }

            }
            TextField(
                "Type something in chat",
                text: $chatinput
                
            )
            .padding([.leading,.trailing, .top, .bottom], 20)
        }.padding(EdgeInsets())
//            .background(.ultraThickMaterial)
            
        .frame(width:399, height:550)
        .cornerRadius(20)
        .glassBackgroundEffect()
   
    }
}

//#Preview {
//    chat()
//}

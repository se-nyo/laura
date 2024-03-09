//
//  Home.swift
//  laura
//
//  Created by senyo on 2/24/24.
//

import SwiftUI
import Foundation
import Combine





struct Home: View {
//    @StateObject var twitch = Twitch()
    @ObservedObject  var twitch : Twitch
    @State var chat : sock


    
    //    @State var selectedCategoryId =  Twitch().channelUser["id"]
    
    //
    //    func streamManager(id){
    //
    //    }
    func showlist(){
        
        
    }
    //    init(){
    ////        print(type(of: iframe(streamer: "carolinekwann")), "TYPE")
    //    }
//    init() {
//        //        self.twitch = twitch
//        
//    }
    
    func userUrl ()-> String{
        var f:[String] = []
        
        //        let url  =
        var userUrl = "GET https://api.twitch.tv/helix/users?"
        
        twitch.followedStreamers?.forEach{ streamer in
            print(streamer)
            userUrl = userUrl + "id=\(streamer.broadcaster_id)&"
            print(userUrl, "URL ADDITION")
        }
        print(userUrl, "URL COMPLETION")
        return userUrl
    }
    
    
    let caster = laura.Broadcaster(broadcaster_id: "127550308", broadcaster_name: "", followed_at: "2024-03-03T15:45:09Z", broadcaster_login: "")
    
    let live_caster  = laura.LiveStreamer(id: "", user_id:"", user_login: "",  user_name: "", game_id: "", game_name: "", type: "", title: "", viewer_count: 0, started_at: "", language: "", thumbnail_url: "", tag_ids:[] ,tags: [""])
    
    let channel_user = laura.ChannelUser(id: "", display_name: "", profile_image_url: "")
    
    func showStream(id:String){
        
    }
    
    @State var isDraggin : Bool?
    @GestureState var isDragging = false
    
    @State var downHeight = 0.0
    @State var height = 614
    @State var width = 982
    
    @State var chatinput:String = ""
    
    
    
    var dragHandle : some Gesture {
        DragGesture(minimumDistance: 0, coordinateSpace: .global)
            .onChanged { gesture in
                if isDragging {
                    print(Int(gesture.translation.height))
                    height = Int(downHeight) - Int(gesture.translation.height)
                    width = Int(downHeight) - Int(gesture.translation.height)
                    
                } else {
                    downHeight = Double(Int(height))
                }
            }
            .updating($isDragging) { oldState, newState, transaction in
                newState = true
            }
    }
    
    var body: some View {
        


        //        @State var innerView : iframe = iframe(streamer: currentStreamer)
        //. navigationBarHidden(true)
        
        
        HStack(){
            VStack() {
                Text("Live Channels").padding(20).multilineTextAlignment(.leading)
                
                List(twitch.channelUser ?? [channel_user]) { streamer in
                    
                    
                    HStack(){
                        AsyncImage(url: URL(string:streamer.profile_image_url)) { image in
                            image.resizable()
                        } placeholder: {
                            ProgressView()
                        }
                        .frame(width: 50, height: 50)
                        .clipShape(Circle())
                        
                        Text(streamer.display_name)
                    }
                    
                    .onTapGesture {
                        
                       var previousStreamer = twitch.currentStreamer
                        var newStreamer = streamer.display_name
                        twitch.currentStreamer = newStreamer
//                        HAS TO RUN IN ORDER CURRENT DOESNT ALWAYS WILLL breaak
                        print(twitch.currentStreamer,previousStreamer,  "THE ONE CURRENT AND PREV")
                        chat.send(message: "PART #\(previousStreamer)")
                        chat.send(message: "JOIN #\(streamer.display_name)")
                        twitch.chatMessages = []
//                        sock.recieve()

                    }
                    
                }.listStyle(.plain)
            }.frame(width:300)
            
            //                        everything(streamer: currentStreamer)
            
            
//            chatView(twitch: twitch)
            VStack{
                if twitch.currentStreamer != nil {
                    iframe(streamer:twitch.currentStreamer).frame(height: 750)

                }
                
//                ScrollView{
//                    List(twitch.chatMessages ?? [chat_message] ){ message in
//                        Text(message.message)
//                        
//                    }.listStyle(.plain)
//                }
                
                ScrollView {
                    LazyVStack(alignment: .leading) {
                        ForEach(twitch.chatMessages) { message in
                            HStack(){
                                Text("\(message.username):")
                                Text(message.message)
                                    
                            } .font(.system(size: 20))
                                                                
                        }
                        TextField(
                            "Type something in chat",
                            text: $chatinput
                        
                        ).onSubmit {
                            
                            var msg = "PRIVMSG #\(twitch.currentStreamer.lowercased()) :\(chatinput ?? "")"
                            
                            print(msg,"CHAT MSG")
                            
                            chat.send(message: msg)
                            
                            chatinput = ""
//                            chat.recieve()
//                            SENDS TO IRC  BUT WONT REVIEC MY OWN MESSAGES THIS IS NOT IDEAL SOLUTION
                            var c_msg = ChatMessage(id: 200, message: chatinput ?? "", username: twitch.userName ?? "")
                            twitch.chatMessages.append(c_msg)

                        }
                    }
                }
             
            }
        
            //
            //                        .gesture(dragHandle)
            //                            .frame(width: CGFloat(width), height: CGFloat(height))
            //                    .frame(
            //                                        minWidth: 600, maxWidth: 2200,
            //                                        minHeight: 720, maxHeight: 1200
            //
            //                    )
            //                    .border(Color.purple, width: 4)
            
            
            
            //                        chat(streamer: currentStreamer).frame(width: 500)
            //
            
        }.frame(maxWidth: .infinity, alignment: .leading)
            .onAppear(){
            
            
            //
            
            
            //                        twitch.access_token()
            
        }
    }
    
    
    
    
    
    
    
  
    
}

//
//#Preview {
//    Home()
//}

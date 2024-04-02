//
//  nav.swift
//  laura
//
//  Created by senyo on 2/21/24.
//

import SwiftUI


let channel_user = laura.ChannelUser(id: "", display_name: "", profile_image_url: "")
let client_streamer = laura.ClientStreamer(id: "", user_id: "", user_name: "", thumbnail_url: "")


struct nav: View {
    @ObservedObject var twitch: Twitch
    @State var sock: sock
    let loggedin = UserDefaults.standard.bool(forKey: "loggedIn")
    var body: some View {
//        if twitch.isLoggedIn {
            TabView {
                Home(twitch: twitch, sock:sock)
                    .badge(0).tabItem { Label("Home", systemImage: "house.fill")}
                profile(twitch:twitch).badge(0).tabItem { Label("Profile", systemImage: "person.fill") }
            }
            
            .toolbar{
                //                live streamers
                ToolbarItemGroup(placement: .bottomOrnament) {
                    
//                    logged in
                    
                    
                        ForEach(twitch.channelUser ?? [channel_user]) { streamer in
                            AsyncImage(url: URL(string:streamer.profile_image_url)) { image in
                                image.resizable()
                            } placeholder: {
                                ProgressView()
                            }
                            .frame(width: 50, height: 50)
                            .clipShape(Circle())
                            .onTapGesture {
                                DispatchQueue.main.asyncAfter(deadline: .now()) {
                                    var previousStreamer = twitch.currentStreamer
                                    var newStreamer = streamer.display_name
                                    twitch.switchStreamer = true
                                    twitch.currentStreamer = newStreamer
                                    sock.send(message: "PART #\(previousStreamer)")
                                    sock.send(message: "JOIN #\(streamer.display_name)")
                                    twitch.chatMessages = []
                                }
                            }
                        }
                
           
                    Spacer()
                }
            }
            .onAppear(){
                let userCode = userDefaults.string(forKey: "userCode") ?? ""
 
//                implicicit auth flow
//            need to run headless authview controller
//                AuthViewController().loadWebView()
    
                if twitch.userCode.count > 0{
//                    twitch.access_token{ token in
//                        twitch.validateToken(){
//                            user in
//                            twitch.followedLive(userId: user.user_id){ streamers in
//                                var userUrl = "https://api.twitch.tv/helix/users?"
//                                streamers.forEach{streamer in
//                                    userUrl = userUrl + "id=\(streamer.user_id)&"
//                                }
//                                twitch.getUsers(userUrl: userUrl){
//                                    user in
//                                    twitch.currentStreamer = user[0].display_name
//                                    twitch.switchStreamer = true
//                                }
//                                sock.connect()
//                            }
//                        }}
                }
              
                    
                    
//                    Client credentials grant flow
                    twitch.client_token{
                        token in
                        print("HAS CLIENT TOKEN", token)

                        twitch.getStreams{
                            streamers in
                            var userUrl = "https://api.twitch.tv/helix/users?"
                            streamers.forEach{streamer in
                                                         userUrl = userUrl + "id=\(streamer.user_id)&"
                                                     }
                            
                            twitch.getUsers(userUrl: userUrl){
                                                      user in
                                                      twitch.currentStreamer = user[0].display_name
                                                      twitch.switchStreamer = true
                                                  }
                        }
                        
                    }

                    
                    
                    
                    let tok = UserDefaults.standard.string(forKey: "accessToken") ?? ""
                    print(tok, "DA TOKEN")
                }
                
            }
            
//        } else {
//            VStack{
//                
//                VStack{
//                    Image("lauraparent")
//                        .resizable()
//                        .aspectRatio(contentMode: .fit)
//                    
//                    
//                }.frame(width: 400, height: 400)
//             
//                Text("Welcolme to Laura. A twich player for visionOS")
//                Button ("Begin"){
//                    twitch.isPresented.toggle()
//                }.sheet(isPresented:  $twitch.isPresented) {
//                    AuthView(twitch:twitch)
//                }.onChange(of: twitch.isPresented) { newValue in
//                    print( twitch.isPresented)
//                    if  twitch.isPresented == false{
//                        
//                    }
//                }.onAppear(){
//                }}.padding(100)
//               
//            
//         
//        }
    }


//#Preview {
////    nav()
//}

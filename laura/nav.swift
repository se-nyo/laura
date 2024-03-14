//
//  nav.swift
//  laura
//
//  Created by senyo on 2/21/24.
//

import SwiftUI



extension Binding where Value == Bool {
    var not: Binding<Value> {
        Binding<Value>(
            get: { !self.wrappedValue },
            set: { self.wrappedValue = !$0 }
        )
    }
}
let channel_user = laura.ChannelUser(id: "", display_name: "", profile_image_url: "")

struct nav: View {
    @ObservedObject var twitch: Twitch
//    @ObservedObject var playControl = player()

    @State var sock: sock
    
    
    
    let loggedin = UserDefaults.standard.bool(forKey: "loggedIn")
    
    //    print("IS LOGGED IN ??::   \(UserDefaults.standard.bool(forKey: "loggedIn"))")
    
    
    var body: some View {
        
        
        if twitch.isLoggedIn {
            TabView {
                Home(twitch: twitch, sock:sock)
                    .badge(1).tabItem { Label("Home", systemImage: "house.fill")}
                    .ornament( visibility: .visible,
                            attachmentAnchor: .scene(.trailing)) {
                                    chat(twitch: twitch, chatinput: "", sock: sock)
                                }
                
                profile(twitch:twitch).badge(0).tabItem { Label("Profile", systemImage: "person.fill") }
                
                
                
            }
       
            .toolbar{
//                live streamers
                ToolbarItemGroup(placement: .bottomOrnament) {
                    ForEach(twitch.channelUser ?? [channel_user]) { streamer in
                        AsyncImage(url: URL(string:streamer.profile_image_url)) { image in
                            image.resizable()
                        } placeholder: {
                            ProgressView()
                        }
                        .frame(width: 50, height: 50)
                        .clipShape(Circle())
                        //                                                   Text(streamer.display_name)
                        
                        .onTapGesture {
                            DispatchQueue.main.asyncAfter(deadline: .now()) {
                          //            self.websocket?.resume()
                                var previousStreamer = twitch.currentStreamer
                                var newStreamer = streamer.display_name
//                                twitch.allowRefresh = true
                                
                                twitch.switchStreamer = true
                                twitch.currentStreamer = newStreamer
                                sock.send(message: "PART #\(previousStreamer)")
                                sock.send(message: "JOIN #\(streamer.display_name)")
                                twitch.chatMessages = []
                                print(twitch.currentStreamer,previousStreamer,  "THE ONE CURRENT AND PREV")

                                  }
                          
                          
                        
                            //                        HAS TO RUN IN ORDER CURRENT DOESNT ALWAYS WILLL breaak
                           
                        }
                    }
                    
                    Spacer()
                }
            }
            
            
         

            
            
            
            
            
            .onAppear(){
                
                twitch.access_token{ token in
                    //                      print ("TOKEN INFO", token.access_token)
                    twitch.validateToken(){
                        user in
                        
                        print("WE HAVE USER IN THE RIGTH PLACE", user)
                        
                        twitch.followedLive(userId: user.user_id){ streamers in
                            var userUrl = "https://api.twitch.tv/helix/users?"
                            streamers.forEach{streamer in
                                userUrl = userUrl + "id=\(streamer.user_id)&"
                                print(userUrl, "EACH STRESMER USER URL")
                            }
                            print (userUrl,"FINAL URL")
                            twitch.getUsers(userUrl: userUrl){
                                user in
                                
                                twitch.currentStreamer = user[0].display_name
                                
                                twitch.switchStreamer = true

                                print(twitch.currentStreamer, "CURRENT STRemer set in navr")
                                
                            }
                            
                            
//                            SOCK CONNECT
                            
                            sock.connect()
                            
                        }
                        
                        
                    }
                    
                    let tok = UserDefaults.standard.string(forKey: "accessToken") ?? ""
                    print(tok, "DA TOKEN")
                }
                
            }
            
        } else {
            
            Text("You are not logged in. Please login to twitch")
            
            Button ("Log In"){
                twitch.isPresented.toggle()
            }.sheet(isPresented:  $twitch.isPresented) {
                AuthView(twitch:twitch)
            }.onChange(of: twitch.isPresented) { newValue in
                print( twitch.isPresented)
                
                if  twitch.isPresented == false{
                    
                }
                // Will be executed when newValue changes to false
                // I think it will also be called the first time your view is loaded
            }.onAppear(){
                
            }
            
        }
        
        
        
        
    }}


//#Preview {
////    nav()
//}

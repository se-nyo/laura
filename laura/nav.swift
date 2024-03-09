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

prefix func ! (value: Binding<Bool>) -> Binding<Bool> {
    Binding<Bool>(
        get: { !value.wrappedValue },
        set: { value.wrappedValue = !$0 }
    )
}
struct nav: View {
    @ObservedObject var twitch: Twitch
    
    


    let loggedin = UserDefaults.standard.bool(forKey: "loggedIn")
    
//    print("IS LOGGED IN ??::   \(UserDefaults.standard.bool(forKey: "loggedIn"))")

   
      var body: some View {
         @State var chat = sock(twitch: twitch)

       
          
          
          if twitch.isLoggedIn {
              TabView {
                  Home(twitch: twitch, chat:chat)
                      .onAppear(){
      //                    twitch.followed()
                      }
                      .badge(1).tabItem { Label("Home", systemImage: "house.fill")}
                  
                  profile(twitch:twitch).badge(0).tabItem { Label("Profile", systemImage: "person.fill") }
                  


              }.onAppear(){
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
                                  print(twitch.currentStreamer, "CURRENT STRemer set in navr")
                                  
                              }
                              
                              chat.connect()
                              
//                              if twitch.chatAuth{
//                                  print("CHAT AUTHED")
//                                  chat.send(message: "JOIN #\(twitch.currentStreamer)")
//                                  
//                              }
                          }
                          
                          
                      }
                      
                    
      
                      let tok = UserDefaults.standard.string(forKey: "accessToken") ?? ""
                      print(tok, "DA TOKEN")
//                      sock(token: tok).connect()
                   
                      //                  refresh
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

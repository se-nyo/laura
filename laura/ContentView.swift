//
//  ContentView.swift
//  laura
//
//  Created by senyo on 2/21/24.
//

import SwiftUI
import RealityKit
import RealityKitContent
import WebKit



struct ContentView: View {
    
    
    
    
    @State private var username: String = ""
    @State private var password: String = ""
    @State var loginTog = false
    
    @StateObject var twitch = Twitch()



    
   


    var body: some View {

        
        

        
        nav(twitch:twitch).onAppear(){
//            twitch.validateToken()
//            twitch.followed()
//            print(twitch.validUser, "VALID USER")
//            if  twitch.validUser != nil {
//                print(twitch.validUser, "VALID USER")
//                print("running follows")
//                twitch.followed()
//                print(twitch.validUser, "VALID BOYYYY")
//                
//            }
      
//            print(twitch.followedList, "LIST IN APPEAR")

        }
        

    }
    
        

}

#Preview(windowStyle: .automatic) {
    ContentView()
}

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
        @State var sock_ = sock(twitch: twitch)
        
        
        
        
        
        nav(twitch:twitch, sock: sock_)
           
                
                
                
            
        
        
        
    }
}

#Preview(windowStyle: .automatic) {
    ContentView()
}

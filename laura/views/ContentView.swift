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
    @State var isPresented = true
    
    var body: some View {
        @State var sock_ = sock(twitch: twitch)
        
        
        
        //            AuthView(twitch:twitch)    .frame(width: 0, height: 0)
        
        VStack{
            nav(twitch:twitch, sock: sock_)

        }.sheet(isPresented: $isPresented) {
            
            AuthView(twitch:twitch)
                .ornament( visibility: .visible,
                           attachmentAnchor: .scene(.top)) {
                    Button ("Close"){
                        isPresented = false
                    }    .padding([.top], 120)
//                                          .background(.ultraThickMaterial)

                }

        }
    }}

#Preview(windowStyle: .automatic) {
    ContentView()
}

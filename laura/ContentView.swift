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
    
    


    
    

    var body: some View {
        nav()
//        HomeView()
//        WebView(url: URL(string: "https://www.google.com")!)
//                       .ignoresSafeArea()

               

//        VStack{
//            Form {
//                       Section(header: Text("Username")) {
//                           TextField(
//                                   "User name ",
//                                   text: $username
//                               )
//                       }
//                       Section(header: Text("Password")) {
//                           TextField(
//                                   "password (email address)",
//                                   text: $password
//                               )
//                       }
//
//                   }
//            Button(action:login){
//                Label("Sign In", systemImage: "arrow.up")
//            }
//            .sheet(isPresented: $loginTog) {
//                WebView(url: URL(string:
//            "https://www.google.com")!)
//                           .ignoresSafeArea()
//                   }
//        }.padding(100)

    }
}

#Preview(windowStyle: .automatic) {
    ContentView()
}

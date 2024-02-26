//
//  nav.swift
//  laura
//
//  Created by senyo on 2/21/24.
//

import SwiftUI




struct nav: View {
    
    
    
   
      var body: some View {
         
        TabView {
            Home().badge(1).tabItem { Label("Home", systemImage: "house.fill") }
            //            ViewController().badge().tabItem{ Label("Home", systemImage: "house.fill") }
//            loginView(url: URL(string:url)!).badge(0).tabItem { Label("Home", systemImage: "person.fill") }
            
            
            profile().badge(0).tabItem { Label("Home", systemImage: "person.fill") }


        }
        
        
    }}
        

#Preview {
    nav()
}

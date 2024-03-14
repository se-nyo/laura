////
////  player.swift
////  laura
////
////  Created by senyo on 3/10/24.
////

import Foundation
import SwiftUI


class player: ObservableObject {
    
    @Published var playing:Bool = false
    
    
    func play(){
        print("PLAYING ")
        
    }
    
    func pause(){
        
    }
    
    func volume(){
        
    }
    
}

//struct playerView: View {
//    var play = playerController()
//    
//    var body : some View{
//        Text("HELlo")
//        
//        
//        HStack{
//            
//        }
////        TOGLLE PLAY
//        .badge(1).tabItem { Label("Play", systemImage: "house.fill")}
////        .badge(1).tabItem { Label("Pause", systemImage: "house.fill")}
//        
////        VOLUME SLIDER
//
//        
//        
//    }
//    
//}

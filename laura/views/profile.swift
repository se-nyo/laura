//
//  profile.swift
//  laura
//
//  Created by senyo on 2/25/24.
//

import SwiftUI

struct profile: View {
    @ObservedObject var twitch: Twitch
    @State var loggedIn  = UserDefaults.standard.bool(forKey: "loggedIn")
    @State var userName  = UserDefaults.standard.string(forKey: "userName")

    @ViewBuilder
    var body: some View {
        
        
       
        VStack{
            
            if twitch.userName?.count ?? 0 > 0  {
                VStack{
                        Text("Username:")
                            .bold()
                    Text ( twitch.userName ?? "" )
        //                Button ("Log Out"){
        //                    twitch.logout()
        //                }
                }
            }else{
                
                Button ("Login"){
                                  twitch.isPresented.toggle()
                              }.sheet(isPresented:  $twitch.isPresented) {
                                  
                                  AuthView(twitch:twitch)
                                      .ornament( visibility: .visible,
                                                 attachmentAnchor: .scene(.top)) {
                                          Button ("Close"){
                                              twitch.isPresented = false
                                          }    .padding([.top], 120)
//                                          .background(.ultraThickMaterial)

                                      }

                              }.onChange(of: twitch.isPresented) { oldValue,  newValue in
                                  print( twitch.isPresented)
                                  if  twitch.isPresented == false{
              
                                  }
                              }
                
            }
            
        } .onTapGesture(){
            
            twitch.isPresented = false
        }
     

 
        }
        
     
}



//#Preview {
//    profile()
//}

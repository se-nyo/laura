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

//    @State var showingSheet = true
    
    @ViewBuilder
    var body: some View {

         
//        @State var userName = twitch.userName
       
        VStack{
//            AuthView()

//            Text (pc.validUser!.login )
            
            
                Text("Username:")
                    .bold()
            Text ( twitch.userName ?? "" )
//                Button ("Log Out"){
//                    twitch.logout()
//                }
          
           
        }
        }
        
     
}



//#Preview {
//    profile()
//}

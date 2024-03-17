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

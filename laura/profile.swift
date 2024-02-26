//
//  profile.swift
//  laura
//
//  Created by senyo on 2/25/24.
//

import SwiftUI




struct profile: View {
    @StateObject var pc = Twitch()
    @State var isPresented = Twitch().isPresented
//    @State var showingSheet = true
    
    @ViewBuilder
    var body: some View {
        VStack{
            Text("Username:")
            Text(pc.validUser?.login ?? "You are not logged in. Please login to twitch")
                .bold()
//            Text ("Username : \(pc.validUser?.login)")
//            Text (pc.User().)
            
            if pc.isLoggedIn {
                Button ("Log Out"){
                    
                }
            } else {
                Button ("Log In"){
                isPresented.toggle()
                }.sheet(isPresented: $isPresented) {
                    AuthView()
                }
                
            }
           
        }  .onAppear(){
            pc.validateToken()
        }
//        Button("Show Sheet") {
//                   showingSheet.toggle()
//               }
//             
//              
        }
        
     
            
}



#Preview {
    profile()
}

////
////  login.swift
////  laura
////
////  Created by senyo on 2/21/24.
////
//
//import SwiftUI
//import Combine
//import AuthenticationServices
//
//
//
//func loginCall(){
//    
//    
//    let request: OAuth2Request = .init(authUrl: "",
//                                       tokenUrl: "",
//                                       clientId: "",
//                                       redirectUri: "",
//                                       clientSecret: "",
//                                       scopes: [])
//    //
//    @State var cancellable: AnyCancellable?
//
//    cancellable = auth.signIn(with: request)
//        .sink( receiveCompletion: { result in
//            switch result {
//            case .failure(let error):
//                print(error.localizedDescription)
//            default: break
//            }
//        }, receiveValue: { credentials in
//            credentials.save()
//            print(credentials)
//        })
//
//}
//
//struct login: View {
//    
//    let url: String
//    var body: some View {
//        
////        twitch icon
//        
//        Button(action: {
//                       loginCall()
//                    }) {
//                        Text("Login with Twitch")
//                    }
//        
//        
//    }
//}
//
//#Preview {
//    login(url: "")
//}

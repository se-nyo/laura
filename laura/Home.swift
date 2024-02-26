//
//  Home.swift
//  laura
//
//  Created by senyo on 2/24/24.
//

import SwiftUI


struct Home: View {
    
    struct Followed:Decodable {
        let total: Int?
        let data: [
            Dictionary<String, String>
        ]?
        let pagination: Dictionary<String, String>?
    }
    let userDefaults = UserDefaults.standard
    let twitch = Twitch()
   
//    print(key)
    func getKey(){
//        let key = userDefaults.object(forKey: "userKey") as? String
//        let userObj = userDefaults.object(forKey: "userObject") as? Dictionary<String, String>
//        print(key)
//      
//            var encodedUser = userDefaults.object(forKey: "encodedUser")
        
        
//            print("encoede user", encodedUser)
//        do{
//        if encodedUser != nil{
//                print(encodedUser, "ENCODED USER")
//            let userObj = try JSONDecoder().decode(Followed.self, from: encodedUser as! Data)
//                    print(userObj, "USer OBj")
//
//                }
//            }
//      
//        catch {
//            print(error)
//        }
//        
//      
       
        print(twitch.followedList?.data, "IM PRINTO ")

    }
    
//    getKey()

    var body: some View {
//        Text("Hello, World!\(key)")
        
//        Text(twitch.followedList?.total)
        
//        ForEach(.sorted(by: >), id: \.self) {
//            streamer in
//            HStack{
//                Text(   streamer.broadcaster_login
//)
//            }
//        }
        Text("WHYYY")
            .onAppear(){
                twitch.followed()
//                getKey()
            }
    }
}

#Preview {
    Home()
}

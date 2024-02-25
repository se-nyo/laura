//
//  profile.swift
//  laura
//
//  Created by senyo on 2/25/24.
//

import SwiftUI


struct Validated: Decodable {
    "client_id": "wbmytr93xzw8zbg0p1izqyzzc5mbiz",
     "login": "twitchdev",
     "scopes": [
       "channel:read:subscriptions"
     ],
     "user_id": "141981764",
     "expires_in": 5520838

//    let title: String
//    let author: String

}
class pC{
    
    func token()->String{
        let token =  userDefaults.string(forKey: "userKey")
        let token_ = UserDefaults.standard.object(forKey:"userKey")  as? String
        print("TOKEN::: \(token) , TOKEN______: \(token_)")
        return token ?? ""
//        return token_
        
    }
    
    
    
    func validateToken() async throws -> Bool{
        
        Task {
            do {
                let (data, _) = try await URLSession.shared.data(for: request)

                if let books = try? JSONDecoder().decode([Validated].self, from: data) {
                    print(books)
                } else {
                    print("Invalid Response")
                }
            } catch {
                print("Failed to Send POST Request \(error)")
            }
        }
        
        
        
        let url = URL(string: "https://id.twitch.tv/oauth2/validate")!

        var request = URLRequest(url: url)
        request.allHTTPHeaderFields = [
            "0Auth": self.token()
        ]

        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let data = data {
                let image = UIImage(data: data)
            } else if let error = error {
                print("HTTP Request Failed \(error)")
            }
        }

        task.resume()
        
    }
    
    
    func userName() async throws -> String{
        
        let url = URL(string: "https://api.twitch.tv/helix/users/id=\(self.token())" )
        
        
         //create the new url
//         let url = URL(string: "https://api.escuelajs.co/api/v1/products".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")
         
         //create a new urlRequest passing the url
         let request = URLRequest(url: url!)
         
         //run the request and retrieve both the data and the response of the call
         let (data, response) = try await URLSession.shared.data(for: request)
        return "data"
        
        
        print(data, "REESSSSDATA PROFILEs")
    }
}

struct profile: View {
    let pc = pC()
    
    
    var content: some View{
//        Text("Logged in")
        
        
        VStack{
            
            
//            Text("Username : \(pc.username())")
            Text(pc.token())
            
//            Text(pc.userName())

        }.padding(10)
        
        
    }
    var body: some View {

        
//        Text("OUTSIDE GROUP")
        Group {
            
            if pc.token().count > 0 {
//                Text("Logged in")
              content
                
            } else {
                AuthView()
            }
        }

//        Text("WElcomn to profiles")
    }
}

#Preview {
    profile()
}

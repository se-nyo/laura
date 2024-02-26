//
//  twitch.swift
//  laura
//
//  Created by senyo on 2/26/24.
//

import Foundation
class Twitch : ObservableObject{
    @Published var validUser: User?
    @Published var followedList: Followed?

    @Published var isLoggedIn : Bool = false
    @Published var hasError = false
    @Published var isPresented: Bool = false

    let userDefaults = UserDefaults.standard

    struct User:Decodable {
        let client_id: String
        let login: String
        let scopes: [String]?
        let user_id: String
        let expires_in: Int

    }
    struct Followed:Decodable {
        let total: Int
        let data: [
            Dictionary<String, String>
        ]
        let pagination: Dictionary<String, String>
    }
    func token()->String{
        let token =  userDefaults.string(forKey: "userToken")
        let token_ = UserDefaults.standard.object(forKey:"userKey")  as? String
        print("TOKEN::: \(token) , TOKEN______: \(token_)")
        return token ?? ""
//        return token_
    }
    
    func req(baseUrl:String )->URLRequest{
        print("VALIDATING TOKEN", baseUrl)
        
        let url = URL(string:baseUrl)!
        var payload = String()
        var request = URLRequest(url:url)
        request.addValue("Bearer \(self.token())", forHTTPHeaderField: "Authorization")
        request.addValue(
            "application/json",
            forHTTPHeaderField: "Content-Type"
        )
        return request
    }
    

    func validateToken(){
        let validateUrl = "https://id.twitch.tv/oauth2/validate"
        URLSession.shared.dataTask(with: self.req(baseUrl: validateUrl)) { [weak self] data, response, error in
              DispatchQueue.main.async {
                  if error != nil || (response as! HTTPURLResponse).statusCode != 200 {
                      self?.hasError = false
                      self?.isLoggedIn = false
                  } else if let data = data {
                      print(data,"DATATAA")
                      do {
                          let signInResponse = try JSONDecoder().decode(User.self, from: data)
                         self?.validUser = signInResponse
                          
                          self?.isLoggedIn = true
                          self?.isPresented = false
                          self?.userDefaults.set(data, forKey: "encodedUser")
                          self?.userDefaults.set(data, forKey: "encodedUser")
                          self?.userDefaults.set(self?.validUser?.client_id, forKey: "clientId")
//                          print(signInResponse, "USER OB")
                      } catch {
                          print("Unable to Decode Response \(error)")
                      }
                  }
              }
          }.resume()
        
        
    }
    
    func followed(){
//        let client_id = /*validUser*/?.client_id
        var clientId = userDefaults.string(forKey: "clientId")
        
        var followingUrl  = "GET https://api.twitch.tv/helix/channels/followed?client_id=\(clientId)"
        URLSession.shared.dataTask(with: self.req(baseUrl:followingUrl)) { [weak self] data, response, error in
              DispatchQueue.main.async {
                  if error != nil || (response as! HTTPURLResponse).statusCode != 200 {
                      print("ERROR")
                  } else if let data = data {
                      print(data,"DATATAA")
                      do {
                          let signInResponse = try JSONDecoder().decode(Followed.self, from: data)
                         self?.followedList = signInResponse

                      } catch {
                          print("Unable to Decode Response \(error)")
                      }
                  }

              }
          }.resume()
        

        
    }
    
    
}

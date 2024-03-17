//
//  twitch.swift
//  laura
//
//  Created by senyo on 2/26/24.
//

import Foundation
import Combine

struct ChatMessage: Identifiable  {
    let id: UUID
    let message: String
    let username: String

}

struct User:Decodable {
    let client_id: String
    let login: String
    let scopes: [String]?
    let user_id: String
    let expires_in: Int
}
struct Token: Decodable {
    let access_token: String
    let expires_in:  Int
    let refresh_token: String
    let scope: [String]
    let token_type: String
}
struct ChannelUser: Codable, Equatable, Hashable, Identifiable {
    let id : String
    let display_name: String
    let profile_image_url: String
}
struct ChannelUserList: Hashable, Decodable{
   var data:[ChannelUser]
}
struct Followed:Hashable, Decodable {

    let total: Int
    let data:[Broadcaster]
    let pagination: Dictionary<String, String>
}
struct LiveStreamer: Identifiable, Hashable, Codable{
    let id: String
    let user_id: String
    let user_login: String
    let user_name: String
    let game_id: String
    let   game_name: String
    let  type: String
    let   title: String
    let viewer_count: Int
    let  started_at: String
    let language : String
    let   thumbnail_url: String
    let    tag_ids: [String]
    let     tags: [String]
}
struct FollowedLive:Hashable, Decodable {
    let data:[LiveStreamer]
    let pagination: Dictionary<String, String>
}
struct Broadcaster :Hashable, Codable {
    let broadcaster_id: String
    let broadcaster_name:String
    let followed_at:String
    let broadcaster_login:String
}


class Twitch : ObservableObject{

    @Published var validUser: User?
    @Published var followedList: Followed?
    @Published var followedStreamers: [Broadcaster]?
    @Published var followedLive: [LiveStreamer]?
    @Published var channelUserList:ChannelUserList?
    @Published var channelUser:[ChannelUser]?
    @Published var chatMessages:[ChatMessage] = []
    
    @Published var isLoggedIn : Bool = false
    @Published var hasError = false
    @Published var isPresented: Bool = false
    @Published var chatAuth:Bool=false
    @Published var switchStreamer : Bool = true
    @Published var hideAll : Bool = false
    @Published var allowRefresh : Bool?

    @Published var accessToken:String = ""
    @Published var userId:String = ""
    @Published var previousStreamer:String = ""
    @Published var currentStreamer:String = ""
    @Published var userName: String?
    @Published var newmsg : String?

    func code()->String{
        let token =  userDefaults.string(forKey: "userCode") as? String
        return token ?? ""
    }
    
    func access_token(completion:@escaping ((Token) -> Void)){
        let code_val = userDefaults.string(forKey: "userCode") ?? ""
        print(code_val, "USER CODE FROM LOGINUSER CODE FROM LOGIN")

        let params  =  ["client_id=","&client_secret=" , "&code=\(code_val)", "&grant_type=authorization_code&redirect_uri=/home"]
        
        var tokenUrl = """
https://id.twitch.tv/oauth2/token?
"""
        for param in params {
            tokenUrl = tokenUrl + param
            print(tokenUrl)
            
        }
        print(tokenUrl)
        let url = URL(string:tokenUrl)
        var request = URLRequest(url:url!)
        request.httpMethod = "POST"
        URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
              DispatchQueue.main.async {
                  if error != nil || (response as! HTTPURLResponse).statusCode != 200 {
                      self?.isPresented = true
                      self?.isLoggedIn = false
                      UserDefaults.standard.set(false, forKey: "loggedIn")
                      UserDefaults.standard.set("", forKey: "userName")
                  } else if let data = data {
                      do {
                          let tokenResponse = try JSONDecoder().decode(Token.self, from: data)
                          self?.accessToken = tokenResponse.access_token
                          self?.isLoggedIn = true
                          UserDefaults.standard.set(true, forKey: "loggedIn")
                          completion(tokenResponse)
                      } catch {
                          print("Unable to Decode Response \(error)")
                      }
                  }
              }
          }.resume()
        
    }
    
    func loggedIn(){
        self.isLoggedIn = true
    }
 

    
    func req(baseUrl:String )->URLRequest{
        
        let clientId  = self.validUser?.client_id ?? ""
        
        print(clientId, "CLIENTID")
        
        
        let url = URL(string:baseUrl)
        print(url, "URL FROM URL")
        
            var request = URLRequest(url:url!)
            request.addValue("Bearer \(self.accessToken)", forHTTPHeaderField: "Authorization")
            request.addValue( clientId, forHTTPHeaderField: "Client-Id")

            request.addValue(
                "application/json",
                forHTTPHeaderField: "Content-Type"
            )
        
            return request
    }
        
    func validateToken(completion:@escaping ((User) -> Void)){
        let validateUrl = "https://id.twitch.tv/oauth2/validate"
        URLSession.shared.dataTask(with: self.req(baseUrl: validateUrl)) { [weak self] data, response, error in
              DispatchQueue.main.async {
                  if error != nil || (response as! HTTPURLResponse).statusCode != 200 {
                  } else if let data = data {
                      print(data,"D")
                      do {
                          let signInResponse = try JSONDecoder().decode(User.self, from: data)
                         self?.validUser = signInResponse
                          self?.userName = signInResponse.login
                          self?.userId = signInResponse.user_id
completion(signInResponse)
                      } catch {
                          print("Unable to Decode Response \(error)")
                      }
                  }
              }
          }.resume()
        
        
    }
    
//    
    func followedLive(userId:String, completion:@escaping (([LiveStreamer]) -> Void)){
        
        let url = "https://api.twitch.tv/helix/streams/followed?user_id=\(userId)"
       
        
        URLSession.shared.dataTask(with: self.req(baseUrl:url)) { [weak self] data, response, error in
              DispatchQueue.main.async {
                  if error != nil || (response as! HTTPURLResponse).statusCode != 200 {
                 print(error, "ERROR", response)
                  } else if let data = data {
                          do {
                             let res = try JSONDecoder().decode(FollowedLive.self, from: data)
                              self?.followedLive = res.data
                              completion(res.data)
                          } catch {
                              print("Unable to Decode Response \(error)")
                          }
                  }
              }
          }.resume()
    }

    func followed(live:Bool? ,completion:@escaping (([LiveStreamer]) -> Void)){
        var userId = userDefaults.string(forKey: "userId")!
        func makeUrl(live:Bool?) -> String{
            if live == true {
                return  "https://api.twitch.tv/helix/streams/followed?user_id=\(userId)"
            } else {
                return  "https://api.twitch.tv/helix/channels/followed?user_id=\(userId)"
            }
        }
        URLSession.shared.dataTask(with: self.req(baseUrl:makeUrl(live:live))) { [weak self] data, response, error in
              DispatchQueue.main.async {
                  if error != nil || (response as! HTTPURLResponse).statusCode != 200 {
                 print(error, "ERROR", response)
                  } else if let data = data {
                      if live == true {
                          print("LIVE TRUEEE")
                          do {
                             let res = try JSONDecoder().decode(FollowedLive.self, from: data)
                              
                              self?.followedLive = res.data
                          } catch {
                              print("Unable to Decode Response \(error)")
                          }
                      }else {
                          do {
                             let res = try JSONDecoder().decode(Followed.self, from: data)
                              self?.followedList = res
                              self?.followedStreamers = res.data
                          } catch {
                              print("Unable to Decode Response \(error)")
                          }
                      }
                  
                  }
              }
          }.resume()
    }
    func getUser(userUrl:String){

        URLSession.shared.dataTask(with: self.req(baseUrl: userUrl)) { [weak self] data, response, error in
              DispatchQueue.main.async {
                  
                  if error != nil || (response as! HTTPURLResponse).statusCode != 200 {
                      self?.isLoggedIn = false
                  } else if let data = data {
                      do {
                          let res  = try JSONDecoder().decode(ChannelUserList.self, from: data)
                          self?.channelUserList = res
                          self?.channelUser = res.data
                      } catch {
                          print("Unable to Decode Response \(error)")
                      }
                  }
              }
          }.resume()
        
    }
    
    func getUsers(userUrl:String, completion:@escaping (([ChannelUser]) -> Void)){
        
        URLSession.shared.dataTask(with: self.req(baseUrl: userUrl)) { [weak self] data, response, error in
              DispatchQueue.main.async {
                  
                  if error != nil || (response as! HTTPURLResponse).statusCode != 200 {
                  } else if let data = data {
                      do {
                          let res  = try JSONDecoder().decode(ChannelUserList.self, from: data)
                          self?.channelUserList = res
                          self?.channelUser = res.data
                          completion(res.data)
                      } catch {
                          print("Unable to Decode Response \(error)")
                      }
                  }
              }
          }.resume()
        
    }
      
   
}

//
//  twitch.swift
//  laura
//
//  Created by senyo on 2/26/24.
//

import Foundation
import Combine

struct ChatMessage: Identifiable  {
    let id: Int
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
    
//    let id = UUID(),
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
    
    
    @Published var userName: String?

//    @Published var broadcaster: Broadcaster?
    
    @Published var channelUserList:ChannelUserList?
    @Published var channelUser:[ChannelUser]?



    @Published var isLoggedIn : Bool = false
    @Published var hasError = false
    @Published var isPresented: Bool = false
    @Published var accessToken:String = ""
    @Published var userId:String = ""
    @Published var currentStreamer:String = ""
    @Published var chatAuth:Bool=false
    
    
    @Published var chatMessages:[ChatMessage] = []
    
    @Published var newmsg : String?


    



    
    func code()->String{

        let token =  userDefaults.string(forKey: "userCode") as? String
//        let token_ = UserDefaults.standard.object(forKey:"userKey")  as? String
        
//        should validae h
        return token ?? ""
//        return ""
    }
    
    
    func access_token(completion:@escaping ((Token) -> Void)){
        let code_val = userDefaults.string(forKey: "userCode") ?? ""
        print(code_val, "USER CODE FROM LOGINUSER CODE FROM LOGIN")

        let params  =  ["client_id=fi2u1al8b9d6l8w3pw184gr0yk71vo","&client_secret=fc64zof4oeeut9fimj3mv69hew5xfb" , "&code=\(code_val)", "&grant_type=authorization_code&redirect_uri=/home"]
        
        var tokenUrl = """
https://id.twitch.tv/oauth2/token?
"""
        for param in params {
            tokenUrl = tokenUrl + param
            print(param)
            
            print(tokenUrl)
            
        }
        print(tokenUrl)
        let url = URL(string:tokenUrl)
        var request = URLRequest(url:url!)
        request.httpMethod = "POST"

//        let clientId  = userDefaults.string(forKey: "clientId")!
//        let client_id  = "client_id=fi2u1al8b9d6l8w3pw184gr0yk71vo&"
//        let client_secret = "client_secret=fc64zof4oeeut9fimj3mv69hew5xfb&"
//        let code_val  = "code=\(code)&"
//        let grant  = "grant_type=authorization_code&redirect_uri=http://localhost"
       
        URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
              DispatchQueue.main.async {
                  if error != nil || (response as! HTTPURLResponse).statusCode != 200 {
                      
                   print("ERR AACCES TOKEN \(response)", error)
                      self?.isPresented = true
                      UserDefaults.standard.set(false, forKey: "loggedIn")
                      UserDefaults.standard.set("", forKey: "userName")
                      
                  } else if let data = data {
                      print(data,"D0000")
                      do {
                          let tokenResponse = try JSONDecoder().decode(Token.self, from: data)
//                         self?.validUser = signInResponse
                        print(tokenResponse, "RESPONSE FRON ACCESS TOKEN")
                          
                          self?.accessToken = tokenResponse.access_token
                          
                          UserDefaults.standard.set(true, forKey: "loggedIn")

                          completion(tokenResponse)
//                          print("VALID TOKEN, \(self?.validUser)")
//                          print(signInResponse, "USER OB")
                      } catch {
                          print("Unable to Decode Response \(error)")
                      }
                  }
              }
          }.resume()
        
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
        
//        print(request, "REQQQQ")
            return request

        
      
    }
    
    
    
//    func logout (){
//        let clientId = userDefaults.string(forKey: "clientId")
//        let url = "https://id.twitch.tv/oauth2/revoke?client_id=\( adminId ?? "")&token=\(self.token())"
//        
//        URLSession.shared.dataTask(with: self.req(baseUrl: url)) { [weak self] data, response, error in
//              DispatchQueue.main.async {
//                  if error != nil || (response as! HTTPURLResponse).statusCode != 200 {
//                 print("ERRRRRRR", error, response)
//
//                  } else if let data = data {
//                      print(data,"D0000")
//                      do {
//                          let logoutRes = try JSONDecoder().decode(User.self, from: data)
//                          print(logoutRes, "KOGOUTT")
//                          
//                      } catch {
//                          print("Unable to Decode Response \(error)")
//                      }
//                  }
//              }
//          }.resume()
//        
//    }
//    

        
    func validateToken(completion:@escaping ((User) -> Void)){
        let validateUrl = "https://id.twitch.tv/oauth2/validate"
        URLSession.shared.dataTask(with: self.req(baseUrl: validateUrl)) { [weak self] data, response, error in
              DispatchQueue.main.async {
                  if error != nil || (response as! HTTPURLResponse).statusCode != 200 {
                      
                      print("TOKEN AINT VALID", response)


                  } else if let data = data {
                      print(data,"D0000")
                      do {
                          let signInResponse = try JSONDecoder().decode(User.self, from: data)
                         self?.validUser = signInResponse
//                          self?.userDefaults.set(true, forKey: "isLoggedIn")
                          self?.userName = signInResponse.login
                          self?.userId = signInResponse.user_id
completion(signInResponse)
                          
                          print("VALID TOKEN, \(self?.validUser)")
//                          print(signInResponse, "USER OB")
                      } catch {
                          print("Unable to Decode Response \(error)")
                      }
                  }
              }
          }.resume()
        
        
    }
    
//    
//    func followed(){
//        let uid = userDefaults.string(forKey: "userId")
//        let url = URL(string: "https://api.twitch.tv/helix/channels/followed?user_id=\(uid)")!
//        let request = URLRequest(url: url)
//        
//        let cancellable = URLSession.shared.dataTaskPublisher(for: request)
//            .sink(receiveCompletion: { completion in
//                switch completion {
//                case .finished:
//                    ()
//                case .failure(let error):
//                    print("Failed to Send POST Request \(error)")
//                }
//            }, receiveValue: { _, response in
//                let statusCode = (response as! HTTPURLResponse).statusCode
//
//                if statusCode == 200 {
//                    print("SUCCESS")
//                } else {
//                    print("FAILURE")
//                }
//            })
//
//    }
//    
    func followedLive(userId:String, completion:@escaping (([LiveStreamer]) -> Void)){
//        let client_id = /*validUser*/?.client_id
//        var userId = self.userId

        
        let url = "https://api.twitch.tv/helix/streams/followed?user_id=\(userId)"
       
        
        URLSession.shared.dataTask(with: self.req(baseUrl:url)) { [weak self] data, response, error in
              DispatchQueue.main.async {
                  if error != nil || (response as! HTTPURLResponse).statusCode != 200 {
                 print(error, "ERROR", response)
                  } else if let data = data {
                      print(data,"DATATAA")

                          do {
                             let res = try JSONDecoder().decode(FollowedLive.self, from: data)
                              
                              self?.followedLive = res.data
                              
                              completion(res.data)
                              print(res)
                        

    //                          self?.userDefaults.set(followedList, forKey: "followed")
                          } catch {
                              print("Unable to Decode Response \(error)")
                          }
                        
                  
                  }
              }
          }.resume()
    }
    
//    func followedLive
    func followed(live:Bool? ,completion:@escaping (([LiveStreamer]) -> Void)){
//        let client_id = /*validUser*/?.client_id
        var userId = userDefaults.string(forKey: "userId")!
        print("WE HAVE USE ID ", userId)
        
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
                      print(data,"DATATAA")
                      
                      if live == true {
                          print("LIVE TRUEEE")
                          do {
                             let res = try JSONDecoder().decode(FollowedLive.self, from: data)
                              
                              self?.followedLive = res.data
                              
//                              completion(res.data)

                        

    //                          self?.userDefaults.set(followedList, forKey: "followed")
                          } catch {
                              print("Unable to Decode Response \(error)")
                          }
                          
                          
                          
                      }else {
                          do {
                             let res = try JSONDecoder().decode(Followed.self, from: data)
                              self?.followedList = res
                              self?.followedStreamers = res.data
//                              completion(res.data)

                              print(self?.followedStreamers, "STREMERS")
                              print(self?.followedList,  "FOLLOWED")


    //                          self?.userDefaults.set(followedList, forKey: "followed")
                          } catch {
                              print("Unable to Decode Response \(error)")
                          }
                      }
                  
                  }
              }
          }.resume()
    }
    func getUser(userUrl:String){
//        let userUrl = "GET https://api.twitch.tv/helix/users?id\(userId)"
        URLSession.shared.dataTask(with: self.req(baseUrl: userUrl)) { [weak self] data, response, error in
              DispatchQueue.main.async {
                  
                  if error != nil || (response as! HTTPURLResponse).statusCode != 200 {
//                      self?.hasError = false
                      self?.isLoggedIn = false



                  } else if let data = data {
                      do {
                          let res  = try JSONDecoder().decode(ChannelUserList.self, from: data)
//                          return res
                          self?.channelUserList = res
                          
                          self?.channelUser = res.data
                          self?.currentStreamer = res.data[0].display_name
//                          completion(res.data)
                          print( self?.channelUser , "CHANNEL UES IN ASSIGNMENT")
//                          print(signInResponse, "USER OB")
                      } catch {
                          print("Unable to Decode Response \(error)")
                      }
                  }
              }
          }.resume()
        
    }
    
    func getUsers(userUrl:String, completion:@escaping (([ChannelUser]) -> Void)){
//        let userUrl = "GET https://api.twitch.tv/helix/users?id\(userId)"
        URLSession.shared.dataTask(with: self.req(baseUrl: userUrl)) { [weak self] data, response, error in
              DispatchQueue.main.async {
                  
                  if error != nil || (response as! HTTPURLResponse).statusCode != 200 {
//                      self?.hasError = false
                      self?.isLoggedIn = false



                  } else if let data = data {
                      do {
                          let res  = try JSONDecoder().decode(ChannelUserList.self, from: data)
//                          return res
                          print(res, "RESPONSE FROM CHANEL USER LIS")
                          self?.channelUserList = res
                          
                          self?.channelUser = res.data
                          completion(res.data)
                          print( self?.channelUser , "CHANNEL UES IN ASSIGNMENT")
//                          print(signInResponse, "USER OB")
                      } catch {
                          print("Unable to Decode Response \(error)")
                      }
                  }
              }
          }.resume()
        
    }
    
//    func extractEmoteName(from input: String, rangeStart: Int, rangeEnd: Int) -> String? {
//        let message = input.unicodeScalars
//        
//        guard
//            let indexStart = message.index(message.startIndex, offsetBy: rangeStart, limitedBy: message.endIndex),
//            let limitIndex = message.index(message.endIndex, offsetBy: -1, limitedBy: message.startIndex),
//            let indexEnd = message.index(message.startIndex, offsetBy: rangeEnd, limitedBy: limitIndex)
//        else {
//            print("out of bounds")
//            return nil
//        }
//        
//        return String(message[indexStart ... indexEnd])
//
//    
   
}

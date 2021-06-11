//
//  APIService.swift
//  TwitterAssignment
//
//  Created by Madhuri Patil on 10/06/21.
//

import Foundation
import TwitterKit

class APIService: NSObject {
    
    func getAccessToken(userId: String, screenName: String, completion : @escaping (String?, String?) -> ()) {
        let encodedConsumerKeyString:String = ConsumerKey.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlHostAllowed)!
        let encodedConsumerSecretKeyString:String = consumerSecret.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlHostAllowed)!
        
        //Combine both encodedConsumerKeyString & encodedConsumerSecretKeyString with " : "
        let combinedString = encodedConsumerKeyString+":"+encodedConsumerSecretKeyString
        
        //Base64 encoding
        let data = combinedString.data(using: .utf8)
        let encodingString = "Basic "+(data?.base64EncodedString())!
        
        //Create URL request
        var request = URLRequest(url: URL(string: "https://api.twitter.com/oauth2/token")!)
        request.httpMethod = "POST"
        request.setValue(encodingString, forHTTPHeaderField: "Authorization")
        request.setValue("application/x-www-form-urlencoded;charset=UTF-8", forHTTPHeaderField: "Content-Type")
        let bodyData = "grant_type=client_credentials".data(using: .utf8)!
        request.setValue("\(bodyData.count)", forHTTPHeaderField: "Content-Length")
        request.httpBody = bodyData
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else { // check for fundamental networking error
                completion(nil, error?.localizedDescription)
                return
            }
            
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 { // check for http errors
                completion(nil, response.debugDescription)
            }
            
            do {
                let response = try JSONSerialization.jsonObject(with: data, options: []) as! Dictionary<String, Any>
                
                if  let accessToken = response["access_token"] as? String {
                    UserDefaults.standard.set(accessToken, forKey: "accessToken")
                    completion(accessToken, nil)
                }
            } catch let error as NSError {
                completion(nil, error.localizedDescription)
            }
        }
        task.resume()
    }
    
    func getUserDetails(accessToken: String, userId: String, screenName: String, completion : @escaping (User?, String?) -> ()) {
        var request = URLRequest(url: URL(string: "https://api.twitter.com/1.1/users/show.json?screen_name=\(screenName)")!)
        
        request.httpMethod = "GET"
        request.setValue("Bearer "+accessToken, forHTTPHeaderField: "Authorization")
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in guard let data = data, error == nil else { // check for fundamental networking error
            completion(nil, error?.localizedDescription)
            return
        }
        
        if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 { // check for http errors
            completion(nil, error?.localizedDescription)
        }
        
        do {
            let jsonDecoder = JSONDecoder.init()
            let user = try jsonDecoder.decode(User.self, from: data)
            completion(user, nil)
        } catch let error as NSError {
            print(error)
        }
        }
        task.resume()
    }
    
    
    func getFriendList(accessToken: String, screenName: String, cursor: Int, completion : @escaping (FriendList?, String?) -> ()){
        let requestUrl = URL(string: "https://api.twitter.com/1.1/friends/list.json?cursor=\(cursor)&screen_name=\(screenName)&skip_status=true&include_user_entities=false&count=10")
        if let url = requestUrl {
            
            var request = URLRequest(url: url)
            
            request.httpMethod = "GET"
            request.setValue("Bearer "+accessToken, forHTTPHeaderField: "Authorization")
            let task = URLSession.shared.dataTask(with: request) { data, response, error in guard let data = data, error == nil else { // check for fundamental networking error
                completion(nil, error?.localizedDescription)
                return
            }
            
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 { // check for http errors
                completion(nil, response.debugDescription)
            }
            
            do {
                let jsonDecoder = JSONDecoder.init()
                let friendList = try jsonDecoder.decode(FriendList.self, from: data)
                completion(friendList, nil)
            } catch let error as NSError {
                print(error)
            }
            }
            task.resume()
        }
    }
    
    func getFollowersList(accessToken: String, screenName: String, completion : @escaping (FriendList?, String?) -> ()) {
        let requestUrl = URL(string: "https://api.twitter.com/1.1/followers/list.json?cursor=-1&screen_name=\(screenName)&skip_status=true&include_user_entities=false")
        if let url = requestUrl {
            
            var request = URLRequest(url: url)
            
            request.httpMethod = "GET"
            request.setValue("Bearer "+accessToken, forHTTPHeaderField: "Authorization")
            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                guard let data = data, error == nil else { // check for fundamental networking error
                    completion(nil, error?.localizedDescription)
                    return
                }
                
                if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 { // check for http errors
                    completion(nil, response.debugDescription)
                }
                do {
                    let jsonDecoder = JSONDecoder.init()
                    let friendList = try jsonDecoder.decode(FriendList.self, from: data)
                    completion(friendList, nil)
                } catch let error as NSError {
                    print(error)
                }
            }
            task.resume()
        }
        
        
    }
}

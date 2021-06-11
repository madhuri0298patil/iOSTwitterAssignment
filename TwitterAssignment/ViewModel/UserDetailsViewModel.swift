//
//  UserDetailsViewModel.swift
//  TwitterAssignment
//
//  Created by Madhuri Patil on 09/06/21.
//

import Foundation
import TwitterKit

class UserDetailsViewModel: NSObject {
    var user: User?
    private var apiService : APIService?
    
    var friendList: FriendList? {
        didSet {
            getlist()
        }
    }
    var error: String? {
        didSet {
            self.gotError()
        }
    }
    
    init(user: User) {
        super.init()
        self.user = user
        self.apiService =  APIService()
        
        if let accessToken = UserDefaults.standard.string(forKey: "accessToken"), let screenName = user.screenName {
            self.callGetFollowersListApi(accessToken: accessToken, screenName: screenName) { (friendList, error) in
                if let data = friendList {
                    self.friendList = data
                } else if let error = error {
                    self.error = error
                }
            }
        }
        
    }
    
    
    var getlist : (() -> ()) = {}
    
    var gotError : (() -> ()) = {}
    
    func callGetFollowersListApi(accessToken: String, screenName: String, completion : @escaping (FriendList?, String?) -> ()) {
        apiService?.getFollowersList(accessToken: accessToken, screenName: screenName, completion: { (friendList, error) in
            completion(friendList, error)
        })
    }
    
    func callGetFriendListApi(accessToken: String, screenName: String, cursor: Int = -1, completion : @escaping (FriendList?, String?) -> ()) {
        apiService?.getFriendList(accessToken: accessToken, screenName: screenName, cursor: cursor) { (friendList, error) in
            completion(friendList, error)
        }
    }
}

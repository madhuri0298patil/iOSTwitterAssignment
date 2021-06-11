//
//  LoginViewModel.swift
//  TwitterAssignment
//
//  Created by Madhuri Patil on 09/06/21.
//

import Foundation
import TwitterKit

class LoginViewModel: NSObject {
    var user: User? {
        didSet {
            self.signedInSuccessfully()
        }
    }
    
    var error: String? {
        didSet {
            self.signedInFailed()
        }
    }
    
    private var apiService : APIService?
    
    override init() {
        super.init()
        self.apiService =  APIService()
        self.signInWithTwitter()
    }
    
    var signedInSuccessfully : (() -> ()) = {}
    var signedInFailed: (() -> ()) = {}
    
    
    // MARK: - API calls
    func signInWithTwitter() {
        TWTRTwitter.sharedInstance().logIn { (session, error) in
            if let userSession = session {
                self.callGetAccessToken(userId:  userSession.userID, screeName: userSession.userName) { (accessToken, error) in
                    if let token = accessToken {
                        self.callGetUserDetails(accessToken: token, userId: userSession.userID, screeName: userSession.userName)
                    } else if let error = error {
                        self.error = error
                    }
                }
            } else {
                self.error = error?.localizedDescription
            }
        }
        
    }
    
    func callGetAccessToken(userId: String, screeName: String,  completion : @escaping (String?, String?) -> ()) {
        apiService?.getAccessToken(userId: userId, screenName: screeName, completion: { (accessToken, errorMessage)  in
            completion(accessToken, errorMessage)
        })
    }
    
    func callGetUserDetails(accessToken: String, userId: String, screeName: String)  {
        apiService?.getUserDetails(accessToken: accessToken, userId: userId, screenName: screeName, completion: { (user, errorMessage) in
            if let user = user {
                self.user = user
            }
            
            if let error = errorMessage {
                self.error = error
            }
        })
    }
}

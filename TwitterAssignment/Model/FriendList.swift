//
//  FriendList.swift
//  TwitterAssignment
//
//  Created by Madhuri Patil on 10/06/21.
//

import Foundation

// MARK: - User
struct User: Decodable {
    let name: String?
    let screenName: String?
    let profileUrl: String?
    let friendsCount: Int?
    let followersCount: Int?
    let profileImageUrl: String?
    
    enum CodingKeys: String, CodingKey {
        case name
        case screenName = "screen_name"
        case profileUrl = "profile_image_url"
        case friendsCount = "friends_count"
        case followersCount = "followers_count"
        case profileImageUrl = "profile_image_url_https"
    }
}

// MARK: - FriendList
struct FriendList: Decodable {
    var users: [User]
    let nextCursor: Int?
    let nextCursorStr: String?
    let previousCursor: Int?
    let PreviousCursorStr: String?
//    let totalCount: String?
    
    enum CodingKeys: String, CodingKey {
        case users
        case nextCursor = "next_cursor"
        case nextCursorStr = "next_cursor_str"
        case previousCursor = "previous_cursor"
        case PreviousCursorStr = "previous_cursor_str"
//        case totalCount = "total_count"
    }
    
    
}

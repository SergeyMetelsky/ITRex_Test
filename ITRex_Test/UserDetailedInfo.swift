//
//  DetailedUserInfo.swift
//  ITRex_Test
//
//  Created by Sergey on 3/31/21.
//

import Foundation

struct UserDetailedInfo: Decodable {
    
    let avatar_url: String?
    let bio: String?
    let blog: String?
    let company: String?
    let created_at: String?
    let email: String?
    let events_url: String?
    let followers: Int?
    let followers_url: String?
    let following: Int?
    let following_url: String?
    let gists_url: String?
    let gravatar_id: String?
    let hireable: String?
    let html_url: String?
    let id: Int?
    let location: String?
    let login: String?
    let name: String?
    let node_id: String?
    let organizations_url: String?
    let public_gists: Int?
    let public_repos: Int?
    let received_events_url: String?
    let repos_url: String?
    let site_admin: Bool?
    let starred_url: String?
    let subscriptions_url: String?
    let twitter_username: String?
    let type: String?
    let updated_at: String?
    let url: String?
}

//
//  User.swift
//  TestAppBGSoft
//
//  Created by Алексей Касьяник on 18.05.22.
//

import Foundation
import SwiftUI

struct Users: Codable {
    
    private static let defaultsKey = "Users.defaultsKey"
    
    private (set) var  allUsers: [User] {
        didSet {
            saveChanges()
        }
    }
    
    var json: Data? {
        return try? JSONEncoder().encode(self)
    }
    
    init?(from data: Data) {
        var users = [User]()
        
        guard let dict = try? JSONSerialization.jsonObject(with: data) as? [String : Any] else { return nil }
        
        for key in dict.keys {
            guard let names = dict[key] as? [String : Any],
                  let photoUrl = names[Keys.photoUrl.rawValue] as? String,
                  let userName = names[Keys.userName.rawValue]as? String,
                  let userUrl = (names[Keys.userUrl.rawValue] as? String),
                  let colors = names[Keys.colors.rawValue] as? [String]
            else {return nil}
            
            users.append(User(
                id: key,
                imageUrl: "http://dev.bgsoft.biz/task/" + key + ".jpg",
                photoLinkUrl: photoUrl,
                userName: userName,
                userUrl: userUrl,
                colors: colors
            ))
            
        }
        
        users.sort(by: {$0.userName > $1.userName})
        self.allUsers = users
        saveChanges()
    }
    
    init?() {
        let defaultsData = UserDefaults.standard.data(forKey: Users.defaultsKey)
        if defaultsData != nil, let users = try? JSONDecoder().decode(Users.self, from: defaultsData!){
            self = users
        } else {
            return nil
        }
    }
    
    mutating func deleteUser(_ user: User) {
        allUsers.removeAll(where: {$0.id == user.id})
    }
    
    mutating func move(fromOffsets:IndexSet,toOffset: Int) {
        allUsers.move(fromOffsets: fromOffsets, toOffset: toOffset)
    }
    
    private func saveChanges() {
        UserDefaults.standard.set(json, forKey: Users.defaultsKey)
    }
    
    private enum Keys: String {
        case photoUrl = "photo_url"
        case userName = "user_name"
        case userUrl  = "user_url"
        case colors   = "colors"
    }
}


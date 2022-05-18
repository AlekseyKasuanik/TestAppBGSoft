//
//  User.swift
//  TestAppBGSoft
//
//  Created by Алексей Касьяник on 18.05.22.
//

import Foundation

struct Users {
let allUsers: [User]
    
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
                imageUrl: "http://dev.bgsoft.biz/task/" + key + ".jpg",
                photoUrl: photoUrl,
                userName: userName,
                userUrl: userUrl,
                colors: colors
            ))
            
        }
        
        users.sort(by: {$0.userName > $1.userName})
        self.allUsers = users
    }
    
    enum Keys: String {
        case photoUrl = "photo_url"
        case userName = "user_name"
        case userUrl  = "user_url"
        case colors   = "colors"
    }
}


struct User: Identifiable {
    var id = UUID()
    let imageUrl: String
    let photoUrl: String
    let userName: String
    let userUrl: String
    let colors: [String]
}

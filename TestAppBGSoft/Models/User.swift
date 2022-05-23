//
//  User.swift
//  TestAppBGSoft
//
//  Created by Алексей Касьяник on 23.05.22.
//

import SwiftUI

struct User: Identifiable, Equatable, Codable, Hashable {
    
    var id: String
    let imageUrl: String
    let photoLinkUrl: String
    let userName: String
    let userUrl: String
    let colors: [String]
    
    func openPhotoUrl() {
        guard let url = URL(string: photoLinkUrl) else {return}
        UIApplication.shared.open(url)
    }
    
    func openUserUrl() {
        guard let url = URL(string: userUrl) else {return}
        UIApplication.shared.open(url)
    }
}

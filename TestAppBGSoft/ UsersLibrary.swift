//
//  UsersLibrary.swift
//  TestAppBGSoft
//
//  Created by Алексей Касьяник on 18.05.22.
//

import Foundation
import SwiftUI

class  UsersLibrary: ObservableObject {
    
    @Published var users: Users? {
        didSet {
            self.loadAllImages()
        }
    }
    
    @Published var imagesData = [Data?]() 
    
    var allUsers: [User] {
        users?.allUsers ?? []
    }
    
    var names: [String] {
        users?.allUsers.map {$0.userName} ?? []
    }
    
    func getImageDataForUserWithID(_ id: UUID) -> Data? {
       let idArray = users?.allUsers.map {$0.id} ?? []
        let index = idArray.firstIndex(where: {$0 == id}) ?? 0
        print("imageDAta", "NIL")
        guard imagesData.count > index else { return nil }
        print("imageDAta",imagesData[index])
        return imagesData[index]
    }
    
    
   
    init() {
        let url = URL(string: "https://dev.bgsoft.biz/task/credits.json")!
        DataManager.getDataFromURL(url) {data in
            if let data = data, let users = Users(from: data) {
                print(data)
                DispatchQueue.main.async {
                    self.users = users
                    self.imagesData = Array(repeating: nil, count: users.allUsers.count)
                }
                
        }
    }
    
}
    
    private func loadAllImages() {
        let photoUrls = users?.allUsers.map {$0.imageUrl} ?? []
        
        for (n, photoUrl) in photoUrls.enumerated() {
            guard let url = URL(string: photoUrl) else { continue }
            DataManager.getDataFromURL(url) {data in
                if let data = data {
                    DispatchQueue.main.async {
                        self.imagesData[n] = data
                    }
                }
            }
        }
    }
}

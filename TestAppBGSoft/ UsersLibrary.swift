//
//  UsersLibrary.swift
//  TestAppBGSoft
//
//  Created by Алексей Касьяник on 18.05.22.
//

import Foundation
import SwiftUI

class  UsersLibrary: ObservableObject {
    
    @Published var screenUsers: [User?] = [nil,nil,nil]
    
    @Published var preloadedImagesData = [String : UIImage]()
    
    @Published var needAutoscroll = false
    
    @Published private var users: Users? {
        didSet {
            changeScreenUsers()
        }
    }
    
    private var timer: Timer!
    
    private var lastUserActivityTime: Double = CFAbsoluteTimeGetCurrent()
    
    private var screenUserIndex = 0
    
    var allUsers: [User] {
        users?.allUsers ?? []
    }
    
    init(with url: URL) {
        if let users = Users() {
            setUsers(users)
        } else {
            NetworkManager.getDataFromURL(url) {data in
                if let data = data, let users = Users(from: data) {
                    DispatchQueue.main.async {
                        self.setUsers(users)
                    }
                }
            }
        }
    }
    
    func move(fromOffsets: IndexSet, toOffset: Int) {
        self.users?.move(fromOffsets: fromOffsets, toOffset: toOffset)
        nextUsers()
    }
    
    func deleteUser(_ user: User) {
        users?.deleteUser(user)
    }
    
    
    func getImageForUserWithID(_ id: String) -> UIImage? {
        preloadedImagesData[id]
    }
    
    func getIndexForUserWithID(_ id: String) -> Int {
        allUsers.firstIndex(where: {$0.id == id}) ?? 0
    }
    
    func nextUsers() {
        screenUserIndex = getNextIndexFor(screenUserIndex)
        changeScreenUsers()
    }
    
    func previousUsers() {
        screenUserIndex = getPreviousIndexFor(screenUserIndex)
        changeScreenUsers()
    }
    
    func activityReport() {
        if needAutoscroll {
        needAutoscroll = false
        }
        lastUserActivityTime = CFAbsoluteTimeGetCurrent()
    }
    
    private func setUsers(_ users: Users) {
        self.users = users
        changeScreenUsers()
        setupTimer()
        lastUserActivityTime = CFAbsoluteTimeGetCurrent()
        preloadAllImages()
    }
    
    private func setupTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            self.checkUserActivity()
        }
        timer.tolerance = 0.1
    }
    
    private func checkUserActivity() {
        guard screenUsers != [nil,nil,nil] else { return }
        if CFAbsoluteTimeGetCurrent() - lastUserActivityTime > 5 {
            needAutoscroll = true
        }
    }
    
    private func changeScreenUsers() {
        self.screenUsers = [
            allUsers[getPreviousIndexFor(screenUserIndex)],
            allUsers[screenUserIndex],
            allUsers[getNextIndexFor(screenUserIndex)],
        ]
    }
    
    private func getNextIndexFor(_ index: Int) -> Int {
        index == allUsers.count - 1 ? 0 : index + 1
    }
    
    private func getPreviousIndexFor(_ index: Int) -> Int {
       index == 0 ? allUsers.count - 1 : index - 1
    }
    
    private func preloadAllImages() {
        var preloadImagesOrder = self.allUsers
        preloadImagesOrder.orderedShuffle()
        
        func autoLoadImages() {
            guard let first = preloadImagesOrder.first else {return}
            print("LoadNEXTImage")
            loadNextImage(user: first) { success in
                if success {
                    preloadImagesOrder.removeFirst()
                    autoLoadImages()
                } else {
                    print("LoadNEXTImage")
                    autoLoadImages()
                }
            }
        }
        
        autoLoadImages()
        

    }

    private func loadNextImage(user: User,_ completionHandler: (@escaping (Bool) -> ())) {
        guard let url = URL(string: user.imageUrl) else { fatalError("incorrect URL") }
        ImagesManager.getImage(url: url, id: user.id) { image in
            if let imageUI = image {
                DispatchQueue.main.async {
                self.preloadedImagesData[user.id] = imageUI
                }
                print("TRUE", user.id)
                completionHandler(true)
                
            } else {
                print("FALSE")
                completionHandler(false)
                
            }
        }
    }
        
}


    



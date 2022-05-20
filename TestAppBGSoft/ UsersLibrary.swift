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
    
    @Published var preloadedImagesData = [UUID : UIImage]()
    
    @Published var needAutoscroll = false
    
    private var timer: Timer!
    
    private var lastUserActivityTime: Double = CFAbsoluteTimeGetCurrent()
    
    private var screenUserIndex = 0
    
    private var users: Users?
    
    private var allUsers: [User] {
        users?.allUsers ?? []
    }
    
    
    init(with url: URL) {
        
        DataManager.getDataFromURL(url) {data in
            if let data = data, let users = Users(from: data) {
                DispatchQueue.main.async {
                    self.users = users
                    self.changeScreenUsers()
                    self.setupTimer()
                    self.lastUserActivityTime = CFAbsoluteTimeGetCurrent()
                }
            }
        }
    }
    
    
    func getImageForUserWithID(_ id: UUID) -> UIImage? {
        preloadedImagesData[id]
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
        self.preloadAndScaleScreenImages()
    }
    
    private func getNextIndexFor(_ index: Int) -> Int {
        index == allUsers.count - 1 ? 0 : index + 1
    }
    
    private func getPreviousIndexFor(_ index: Int) -> Int {
       index == 0 ? allUsers.count - 1 : index - 1
    }
    
    private func preloadAndScaleScreenImages() {
        
        let users = [
            allUsers[screenUserIndex],
            allUsers[getNextIndexFor(screenUserIndex)],
            allUsers[getPreviousIndexFor(screenUserIndex)],
            allUsers[getNextIndexFor(getNextIndexFor(screenUserIndex))],
            allUsers[getPreviousIndexFor(getPreviousIndexFor(screenUserIndex))]
        ]
        
        for user in users {
            guard preloadedImagesData[user.id] == nil else { continue }
            guard let url = URL(string: user.imageUrl) else { continue }
            DataManager.getDataFromURL(url) {data in
                if let data = data {
                    DispatchQueue.main.async {
                        self.preloadedImagesData[user.id] = self.getScaleImage(data)
                        }
                        
                    
                } else {
                    print("ERROR")
                }
            }
        }
    }
    
    private func getScaleImage(_ data: Data) -> UIImage? {
        var image = UIImage(data: data)
        if image == nil {
            image = UIImage(named: "defaultPhoto")
        }
        let imageScale = min(UIScreen.main.bounds.width / image!.size.width ,
                             UIScreen.main.bounds.height / image!.size.height )
        let screenScale = UIScreen.main.scale
        return image!.resizeWithScale(screenScale * imageScale)
        
    }
}


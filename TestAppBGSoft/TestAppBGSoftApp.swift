//
//  TestAppBGSoftApp.swift
//  TestAppBGSoft
//
//  Created by Алексей Касьяник on 18.05.22.
//

import SwiftUI

@main
struct TestAppBGSoftApp: App {
    var body: some Scene {
        WindowGroup {
            UsersLibraryView().environmentObject(UsersLibrary(with: URL(string: "http://dev.bgsoft.biz/task/credits.json")!))
            //EndlessScrollView()
        }
    }
}

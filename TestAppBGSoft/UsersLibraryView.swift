//
//  ContentView.swift
//  TestAppBGSoft
//
//  Created by Алексей Касьяник on 18.05.22.
//

import SwiftUI

struct  UsersLibraryView: View {
    
    @EnvironmentObject var library: UsersLibrary
    
    var body: some View {
        GeometryReader {geometry in
            EndlessScrollView()
                .frame(width: geometry.size.width, height: geometry.size.height)
        }
        
    }
    

}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        UsersLibraryView().environmentObject(UsersLibrary(with: URL(string: "http://dev.bgsoft.biz/task/credits.json")!))
    }
}

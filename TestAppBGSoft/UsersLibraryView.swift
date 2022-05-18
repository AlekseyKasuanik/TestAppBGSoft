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
        ScrollView(.horizontal) {
            LazyHGrid(rows: gridItems, alignment: .center) {
                ForEach(library.allUsers) { user in
                    PersonCardView(user: user)
                }
                .frame(width: geometry.size.width, height: geometry.size.height)
            }
        }
        }
        
    }
    
    private var gridItems: [GridItem] {
        Array(repeating: .init(spacing: 10, alignment: .bottom), count: 1)
    }
    
    
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        UsersLibraryView().environmentObject(UsersLibrary())
    }
}

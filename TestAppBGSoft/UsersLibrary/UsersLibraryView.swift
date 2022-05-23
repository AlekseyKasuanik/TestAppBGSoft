//
//  ContentView.swift
//  TestAppBGSoft
//
//  Created by Алексей Касьяник on 18.05.22.
//

import SwiftUI

struct  UsersLibraryView: View {
    
    @EnvironmentObject var library: UsersLibrary
    
    @State private var networkError = false
    
    var body: some View {
        GeometryReader {geometry in
            Group {
                if library.twoRowsMode {
                    EditingScrollView()
                } else {
                    EndlessScrollView()
                }
            }
            .frame(width: geometry.size.width, height: geometry.size.height)
        }.gesture(MagnificationGesture()
            .onEnded { value in
                magnificationGestureEnded(value)
            }
        )
        .onReceive(library.$networkError) { value in
            networkError = value
        }
        .alert("Network error. Сheck your internet connection", isPresented: $networkError) {
            Button("OK") { library.loadUsersFromNetwork() }
        }
    }
    
    private func magnificationGestureEnded(_ value: MagnificationGesture.Value) {
        library.activityReport()
        print(value)
        if value > ViewConstants.scaleForMagnification && library.twoRowsMode {
            withAnimation {
                library.twoRowsMode = false
            }
        } else if (value < 1 / ViewConstants.scaleForMagnification) && !library.twoRowsMode {
            withAnimation {
                library.twoRowsMode = true
            }
        }
    }
    
    struct ViewConstants {
        static let scaleForMagnification: CGFloat = 1.5
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        UsersLibraryView().environmentObject(UsersLibrary(with: URL(string: "http://dev.bgsoft.biz/task/credits.json")!))
    }
}

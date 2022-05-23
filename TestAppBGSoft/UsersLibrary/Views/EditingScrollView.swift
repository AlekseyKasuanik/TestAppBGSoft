//
//  EditingScrollView.swift
//  TestAppBGSoft
//
//  Created by Алексей Касьяник on 21.05.22.
//

import SwiftUI

struct EditingScrollView: View {
    
    @EnvironmentObject var library: UsersLibrary
    
    @State var rowsCount =  ViewConstants.rowsCount
    
    var body: some View {
        
        GeometryReader { geometry in
            DragAndDropLazyHGrid(rowsCount: $rowsCount, items: library.allUsers) { item in
                ZStack() {
                    PersonCardView(scale: 1, user: item, alignment: (library.getIndexForUserWithID(item.id) % 2) == 0 ? .bottom : .top)
                        .frame(width: geometry.size.width / 2 * ViewConstants.startImageWidthRatio,
                               height: geometry.size.height / 2 * ViewConstants.startImageWidthRatio)
                        .offset(y: getGridOffset(in: geometry.size, for: item))
                }.frame(width: geometry.size.width / 2, height: geometry.size.height / 2)
                
            } moveAction: { from, to in
                library.move(fromOffsets: from, toOffset: to)
            }
        }
    }
    
    
    private func getGridOffset(in geometry: CGSize, for item: User) -> CGFloat {
        if geometry.width < geometry.height && UIDevice.current.userInterfaceIdiom == .phone {
            return geometry.width / 2 * (1 - ViewConstants.startImageWidthRatio) / 2 * ((library.getIndexForUserWithID(item.id) % 2) == 0 ? 1 : -1)
        } else {
            return 0
        }
    }
    
    struct ViewConstants {
        static let startImageWidthRatio: Double = 0.9
        static let rowsCount: Int = 2
    }
    
    
}



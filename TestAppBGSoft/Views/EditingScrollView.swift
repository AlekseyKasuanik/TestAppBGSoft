//
//  EditingScrollView.swift
//  TestAppBGSoft
//
//  Created by Алексей Касьяник on 21.05.22.
//

import SwiftUI

struct EditingScrollView: View {

    @EnvironmentObject var library: UsersLibrary

    @State var rowsCount = 2

    var body: some View {

        GeometryReader { geometry in
            DragAndDropLazyHGrid(rowsCount: $rowsCount, items: library.allUsers) { item in
                ZStack() {
                    PersonCardView(scale: 1, user: item, alignment: (library.getIndexForUserWithID(item.id) % 2) == 0 ? .bottom : .top)
                        .frame(width: geometry.size.width / 2 * 0.9, height: geometry.size.height / 2 * 0.9)
                        .offset(y: (geometry.size.width / 2 * 0.05) * ((library.getIndexForUserWithID(item.id) % 2) == 0 ? 1 : -1))
                }.frame(width: geometry.size.width / 2, height: geometry.size.height / 2)

            } moveAction: { from, to in
                 library.move(fromOffsets: from, toOffset: to)
            }
        }
    }
}



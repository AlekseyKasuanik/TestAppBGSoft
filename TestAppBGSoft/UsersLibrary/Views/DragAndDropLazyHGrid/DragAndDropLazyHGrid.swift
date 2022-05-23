//
//  DragAndDropLazyHGrid.swift
//  TestAppBGSoft
//
//  Created by Алексей Касьяник on 21.05.22.
//

import SwiftUI
import UniformTypeIdentifiers

struct DragAndDropLazyHGrid<Content: View>: View {
    
    @EnvironmentObject var library: UsersLibrary
    
    let items: [User]
    let content: (User) -> Content
    let moveAction: (IndexSet, Int) -> Void
    
    @State private var hasChangedLocation: Bool = false
    
    
    init(rowsCount: Binding<Int>,
         items: [User],
         @ViewBuilder content: @escaping (User) -> Content,
         moveAction: @escaping (IndexSet, Int) -> Void
    ) {
        self._rowsCount = rowsCount
        self.items = items
        self.content = content
        self.moveAction = moveAction
    }
    
    @State private var draggingItem: User?
    @Binding var rowsCount: Int
    
    @State var screenUsers: [User] = []
    
    var body: some View {
        ScrollView(.horizontal) {
            ScrollViewReader { value in
                LazyHGrid(rows: gridRows, spacing: ViewConstants().gridSpacing){
                    ForEach(items) { item in
                        ZStack {
                            content(item)
                                .onAppear { screenUsers.append(item) }
                                .onDisappear { screenUsers.removeAll(where: {$0.id == item.id})}
                        }
                        .overlay(draggingItem == item && hasChangedLocation ? Color(uiColor: UIColor.systemBackground).opacity(ViewConstants().itemOpacity) : Color.clear)
                        .onDrag {
                            draggingItem = item
                            return NSItemProvider(object: "\(item.id)" as NSString)
                        }
                        .onDrop(
                            of: [UTType.text],
                            delegate: DragRelocateDelegate(
                                item: item,
                                listData: items,
                                current: $draggingItem,
                                hasChangedLocation: $hasChangedLocation
                            ) { from, to in
                                withAnimation {
                                    moveAction(from, to)
                                }
                            })
                    }
                }
                .onAppear {
                    if let user = library.screenUsers[1] {
                        value.scrollTo(user.id)
                    }
                }
                
                .onReceive(library.$twoRowsMode) { isTwoRowsMode in
                    if !isTwoRowsMode && screenUsers.count > 3 {
                        library.setScreenUser(user: screenUsers[2])
                    }
                }
            }
            
        }
        
    }
    
    private var gridRows: [GridItem] {
        Array(repeating: GridItem(spacing: ViewConstants().gridSpacing), count: rowsCount)
    }
    
    struct ViewConstants {
        let gridSpacing: CGFloat = 0
        let itemOpacity: Double = 0.8
    }
    
}


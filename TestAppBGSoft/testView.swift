//
//  testView.swift
//  TestAppBGSoft
//
//  Created by Алексей Касьяник on 20.05.22.
//

import SwiftUI
import UniformTypeIdentifiers

struct DragAndDropLazyHGrid<Content: View, Item: Identifiable & Equatable>: View {
    let items: [Item]
    let content: (Item) -> Content
    let moveAction: (IndexSet, Int) -> Void
    let rowsCount: Int
    
    @State private var hasChangedLocation: Bool = false

    init(
        rowsCount: Int,
        items: [Item],
        @ViewBuilder content: @escaping (Item) -> Content,
        moveAction: @escaping (IndexSet, Int) -> Void
    ) {
        self.rowsCount = rowsCount
        self.items = items
        self.content = content
        self.moveAction = moveAction
    }
    
    @State private var draggingItem: Item?
    
    var body: some View {
        ScrollView(.horizontal,showsIndicators: false) {
            LazyHGrid(rows: gridRows, spacing: ViewConstants().gridSpacing){
                
                ForEach(items) { item in
                    content(item)
                        .overlay(draggingItem == item && hasChangedLocation ? Color.white.opacity(ViewConstants().itemOpacity) : Color.clear)
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
                            }
                        )
                }
            }
        }
        
    }
    
    private var gridRows: [GridItem] {
        Array(repeating: GridItem(spacing: ViewConstants().gridSpacing), count: rowsCount)
    }
    
    private struct ViewConstants {
        let gridSpacing: CGFloat = 0
        let itemOpacity: Double = 0.8
    }
    

}

struct DragRelocateDelegate<Item: Equatable>: DropDelegate {
    let item: Item
    var listData: [Item]
    @Binding var current: Item?
    @Binding var hasChangedLocation: Bool

    var moveAction: (IndexSet, Int) -> Void

    func dropEntered(info: DropInfo) {
        guard item != current, let current = current else { return }
        guard let fromIndex = listData.firstIndex(of: current), let toIndex = listData.firstIndex(of: item) else { return }
        
        hasChangedLocation = true

        if listData[toIndex] != current {
            moveAction(IndexSet(integer: fromIndex), toIndex > fromIndex ? toIndex + 1 : toIndex)
        }
    }
    
    func dropUpdated(info: DropInfo) -> DropProposal? {
        DropProposal(operation: .move)
    }
    
    func performDrop(info: DropInfo) -> Bool {
        hasChangedLocation = false
        current = nil
        return true
    }
    
}


struct DemoDragRelocateView: View {
    
    @State var items: [BaseItem] = [BaseItem(1),BaseItem(2),BaseItem(3),BaseItem(4),BaseItem(5),BaseItem(6),BaseItem(7),BaseItem(8),BaseItem(9)]
    
    var body: some View  {
        DragAndDropLazyHGrid(rowsCount: 2, items: items) { item in
            ZStack {
            Rectangle()
                
                .foregroundColor(Color(item.color))
            Text(item.text)
            }.frame(width: 100, height: 100)
                .clipShape(RoundedRectangle(cornerRadius: 25, style: .continuous))
                
        } moveAction: { from, to in
            items.move(fromOffsets: from, toOffset: to)
        }
    }
}

struct BaseItem: Identifiable, Equatable {
    let id = UUID()
    let color = UIColor(red: CGFloat.random(in: 0...1), green: CGFloat.random(in: 0...1), blue: CGFloat.random(in: 0...1), alpha: 1)
    let text: String
    
    init(_ value: Int) {
        self.text = value.description
    }
    
}

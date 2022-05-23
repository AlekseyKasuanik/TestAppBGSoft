//
//  DragRelocateDelegate.swift
//  TestAppBGSoft
//
//  Created by Алексей Касьяник on 23.05.22.
//

import SwiftUI
import UniformTypeIdentifiers

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

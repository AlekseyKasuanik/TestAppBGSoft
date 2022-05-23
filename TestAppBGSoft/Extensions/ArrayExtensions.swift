//
//  ArrayExtensions.swift
//  TestAppBGSoft
//
//  Created by Алексей Касьяник on 19.05.22.
//

import Foundation

extension Array {
    
    mutating func rearrange(from: Int, to: Int) {
        insert(remove(at: from), at: to)
    }
    
    
    mutating func orderedShuffle() {
        
        let count = self.count
        
        let array1 = Array(self[0..<Int(count / 2)])
        var array2 = Array(self[Int(count / 2)..<self.count])
        array2.reverse()
        
        self.removeAll()
        
        for i in 0...Int(count / 2) {
            i < array1.count ? self.append(array1[i]) : nil
            i < array2.count ? self.append(array2[i]) : nil
        }
    }
    
}

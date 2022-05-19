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
}

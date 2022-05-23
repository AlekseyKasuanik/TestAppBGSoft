//
//  HexColor.swift
//  TestAppBGSoft
//
//  Created by Алексей Касьяник on 23.05.22.
//

import UIKit

struct HexColor {
    
    var red: CGFloat = 0
    var green: CGFloat = 0
    var blue: CGFloat = 0
    var alpha: CGFloat = 255
    
    init?(_ hexColor: String) {
        
        var hexNormalized = hexColor.trimmingCharacters(in: .whitespacesAndNewlines)
        hexNormalized = hexNormalized.replacingOccurrences(of: "#", with: "")
        
        // Helpers
        var rgb: UInt64 = 0
        let length = hexNormalized.count
        // Create Scanner
        Scanner(string: hexNormalized).scanHexInt64(&rgb)
        
        if length == 6 {
            red = CGFloat((rgb & 0xFF0000) >> 16)
            green = CGFloat((rgb & 0x00FF00) >> 8)
            blue = CGFloat(rgb & 0x0000FF)
            
        } else if length == 8 {
            red = CGFloat((rgb & 0xFF000000) >> 24)
            green = CGFloat((rgb & 0x00FF0000) >> 16)
            blue = CGFloat((rgb & 0x0000FF00) >> 8)
            alpha = CGFloat(rgb & 0x000000FF)
            
        }
    }
}

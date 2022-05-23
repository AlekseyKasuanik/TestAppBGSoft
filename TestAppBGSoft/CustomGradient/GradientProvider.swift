//
//  GradientProvider.swift
//  TestAppBGSoft
//
//  Created by Алексей Касьяник on 23.05.22.
//

import UIKit

struct GradientProvider {
    
    static func makeCustomGradientImage(colors: [HexColor], size: CGSize = CGSize(width: 500, height: 500) ) -> CGImage {
        
        let height = Int(size.height)
        let width = Int(size.width)
        
        let context = CGContext(
            data: nil,
            width: width, height: height,
            bitsPerComponent: 8, bytesPerRow: width * 4,
            space: CGColorSpaceCreateDeviceRGB(),
            bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue)!
        
        let rangeScale: CGFloat = 1.0 / CGFloat(colors.count - 1)
        var ranges:[(CGFloat,CGFloat)] = [(0,rangeScale)]
        
        for n in 1..<colors.count - 1 {
            let nextRange = (ranges[n-1].0 + rangeScale,ranges[n-1].1 + rangeScale)
            ranges.append((nextRange))
        }
        
        var xN: CGFloat = 0
        var yN: CGFloat = 0
        
        for i in 0..<width*height  {
            
            xN = (CGFloat(i % height) - CGFloat(width) / 2) / (CGFloat(width) / 2)
            yN = (CGFloat(Int(i / height)) - CGFloat(height) / 2) / (CGFloat(height) / 2)
            
            let fiN = fromXYToFi(xN, yN)
            
            for (j,fiRange) in ranges.enumerated() {
                if fiN >= fiRange.0 && fiN <= fiRange.1 {
                    
                    let scale: CGFloat = (fiN - rangeScale * CGFloat(j)) / rangeScale
                    
                    let deltaR = colors[j + 1].red - colors[j].red
                    let deltaG = colors[j + 1].green - colors[j].green
                    let deltaB = colors[j + 1].blue - colors[j].blue
                    let deltaA = colors[j + 1].alpha - colors[j].alpha
                    
                    let green = UInt8(colors[j].green + deltaG * scale)
                    let alpha = UInt8(colors[j].alpha + deltaA * scale)
                    let red = UInt8(colors[j].red + deltaR * scale)
                    let blue = UInt8(colors[j].blue + deltaB * scale)
                    
                    context.data!.advanced(by: i*4)
                        .copyMemory(from: [red, green, blue, alpha] as [UInt8], byteCount: 4)
                    
                    continue
                }
            }
        }
        
        return context.makeImage()!
    }
    
    private static func fromXYToFi(_ x: CGFloat, _ y: CGFloat) -> CGFloat {
        var fi = atan(y/x)
        if x > 0 && y < 0 {
            fi += CGFloat.pi * 2
        } else if x < 0 {
            fi += CGFloat.pi
        } else if x == 0 && y > 0 {
            fi = CGFloat.pi / 2
        } else if x == 0 && y < 0 {
            fi = CGFloat.pi * 3 / 2
        } else if x == 0 && y == 0 {
            fi = 0
        }
        
        return fi / CGFloat.pi / 2
    }
}

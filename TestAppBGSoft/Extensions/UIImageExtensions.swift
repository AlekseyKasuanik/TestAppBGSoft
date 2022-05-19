//
//  UIImageExtensions.swift
//  TestAppBGSoft
//
//  Created by Алексей Касьяник on 19.05.22.
//

import UIKit

extension UIImage {

    func resizeWithScale(_ scale : CGFloat) -> UIImage? {
        let newHeight = self.size.height * scale
        let newWidth = self.size.width * scale
        
        UIGraphicsBeginImageContext(CGSize(width: newWidth, height: newHeight))
        self.draw(in: CGRect(x: 0, y: 0, width: newWidth, height: newHeight))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return newImage
    }
}

//
//  ImagesManager.swift
//  TestAppBGSoft
//
//  Created by Алексей Касьяник on 21.05.22.
//

import Foundation
import UIKit


struct ImagesManager {
    
    static func getImage(url: URL, id: String, completionHandler: (@escaping (UIImage?) -> ())) {
        if let data = LocalDataManager.getData(name: id), let image = UIImage(data: data) {
            print("ImageFromStorage")
            completionHandler(image)
        } else {
            NetworkManager.getDataFromURL(url) {data in
                    if let data = data, let scaleImage = getScaleImage(data) {
                      LocalDataManager.saveData(name: id, data: scaleImage.jpegData(compressionQuality: 1)!)
                        completionHandler(scaleImage)
                        print("ImageFromInternet")
                    } else {
                        completionHandler(nil)
                    }
            }
        }
        
    }
    
    private static func getScaleImage(_ data: Data) -> UIImage? {
        var image = UIImage(data: data)
        if image == nil {
            image = UIImage(named: "defaultPhoto")
        }
        let imageScale = min(UIScreen.main.bounds.width / image!.size.width ,
                             UIScreen.main.bounds.height / image!.size.height )
        let screenScale = UIScreen.main.scale
        return image!.resizeWithScale(screenScale * imageScale)
        
    }
    
}

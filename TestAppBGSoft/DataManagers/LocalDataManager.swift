//
//  LocalDataManager.swift
//  TestAppBGSoft
//
//  Created by Алексей Касьяник on 21.05.22.
//

import Foundation

struct LocalDataManager {
    
    static func saveData(name: String, data: Data) {
        try? data.write(to: getLocalURL(fileName: name))
    }
    
    static func getData(name: String) -> Data? {
        try? Data(contentsOf: getLocalURL(fileName: name))
    }
    
    private static func getLocalURL(fileName: String) -> URL {
        
       try? FileManager.default.createDirectory(atPath: "/ab/cd/", withIntermediateDirectories: true, attributes: nil)
        
        let documentsDirectoryURL = try! FileManager().url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
        var fileURL = documentsDirectoryURL.appendingPathComponent("Cash")
        
        if !FileManager.default.fileExists(atPath: fileURL.path) {
            print("CREATING")
            try? FileManager.default.createDirectory(atPath: fileURL.path, withIntermediateDirectories: true, attributes: nil)
        }
        
        fileURL.appendPathComponent(fileName)
        
        return fileURL
    }
}

//
//  JsonFetcher.swift
//  TestAppBGSoft
//
//  Created by Алексей Касьяник on 18.05.22.
//

import Foundation

struct DataManager {
    
    static func getDataFromURL(_ url: URL,_ completionHandler: (@escaping (Data?) -> ()))  {
        
        let urlRequest = URLRequest(url: url)
        URLSession.shared.dataTask(with: urlRequest) {data, _, error in
            completionHandler(data)
        }.resume()
        
    }
}

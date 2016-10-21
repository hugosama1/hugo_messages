//
//  HugoSamaApi.swift
//  hugo messages
//
//  Created by hugo on 10/21/16.
//  Copyright © 2016 hugosama. All rights reserved.
//

import Foundation
import CoreData


enum HugosamaError: Error {
    case invalidJSONData
}

struct HugoSamaAPI {
    private static let baseURLString = "http://10.26.180.35:8080"
    
    private static func hugosamaURL(at subfolder: String, parameters: [String:String]?) -> URL {
        var components = URLComponents(string: baseURLString)!
        var queryItems = [URLQueryItem]()
        
        if let additionalParams = parameters {
            for (key, value) in additionalParams {
                let item = URLQueryItem(name: key, value: value)
                queryItems.append(item)
            }
        }
        components.queryItems = queryItems
        return components.url!
    }
    
    public static func messagesURL ( date : Int = 0 ) -> URL {
        return hugosamaURL(at:"/messages", parameters: ["date" : String(date) ])
    }
    
    static func messages(fromJSON data: Data,into context: NSManagedObjectContext) -> MessageResult {
        do {
            let jsonArray = try JSONSerialization.jsonObject(with: data,options: [])
            guard
                let messageArray = jsonArray as? [Message],
                let photos = jsonDictionary["photos"] as? [String:Any],
                let photosArray = photos["photo"] as? [[String:Any]] else {
                    // The JSON structure doesn't match our expectations
                    return .failure(FlickrError.invalidJSONData)
            }
            var finalPhotos = [Photo]()
            for photoJSON in photosArray {
                if let photo = photo(fromJSON: photoJSON, into: context) {
                    finalPhotos.append(photo)
                }
            }
            if finalPhotos.isEmpty && !photosArray.isEmpty {
                // We weren't able to parse any of the photos
                // Maybe the JSON format for photos has changed
                return .failure(FlickrError.invalidJSONData)
            }
            return .success(finalPhotos)
        } catch let error {
            return .failure(error)
        }
    }

    
    
}

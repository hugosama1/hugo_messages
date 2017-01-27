//
//  
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
    private static let baseURLString = "http://hugosama.com:8080"
    
    private static func hugosamaURL(at subfolder: String, parameters: [String:String]?) -> URL {
        var components = URLComponents(string: baseURLString)!
        var queryItems = [URLQueryItem]()
        components.path += subfolder;
        if let additionalParams = parameters {
            for (key, value) in additionalParams {
                let item = URLQueryItem(name: key, value: value)
                queryItems.append(item)
            }
        }
        components.queryItems = queryItems
        return components.url!
    }
    
    public static func messagesURL ( date : Int64 = 0 ) -> URL {
        return hugosamaURL(at:"/messages", parameters: ["date" : String(date) ])
    }
    
    static func messages(fromJSON data: Data,into context: NSManagedObjectContext) -> MessageResult {
        do {
            let jsonArray = try JSONSerialization.jsonObject(with: data, options: [JSONSerialization.ReadingOptions.allowFragments])
            var finalMessages = [Message]()
            let messageArray = jsonArray as? [[String:Any]]
            for messageJson in messageArray! {
                let message = NSEntityDescription.insertNewObject(forEntityName: "Message", into: context) as! Message
                message.id = messageJson["_id"] as! Int16
                message.date = messageJson["date"] as! Int64
                message.message = messageJson["message"] as! String?
                finalMessages.append(message)
            }
            return .success(finalMessages)
        } catch let error {
            return .failure(error)
        }
    }
    
    static func newMessage( fromJSON data: Data) -> MessageResult  {
        do {
            let jsonObject = try JSONSerialization.jsonObject(with: data, options: [JSONSerialization.ReadingOptions.allowFragments])
            if let messageObject = jsonObject as? [String:Bool] {
                return .successNew(messageObject)
            }
            return .failure(HugosamaError.invalidJSONData)
        } catch let error {
            return .failure(error)
        }

    }

    
    
}

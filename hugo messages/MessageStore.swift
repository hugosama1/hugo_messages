//
//  MessageStore.swift
//  hugo messages
//
//  Created by hugo on 10/21/16.
//  Copyright © 2016 hugosama. All rights reserved.
//

import UIKit
import CoreData


enum MessageResult {
    case success([Message])
    case failure(Error)
}

class MessageStore {
    
    private let session: URLSession = {
        let config = URLSessionConfiguration.default
        return URLSession(configuration: config)
    }()
    
    public let persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "HugosamaMessages")
        container.loadPersistentStores { (description, error) in
            if let error = error {
                print("Error setting up Core Data (\(error)).")
            }
        }
        return container
    }()
    
    func fetchMessages(completion: @escaping (MessageResult) -> Void) {
        let url = HugoSamaAPI.messagesURL()
        let request = URLRequest(url: url)
        let task = session.dataTask(with: request) {
            (data, response, error) -> Void in
            
            var result = self.processMessagesRequest(data: data, error: error)
            if case .success(_) = result {
                do {
                    try self.persistentContainer.viewContext.save()
                } catch let error {
                    result = .failure(error)
                }
            }
            OperationQueue.main.addOperation {
                completion(result)
            }
        }
        print(url)
        task.resume()
    }
    
    private func processMessagesRequest(data: Data?, error: Error?) -> MessageResult {
        guard let jsonData = data else {
            return .failure(error!)
        }
        return HugoSamaAPI.photos(fromJSON: jsonData,into: self.persistentContainer.viewContext)
    }
    
    
}

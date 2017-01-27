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
    case successNew([String:Bool])
}


class MessageStore {
    
    var allMessages =  [Message]()
    
    private let session: URLSession = {
        let config = URLSessionConfiguration.default
        return URLSession(configuration: config)
    }()
    
    public let persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "HugoMessages")
        container.loadPersistentStores { (description, error) in
            if let error = error {
                print("Error setting up Core Data (\(error)).")
            }
        }
        return container
    }()
    
    func fetchMessages(completion: @escaping (MessageResult) -> Void) {
        let url = HugoSamaAPI.messagesURL(date: getLastDate())
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
        return HugoSamaAPI.messages(fromJSON: jsonData,into: self.persistentContainer.viewContext)
    }
    
    func getLastDate() -> Int64 {
        var lastDate:Int64 = 0
        let fetchRequest: NSFetchRequest<Message> = Message.fetchRequest()
        let sortByDate = NSSortDescriptor(key: #keyPath(Message.date), ascending: false)
        fetchRequest.sortDescriptors = [sortByDate]
        fetchRequest.fetchLimit = 1
        let viewContext = persistentContainer.viewContext
        viewContext.performAndWait {
            do {
                let messageArray = try viewContext.fetch(fetchRequest)
                if messageArray.count > 0 {
                    lastDate = messageArray[0].date
                }
            } catch {
                
            }
        }
        return lastDate
    }
    
    func fetchAllMessages(completion: @escaping (MessageResult) -> Void) {
        let fetchRequest: NSFetchRequest<Message> = Message.fetchRequest()
        let sortByDate = NSSortDescriptor(key: #keyPath(Message.date), ascending: true)
        fetchRequest.sortDescriptors = [sortByDate]
        let viewContext = persistentContainer.viewContext
        viewContext.perform {
            do {
                let allMessages = try viewContext.fetch(fetchRequest)
                completion(.success(allMessages))
            } catch {
                completion(.failure(error))
            }
        }
    }
    
    func saveMessage( message:String,completion: @escaping (MessageResult) -> Void ) {
        let url = HugoSamaAPI.messagesURL()
        var request = URLRequest(url: url)
        let json = [ "message": message ]
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: json, options: .prettyPrinted)
            request.httpMethod = "POST"
            request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
            request.httpBody = jsonData
            let task = session.dataTask(with: request) {
                (data, response, error) -> Void in
                let result = self.proccessNewMessage(data: data, error: error)
                completion(result)
            }
            task.resume()
        }catch {
            print("ERROR SAVING MESSAGE")
        }
    }
    
    
    private func proccessNewMessage(data: Data?, error: Error?) -> MessageResult {
        guard let jsonData = data else {
            return .failure(error!)
        }
        return HugoSamaAPI.newMessage(fromJSON: jsonData)
    }
    
    
}

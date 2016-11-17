//
//  Message+CoreDataProperties.swift
//  hugo messages
//
//  Created by hugo on 11/16/16.
//  Copyright © 2016 hugosama. All rights reserved.
//

import Foundation
import CoreData


extension Message {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Message> {
        return NSFetchRequest<Message>(entityName: "Message");
    }

    @NSManaged public var date: Int64
    @NSManaged public var id: Int16
    @NSManaged public var message: String?

}

//
//  MyList+CoreDataProperties.swift
//  MyReminder
//
//  Created by 한상민 on 2023/02/07.
//

import Foundation
import CoreData
import UIKit

extension MyList {
    
    @nonobjc public class func fetchRequest() -> NSFetchRequest<MyList> {
        return NSFetchRequest<MyList>(entityName: "MyList")
    }
    
    @NSManaged public var name: String
    @NSManaged public var color: UIColor
    @NSManaged public var reminders: NSSet?
}

extension MyList: Identifiable {
    
}

extension MyList {
    @objc(addRemindersObject:)
    @NSManaged public func addToReminders(_ value: Reminder)

    @objc(removeRemindersObject:)
    @NSManaged public func removeFromeReminders(_ value: Reminder)

    @objc(addReminders:)
    @NSManaged public func addToReminders(_ value: NSSet)

    @objc(removeReminders:)
    @NSManaged public func removeFromReminders(_ value: NSSet)
}


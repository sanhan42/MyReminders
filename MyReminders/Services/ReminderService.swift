//
//  ReminderService.swift
//  MyReminders
//
//  Created by 한상민 on 2023/02/12.
//

import Foundation
import CoreData
import UIKit

class ReminderService {
    
    static var viewContext: NSManagedObjectContext {
        CoreDataProvider.shared.persistentContainer.viewContext
    }
    
    static func save() throws {
        try viewContext.save()
    }
    
    static func saveMyList(_ name: String, _ color: UIColor) throws {
        let myList = MyList(context: viewContext)
        myList.name = name
        myList.color = color
        try save()
    }
    
    @discardableResult
    static func updateReminder(reminder: Reminder, editConfig: ReminderEditConfig) throws -> Bool {
        let reminderToUpdate = reminder
        reminderToUpdate.isCompleted = editConfig.isCompleted
        reminderToUpdate.title = editConfig.title
        reminderToUpdate.notes = editConfig.notes
        reminderToUpdate.reminderDate = editConfig.hasDate ? editConfig.reminderDate : nil
        reminderToUpdate.reminderTime = editConfig.hasTime ? editConfig.reminderTime : nil
        
        try save()
        return true
    }
    
    static func deleteReminder(_ reminder: Reminder) throws {
        viewContext.delete(reminder)
        try save()
    }
    
    static func getRemindersBySearchTerm(_ searchTerm: String) -> NSFetchRequest<Reminder> {
        let request = Reminder.fetchRequest()
        request.sortDescriptors = []
        request.predicate = NSPredicate(format: "title CONTAINS[cd] %@ || notes CONTAINS[cd] %@", searchTerm, searchTerm)
        return request
    }
    
    static func saveReminderToMyList(myList: MyList, reminderTitle: String) throws {
        let reminder = Reminder(context: viewContext)
        reminder.title = reminderTitle
        myList.addToReminders(reminder)
        try save()
    }
    
    static func getRemindersByList(myList: MyList) -> NSFetchRequest<Reminder> {
        let request = Reminder.fetchRequest()
        request.sortDescriptors = []
        request.predicate = NSPredicate(format: "list = %@ AND isCompleted = false", myList)
        return request
    }
    
    static func remindersByStatType(statType: ReminderStatType) -> NSFetchRequest<Reminder> {
        let request = Reminder.fetchRequest()
        request.sortDescriptors = []
        
        switch statType {
        case .today:
            let today = Date()
            let tomorrow = Calendar.current.date(byAdding: .day, value: 1, to: today)
//            request.predicate = NSPredicate(format: "((reminderDate != nil) AND (reminderDate BETWEEN {%@, %@})) OR ((reminderTime != nil) AND (reminderTime BETWEEN {%@, %@}))", today as NSDate, tomorrow! as NSDate)
            request.predicate = NSPredicate(format: "(reminderDate != nil && reminderDate BETWEEN {%@, %@}) || (reminderDate == nil && reminderTime != nil)", today as NSDate, tomorrow! as NSDate)
        case .all:
            request.predicate = NSPredicate(format: "isCompleted = false")
        case .scheduled:
            request.predicate = NSPredicate(format: "(reminderDate != nil || reminderTime != nil) && isCompleted = false")
        case .completed:
            request.predicate = NSPredicate(format: "isCompleted = true")
        }
        return request
    }
}

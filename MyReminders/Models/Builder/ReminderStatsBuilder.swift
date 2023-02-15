//
//  ReminderStatsBuilder.swift
//  MyReminders
//
//  Created by 한상민 on 2023/02/15.
//

import Foundation
import SwiftUI

enum ReminderStatType {
    case today
    case scheduled
    case all
    case completed
}

struct ReminderStatsValues {
    
    var todaysCount: Int = 0
    var scheduledCount: Int = 0
    var allCount: Int = 0
    var completedCount: Int = 0
}

struct ReminderStatsBuilder {
    private func calculateTodaysCount(reminders: [Reminder]) -> Int {
        return reminders.reduce(0) { partialResult, reminder in
            var isToday: Bool {
                if reminder.reminderDate != nil {
                    return reminder.reminderDate?.isToday ?? false
                } else if reminder.reminderTime != nil {
                    return true
                }
                return false
            }
            return isToday ? partialResult + 1 : partialResult
        }
    }
    
    private func calculateScheduledCount(reminders: [Reminder]) -> Int {
        return reminders.reduce(0) { partialResult, reminder in
            return ((reminder.reminderDate != nil || reminder.reminderTime != nil) && !reminder.isCompleted) ? partialResult + 1 : partialResult
        }
    }
    
    private func calculateAllCount(reminders: [Reminder]) -> Int {
        return reminders.reduce(0) { partialResult, reminder in
            return !reminder.isCompleted ? partialResult + 1 : partialResult
        }
    }
    
    private func calculateCompletedCount(reminders: [Reminder]) -> Int {
        return reminders.reduce(0) { partialResult, reminder in
            return reminder.isCompleted ? partialResult + 1 : partialResult
        }
    }
    
    func build(myListResults: FetchedResults<MyList>) -> ReminderStatsValues {
        let remindersArray = myListResults.map { list in
            list.remindersArray
        }.reduce([], +)
        
        let todaysCount = calculateTodaysCount(reminders: remindersArray)
        let scheduledCount = calculateScheduledCount(reminders: remindersArray)
        let allCount = calculateAllCount(reminders: remindersArray)
        let completedCount = calculateCompletedCount(reminders: remindersArray)
        
        return ReminderStatsValues(todaysCount: todaysCount, scheduledCount: scheduledCount, allCount: allCount, completedCount: completedCount)
    }
}

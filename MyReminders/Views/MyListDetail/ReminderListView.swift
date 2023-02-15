//
//  ReminderListView.swift
//  MyReminders
//
//  Created by 한상민 on 2023/02/13.
//

import SwiftUI

struct ReminderListView: View {
    
    let reminders: FetchedResults<Reminder>
    @State private var selectedReminder: Reminder?
    @State private var showReminderDetail: Bool = false
    
    private func reminderCheckedChanged(reminder: Reminder, isCompleted: Bool) {
        var editConfig = ReminderEditConfig(reminder: reminder)
        editConfig.isCompleted = isCompleted
        
        do {
            try ReminderService.updateReminder(reminder: reminder, editConfig: editConfig)
        } catch {
            print(error)
        }
    }
    
    private func isReminderSelected(_ reminder: Reminder) -> Bool {
        return selectedReminder?.objectID == reminder.objectID
    }
    
    var body: some View {
        VStack {
            List(reminders) { reminder in
                ReminderCellView(reminder: reminder, isSelected: isReminderSelected(reminder)) { event in
                    switch event {
                    case .onSelect(let reminder):
                        selectedReminder = reminder
                    case .onCheckedChange(let reminder, let isCompleted):
                        reminderCheckedChanged(reminder: reminder, isCompleted: isCompleted)
                    case .onInfo:
                        showReminderDetail = true
                    }
                }
            }.sheet(isPresented: $showReminderDetail) {
                ReminderDetailView(reminder: Binding($selectedReminder)!)
            }
        }
    }
}

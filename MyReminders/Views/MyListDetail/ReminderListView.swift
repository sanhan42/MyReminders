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
    
    private func deleteReminder(_ indexSet: IndexSet) {
        indexSet.forEach { index in
            let reminder = reminders[index]
            do {
                try ReminderService.deleteReminder(reminder)
            } catch {
                print(error)
            }
        }
    }
    
    var body: some View {
        VStack {
            List {
                ForEach(reminders) { reminder in
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
                } // :FOREACH
                .onDelete(perform: deleteReminder)
            } // :LIST
        }.sheet(isPresented: $showReminderDetail) {
            ReminderDetailView(reminder: Binding($selectedReminder)!)
            
        }
    }
}

struct ReminderListView_Previews: PreviewProvider {
    
    struct ReminderListViewContainer: View {
        
        @FetchRequest(sortDescriptors: [])
        private var reminderResults: FetchedResults<Reminder>
        
        var body: some View {
            ReminderListView(reminders: reminderResults)
        }
    }
    
    static var previews: some View {
        ReminderListViewContainer()
            .environment(\.managedObjectContext, CoreDataProvider.shared.persistentContainer.viewContext)
    }
}

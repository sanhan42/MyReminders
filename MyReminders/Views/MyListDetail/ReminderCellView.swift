//
//  ReminderCellView.swift
//  MyReminders
//
//  Created by 한상민 on 2023/02/13.
//

import SwiftUI

enum ReminderCellEvents {
    case onSelect(Reminder)
    case onCheckedChange(Reminder, Bool)
    case onInfo
}

struct ReminderCellView: View {
    
    let reminder: Reminder
    private let delay = Delay()
    let isSelected: Bool
    
    @State private var checked = false
    let onEvnet: (ReminderCellEvents) -> Void
    
    private func formatDate(_ date: Date) -> String {
        if date.isToday {
            return "오늘"
        } else if date.isTomorrow {
            return "내일"
        } else {
            return date.formatted(date: .numeric, time: .omitted)
        }
    }
    
    var body: some View {
        HStack {
            Image(systemName: checked ? "circle.inset.filled" : "circle")
                .foregroundColor(checked ? .blue : .gray)
                .font(.title2)
                .opacity(checked ? 1 : 0.4)
                .onTapGesture {
                    checked.toggle()
                    
                    delay.cancel()
                    delay.performWork {
                        onEvnet(.onCheckedChange(reminder, checked))
                    }
                    
                }
            
            VStack(alignment: .leading) {
                Text(reminder.title ?? "")
                if let notes = reminder.notes, !notes.isEmpty {
                    Text(notes)
                        .opacity(0.4)
                        .font(.caption)
                }
                
                HStack {
                    if let reminderDate = reminder.reminderDate {
                        Text(formatDate(reminderDate))
                    }
                    
                    if let reminderTime = reminder.reminderTime {
                        Text(reminderTime.formatted(date: .omitted, time: .shortened))
                    }
                } // :HSTACK
                .frame(maxWidth: .infinity, alignment: .leading)
                .font(.caption)
                .opacity(0.4)
            } // :VSTACK
            
            Spacer()
            Image(systemName: "info.circle.fill")
                .opacity(isSelected ? 1.0 : 0.0)
                .onTapGesture {
                    onEvnet(.onInfo)
                }
        } // :HSTACK
        .onAppear {
            checked = reminder.isCompleted
        }
        .contentShape(Rectangle())
        .onTapGesture {
            onEvnet(.onSelect(reminder))
        }
    }
}

struct ReminderCellView_Previews: PreviewProvider {
    static var previews: some View {
        ReminderCellView(reminder: PreviewData.reminder, isSelected: false) { _ in }
    }
}

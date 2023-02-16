//
//  ReminderDetailView.swift
//  MyReminders
//
//  Created by 한상민 on 2023/02/13.
//

import SwiftUI

struct ReminderDetailView: View {
    var isNew: Bool = false
    @Binding var newReminder: Reminder
    
    @Environment(\.dismiss) private var dismiss
    @Binding var  reminder: Reminder
    @State var editConfig: ReminderEditConfig
    
    private var isFormValid: Bool {
        !editConfig.title.isEmpty
    }
    
    @State private var showDatePicker = false
    
    var originList: MyList
    @State private var editList: MyList?
   
    let onSaveNew: (() -> Void)?
    
    private func dateToStr(date: Date?, dateStyle: Date.FormatStyle.DateStyle, timeStyle: Date.FormatStyle.TimeStyle) -> String {
        guard let date else {
            return Date().formatted(date: dateStyle, time: timeStyle)
        }
        return date.formatted(date: dateStyle, time: timeStyle)
    }
    
    var body: some View {
        NavigationView {
            VStack {
                List {
                    Section {
                        TextField("제목", text: $editConfig.title)
                        TextField("메모", text: $editConfig.notes ?? "")
                    } // :SECTION1
                    
                    Section {
                        Toggle(isOn: $editConfig.hasDate) {
                            HStack {
                                Image(systemName: "calendar")
                                    .foregroundColor(.white)
                                    .background {
                                        RoundedRectangle(cornerRadius: 5)
                                            .fill(.red)
                                            .frame(width: 30, height: 30)
                                    }.padding([.trailing], 5)
                                VStack(alignment: .leading) {
                                    Text("날짜")
                                    if editConfig.hasDate {
                                        Text(dateToStr(date: editConfig.reminderDate, dateStyle: .numeric, timeStyle: .omitted))
                                            .font(.caption)
                                            .foregroundColor(.blue)
                                    }
                                }
                            }
                        }.onTapGesture {
                            showDatePicker = !editConfig.hasDate
                        }
                        
                        if showDatePicker && editConfig.hasDate {
                            DatePicker("Select Date", selection: $editConfig.reminderDate ?? Date(), displayedComponents: .date)
                                .datePickerStyle(.graphical)
                        }
                        
                        Toggle(isOn: $editConfig.hasTime) {
                            HStack {
                                Image(systemName: "clock")
                                    .foregroundColor(.white)
                                    .background {
                                        RoundedRectangle(cornerRadius: 5)
                                            .fill(.blue)
                                            .frame(width: 30, height: 30)
                                    }.padding([.trailing], 5)
                                VStack(alignment: .leading) {
                                    Text("시간")
                                    if editConfig.hasTime {
                                        Text(dateToStr(date: editConfig.reminderTime, dateStyle: .omitted, timeStyle: .shortened))
                                            .font(.caption)
                                            .foregroundColor(.blue)
                                    }
                                }

                            }
                        }
                        
                        if editConfig.hasTime {
                            DatePicker("Select Time", selection: $editConfig.reminderTime ?? Date(), displayedComponents: .hourAndMinute)
                                .datePickerStyle(.wheel)
                        }
                    } // :SECTION2
                    
                    Section {
                        NavigationLink {
                            SelectListView(reminder: isNew ? $newReminder : $reminder) { selectedList in
                                do {
                                    try ReminderService.save()
                                }
                                catch {
                                    print(error)
                                }
                                editList = selectedList
                            }
                        } label: {
                            HStack {
                                Text("목록")
                                Spacer()
                                Text(editList?.name ?? originList.name)
                            }
                        }

                    } // :SECTION3
                    .onChange(of: editConfig.hasDate) { hasDate in
                        if hasDate {
                            editConfig.reminderDate = Date()
                        }
                    }.onChange(of: editConfig.hasTime) { hasTime in
                        if hasTime {
                            editConfig.reminderTime = Date()
                        }
                    }
                }.listStyle(.insetGrouped) // :List
            } // :VSTACK
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("세부사항")
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("완료") {
                        let temp = isNew ? newReminder : reminder
                        do {
                            let updated = try ReminderService.updateReminder(reminder: temp, editConfig: editConfig)
                            if updated {
                                if temp.reminderDate != nil || temp.reminderTime != nil {
                                    let userData = UserData(title: temp.title, body: temp.notes, date: temp.reminderDate, time: temp.reminderTime)
                                    NotificationManager.scheduleNotification(userData: userData)
                                }
                            }
                        } catch {
                            print(error)
                        }
                        if isNew {onSaveNew!()}
                        dismiss()
                    }.disabled(!isFormValid)
                }
                
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("취소") {
                        if isNew {
                            do {
                                try ReminderService.deleteReminder(newReminder)
                            } catch {
                                print(error)
                            }
                        }
                        //TODO : Alert 넣기
                        dismiss()
                    }
                }
            }
        } // :NAVIGATIONVIEW
    }
}

//struct ReminderDetailView_Previews: PreviewProvider {
//    static var previews: some View {
//        ReminderDetailView(reminder: .constant(PreviewData.reminder))
//    }
//}

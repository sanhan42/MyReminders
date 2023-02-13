//
//  ReminderDetailView.swift
//  MyReminders
//
//  Created by 한상민 on 2023/02/13.
//

import SwiftUI

struct ReminderDetailView: View {
    
    @Environment(\.dismiss) private var dismiss
    @Binding var  reminder: Reminder
    @State var editConfig: ReminderEditConfig = ReminderEditConfig()
    
    var body: some View {
        NavigationView {
            VStack {
                List {
                    Section {
                        TextField("제목", text: $editConfig.title)
                        TextField("메모", text: $editConfig.notes ?? "")
                    }
                    
                    Section {
                        Toggle(isOn: $editConfig.hasDate) {
//                            Label {
//                                VStack(alignment: .leading) {
//                                    Text("날짜")
////                                    Text("날짜")
////                                        .font(.caption)
////                                        .foregroundColor(.blue)
//
//                                }
//                            } icon: {
//                                Image(systemName: "calendar")
//                                    .foregroundColor(.red)
//                                    .padding([.leading], 0)
//                            }

//                            HStack {
                                Image(systemName: "calendar")
                                    .foregroundColor(.red)
//                                VStack(alignment: .leading) {
//                                    Text("날짜")
//                                    if editConfig.hasDate {
//                                        Text("날짜 들어갈 부분")
//                                    }
//                                }
//                            }
                        }
                        
                        if editConfig.hasDate {
                            DatePicker("Select Date", selection: $editConfig.reminderDate ?? Date(), displayedComponents: .date)
                                .datePickerStyle(.graphical)
                        }
                        
                        Toggle(isOn: $editConfig.hasTime) {
                            Image(systemName: "clock")
                                .foregroundColor(.blue)
                        }
                        
                        if editConfig.hasTime {
                            DatePicker("Select Time", selection: $editConfig.reminderTime ?? Date(), displayedComponents: .hourAndMinute)
                                .datePickerStyle(.wheel)
                        }
                    }
                }.listStyle(.insetGrouped) // :List
            } // :VSTACK
            .onAppear {
                editConfig = ReminderEditConfig(reminder: reminder)
            }
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("세부사항")
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("완료") {
                        
                    }
                }
                
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("취소") {
                        
                    }
                }
            }
        } // :NAVIGATIONVIEW
    }
}

struct ReminderDetailView_Previews: PreviewProvider {
    static var previews: some View {
        ReminderDetailView(reminder: .constant(PreviewData.reminder))
    }
}

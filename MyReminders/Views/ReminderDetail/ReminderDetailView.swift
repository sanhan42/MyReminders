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
    
    //TODO: 날짜 선택 부분 마무리, 시간 선택 부분에도 적용하기
    @State private var showDatePicker = false
    
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
                                        Text("날짜 들어갈 부분")
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
                            Image(systemName: "clock")
                                .foregroundColor(.blue)
                        }
                        
                        if editConfig.hasTime {
                            DatePicker("Select Time", selection: $editConfig.reminderTime ?? Date(), displayedComponents: .hourAndMinute)
                                .datePickerStyle(.wheel)
                        }
                    } // :SECTION2
                    
                    Section {
                        NavigationLink {
                            Text("SelectListView")
                        } label: {
                            HStack {
                                Text("목록")
                                Spacer()
                                Text(reminder.list!.name)
                            }
                        }

                    } // :SECTION3
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
                        dismiss()
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

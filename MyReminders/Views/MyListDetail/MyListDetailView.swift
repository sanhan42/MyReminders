//
//  MyListDetailView.swift
//  MyReminders
//
//  Created by 한상민 on 2023/02/13.
//

import SwiftUI

struct MyListDetailView: View {
    
    let myList: MyList
    @State private var openAddReminder = false
    @State private var title = ""
    
    @FetchRequest(sortDescriptors: [])
    private var reminderResults: FetchedResults<Reminder>
    
    private var isFormValid: Bool {
        !title.isEmptyOrWhitespace
    }
    
    init(myList: MyList) {
        self.myList = myList
        _reminderResults = FetchRequest(fetchRequest: ReminderService.getRemindersByList(myList: myList))
    }
    
    var body: some View {
        VStack {
           
            ReminderListView(reminders: reminderResults)
            
            HStack {
                Image(systemName: "plus.circle.fill")
                Button("새로운 미리 알림") {
                    openAddReminder = true
                }
            } // :HSTACK
            .foregroundColor(.blue)
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding()
        } // :VSTACK
        .alert("새로운 미리 알림", isPresented: $openAddReminder) {
            TextField("", text: $title)
            Button("취소", role: .cancel) {}
            Button("완료") {
                if isFormValid {
                    do {
                        try ReminderService.saveReminderToMyList(myList: myList, reminderTitle: title)
                    } catch {
                        print(error.localizedDescription )
                    }
                }
            }
        }
    }
}

struct MyListDetailView_Previews: PreviewProvider {
    static var previews: some View {
        MyListDetailView(myList: PreviewData.myList)
    }
}

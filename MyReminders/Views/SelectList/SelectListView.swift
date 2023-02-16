//
//  SelectListView.swift
//  MyReminders
//
//  Created by 한상민 on 2023/02/13.
//

import SwiftUI

struct SelectListView: View {
    
    @FetchRequest(sortDescriptors: [])
    private var myListsFetchResults: FetchedResults<MyList>
    @Binding var reminder: Reminder
    let onSave: ((MyList) -> Void)?
    
    var body: some View {
        List(myListsFetchResults) { myList in
            HStack {
                HStack {
                    Image(systemName: "line.3.horizontal.circle.fill")
                        .foregroundColor(Color(myList.color))
                    Text(myList.name)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .contentShape(Rectangle())
                .onTapGesture {
                    self.reminder.list = myList
                    self.onSave!(reminder.list!)
                }
                
//                Spacer()
                
                if reminder.list == myList {
                    Image(systemName: "checkmark")
                        .foregroundColor(.blue)
                }
            }
        }
    }
}

//struct SelectListView_Previews: PreviewProvider {
//    static var previews: some View {
//        SelectListView(selectedList: .constant(PreviewData.myList), onSave: nil)
//            .environment(\.managedObjectContext, CoreDataProvider.shared.persistentContainer.viewContext)
//    }
//}

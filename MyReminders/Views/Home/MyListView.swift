//
//  MyListView.swift
//  MyReminders
//
//  Created by 한상민 on 2023/02/13.
//

import SwiftUI

struct MyListView: View {
    
    let myLists: FetchedResults<MyList>
    
    private func deleteList(_ indexSet: IndexSet) {
        indexSet.forEach { index in
            let list = myLists[index]
            do {
                try ReminderService.deleteList(list)
            } catch {
                print(error)
            }
        }
    }
    
    var body: some View {
        NavigationStack {
            if myLists.isEmpty {
                Spacer()
                Text("내 목록이 없습니다")
            } else {
                ForEach(myLists) { myList in
                    NavigationLink(value: myList) {
                        VStack {
                            MyListCellView(myList: myList)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding([.leading], 10)
                                .font(.body)
                                .foregroundColor(Color(.label))
                            Divider()
                        } // :VSTACK
                    } // :NAVIGATIONLINK
                }.onDelete(perform: deleteList(_:))
                .scrollContentBackground(.hidden) // :FOREACH
                
                    .navigationDestination(for: MyList.self) { myList in
                       MyListDetailView(myList: myList)
                            .navigationTitle(myList.name)
                            .navigationBarTitleDisplayMode(.large)
                    }
            }
        }
    }
}


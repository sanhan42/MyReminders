//
//  MyListView.swift
//  MyReminders
//
//  Created by 한상민 on 2023/02/13.
//

import SwiftUI

struct MyListView: View {
    
    let myLists: FetchedResults<MyList>
    
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
                                .font(.title3)
                            Divider()
                        } // :VSTACK
                    } // :NAVIGATIONLINK
                }.scrollContentBackground(.hidden) // :FOREACH
                    .navigationDestination(for: MyList.self) { myList in
                       MyListDetailView(myList: myList)
                            .navigationTitle(myList.name)
                    }
            }
        }
    }
}


//
//  HomeView.swift
//  MyReminder
//
//  Created by 한상민 on 2023/02/07.
//

import SwiftUI
import CoreData

struct HomeView: View {
    
    @FetchRequest(sortDescriptors: [])
    private var myListResults: FetchedResults<MyList>
    
    @FetchRequest(sortDescriptors: [])
    private var searchResults: FetchedResults<Reminder>
    
    @State private var search: String = ""
    @State private var searching: Bool = false
    @State private var isPresented: Bool = false
    
    var body: some View {
        NavigationStack {
            VStack {
                ScrollView {
                    MyListView(myLists: myListResults)
                    
                    //                Spacer()
                    
                    Button {
                        isPresented = true
                    } label: {
                        Text("목록 추가")
                            .frame(maxWidth: .infinity, alignment: .trailing)
                            .font(.headline)
                    }.padding() // :BUTTON
                } // :SCROLLVIEW
            } // :VSTACK
            .sheet(isPresented: $isPresented) {
                NavigationView {
                    AddNewListView { name, color in
                        // Save the list to the database
                        do {
                            try ReminderService.saveMyList(name, color)
                        } catch {
                            print(error)
                        }
                    }
                }
            }
            .onChange(of: search, perform: { searchTerm in
                searching = !searchTerm.isEmpty //? true : false
                searchResults.nsPredicate = ReminderService.getRemindersBySearchTerm(searchTerm).predicate
            })
            .overlay(alignment: .center, content: {
                ReminderListView(reminders: searchResults)
                    .listStyle(.plain)
                    .background(content: {
                        Color.white
                    })
                    .opacity(searching ? 1.0 : 0.0)
            })
            .padding()
        }.searchable(text: $search) // :NAVIGATIONSTACK
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
            .environment(\.managedObjectContext, CoreDataProvider.shared.persistentContainer.viewContext)
    }
}

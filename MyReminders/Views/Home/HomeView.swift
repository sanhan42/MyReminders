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
    
    private var reminderStatsBuilder = ReminderStatsBuilder()
    @State private var reminderStatsValues = ReminderStatsValues()
    
    var body: some View {
        NavigationStack {
            VStack {
                ScrollView {
                    HStack {
                        ReminderStatsView(icon: "calendar.circle.fill", title: "오늘", count: reminderStatsValues.todaysCount)
                        ReminderStatsView(icon: "calendar.badge.clock", title: "예정", count: reminderStatsValues.scheduledCount)
                    }
                    
                    HStack {
                        ReminderStatsView(icon: "tray.circle.fill", title: "전체", count: reminderStatsValues.allCount, iconColor: .gray)
                        ReminderStatsView(icon: "checkmark.circle.fill", title: "완료", count: reminderStatsValues.completedCount)
                    }
                    
                    Text("나의 목록")
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .font(.title2)
                        .bold()
                        .padding(10)
                    
                    MyListView(myLists: myListResults)
                    
                    
                    Button {
                        isPresented = true
                    } label: {
                        Text("목록 추가")
                            .frame(maxWidth: .infinity, alignment: .trailing)
                            .font(.headline)
                    } // :BUTTON
                    .padding()
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
                } // :SCROLLVIEW
            } // :VSTACK
            .onChange(of: search, perform: { searchTerm in
                searching = !searchTerm.isEmpty //? true : false
                searchResults.nsPredicate = ReminderService.getRemindersBySearchTerm(searchTerm).predicate
            })
            .overlay(alignment: .center, content: {
                ReminderListView(reminders: searchResults)
                    .listStyle(.plain)
                    .background(content: {
                        Color.white // TODO: 다크모드 대응 필요
                    })
                    .opacity(searching ? 1.0 : 0.0)
            })
            .onAppear(perform: {
                reminderStatsValues = reminderStatsBuilder.build(myListResults: myListResults)
                // TODO: search 결과에서 수정이 일어났을 경우에도 반영해줘야한다.
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

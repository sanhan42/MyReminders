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
    
    @FetchRequest(fetchRequest: ReminderService.remindersByStatType(statType: .today))
    private var todayResult: FetchedResults<Reminder>
    
    @FetchRequest(fetchRequest: ReminderService.remindersByStatType(statType: .scheduled))
    private var scheduledResult: FetchedResults<Reminder>
    
    @FetchRequest(fetchRequest: ReminderService.remindersByStatType(statType: .all))
    private var allResult: FetchedResults<Reminder>
    
    @FetchRequest(fetchRequest: ReminderService.remindersByStatType(statType: .completed))
    private var completedResult: FetchedResults<Reminder>
    
    @State private var search: String = ""
    @State private var searching: Bool = false
    @State private var isPresented: Bool = false
    
    private var reminderStatsBuilder = ReminderStatsBuilder()
    @State private var reminderStatsValues = ReminderStatsValues()
    
    private let space:CGFloat = 5
    var body: some View {
        NavigationStack {
            VStack() {
                ScrollView {
                    VStack(spacing: space) {
                        HStack(spacing: space) {
                            NavigationLink {
                                ReminderListView(reminders: todayResult)
                            } label: {
                                ReminderStatsView(icon: "calendar", title: "오늘", count: reminderStatsValues.todaysCount)
                            }
                            Spacer()
                            
                            NavigationLink {
                                ReminderListView(reminders: scheduledResult)
                            } label: {
                                ReminderStatsView(icon: "calendar.badge.clock", title: "예정", count: reminderStatsValues.scheduledCount, iconColor: .red)
                            }
                        }
                        
                        Spacer()
                        
                        HStack(spacing: space) {
                            NavigationLink {
                                ReminderListView(reminders: allResult)
                            } label: {
                                ReminderStatsView(icon: "tray.fill", title: "전체", count: reminderStatsValues.allCount, iconColor: Color("CompletedColor"))
                            }
                            
                            Spacer()
                            
                            NavigationLink {
                                ReminderListView(reminders: completedResult)
                            } label: {
                                ReminderStatsView(icon: "checkmark", title: "완료됨", count: reminderStatsValues.completedCount, iconColor: Color(.opaqueSeparator))
                            }
                        }
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

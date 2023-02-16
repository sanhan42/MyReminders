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
    @State private var showAddReminder: Bool = false
    
    private var reminderStatsBuilder = ReminderStatsBuilder()
    @State private var reminderStatsValues = ReminderStatsValues()
    
    @State private var newReminder = Reminder()
    @State private var tempReminder = Reminder()
    
    private let space:CGFloat = 5
    var body: some View {
        NavigationStack {
            VStack() {
                ScrollView {
                    VStack(spacing: space) {
                        HStack(spacing: space) {
                            NavigationLink {
                                ReminderListView(reminders: todayResult)
                                    .navigationTitle("오늘")
                            } label: {
                                ReminderStatsView(icon: "calendar", title: "오늘", count: reminderStatsValues.todaysCount)
                            }
                            Spacer()
                            
                            NavigationLink {
                                ReminderListView(reminders: scheduledResult)
                                    .navigationTitle("예정")
                            } label: {
                                ReminderStatsView(icon: "calendar.badge.clock", title: "예정", count: reminderStatsValues.scheduledCount, iconColor: .red)
                            }
                        }
                        
                        Spacer()
                        
                        HStack(spacing: space) {
                            NavigationLink {
                                ReminderListView(reminders: allResult)
                                    .navigationTitle("전체")
                            } label: {
                                ReminderStatsView(icon: "tray.fill", title: "전체", count: reminderStatsValues.allCount, iconColor: Color("CompletedColor"))
                            }
                            
                            Spacer()
                            
                            NavigationLink {
                                ReminderListView(reminders: completedResult)
                                    .navigationTitle("완료됨")
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
                        Color(.systemBackground)
                    })
                    .opacity(searching ? 1.0 : 0.0)
            })
            .onAppear(perform: {
                reminderStatsValues = reminderStatsBuilder.build(myListResults: myListResults)
            })
            .padding()
            .toolbar {
                ToolbarItem(placement: .bottomBar) {
                    Button {
                        do {
                            newReminder = try ReminderService.saveReminderToMyList(myList: myListResults.first!, reminderTitle: "")
                        } catch {
                            print(error)
                        }
                        showAddReminder = true
                    } label: {
                        Image(systemName: "plus.circle.fill")
                        
                        Text("새로운 미리 알림")
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .font(.headline)
                    } // :BUTTON
                    .disabled(myListResults.isEmpty)
                    .sheet(isPresented: $showAddReminder) {
                        ReminderDetailView(isNew: true, newReminder: $newReminder, reminder: $tempReminder, editConfig: ReminderEditConfig(), originList: myListResults.first!) {
                            reminderStatsValues = reminderStatsBuilder.build(myListResults: myListResults)
                        }
                    }
                    
                }
                
                ToolbarItem(placement: .bottomBar) {
                    Button {
                        isPresented = true
                    } label: {
                        Text("목록 추가")
                            .frame(maxWidth: .infinity, alignment: .trailing)
                            .font(.headline)
                    } // :BUTTON
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
                }
            }
        }.searchable(text: $search) // :NAVIGATIONSTACK
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
            .environment(\.managedObjectContext, CoreDataProvider.shared.persistentContainer.viewContext)
    }
}

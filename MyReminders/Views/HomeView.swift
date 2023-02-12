//
//  HomeView.swift
//  MyReminder
//
//  Created by 한상민 on 2023/02/07.
//

import SwiftUI
import CoreData

struct HomeView: View {
    
    @State private var isPresented: Bool = false
    var body: some View {
        NavigationStack {
            VStack {
                Text("Hello, world")
                
                Spacer()
                
                HStack {
                    Spacer()
                    
                    Button {
                        isPresented = true
                    } label: {
                        Text("목록 추가")
                            .frame(alignment: .trailing)
                            .font(.headline)
                    }.padding() // :BUTTON
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
                        } // :HSTACK
                } // :VSTACK
            }.padding() // :NAVIGATIONSTACK
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
            .environment(\.managedObjectContext, CoreDataProvider.shared.persistentContainer.viewContext)
    }
}

//
//  MyRemindersApp.swift
//  MyReminder
//
//  Created by 한상민 on 2023/02/07.
//

import SwiftUI

@main
struct MyRemindersApp: App {

    var body: some Scene {
        WindowGroup {
            HomeView()
                .environment(\.managedObjectContext, CoreDataProvider.shared.persistentContainer.viewContext)
        }
    }
}

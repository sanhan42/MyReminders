//
//  CoreDataProvider.swift
//  MyReminder
//
//  Created by 한상민 on 2023/02/07.
//

import Foundation
import CoreData

class CoreDataProvider {
    
    static let shared = CoreDataProvider()
    let persistentContainer: NSPersistentContainer
    
    private init() {
        
        // register transformers
        ValueTransformer.setValueTransformer(UIColorTransformer(), forName: NSValueTransformerName("UIColorTransformer"))
        
        persistentContainer = NSPersistentContainer(name: "RemidersModel")
        persistentContainer.loadPersistentStores { description, error in
            if let error {
                fatalError("ReminderModel 초기화 실패! \(error)")
            }
        }
    }
}

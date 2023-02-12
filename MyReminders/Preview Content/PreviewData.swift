//
//  PreviewData.swift
//  MyReminders
//
//  Created by 한상민 on 2023/02/13.
//

import Foundation
import CoreData

class PreviewData {
    
    static var myList: MyList {
        let viewContext = CoreDataProvider.shared.persistentContainer.viewContext
        let request = MyList.fetchRequest()
        return (try? viewContext.fetch(request).first) ?? MyList()
    }
}

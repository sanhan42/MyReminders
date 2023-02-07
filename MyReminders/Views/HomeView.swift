//
//  HomeView.swift
//  MyReminder
//
//  Created by 한상민 on 2023/02/07.
//

import SwiftUI
import CoreData

struct HomeView: View {
    
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundColor(.accentColor)
            Text("Hello, world!")
            Text("Bye World!")
        }
        .padding()
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}

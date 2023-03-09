//
//  SodaApp.swift
//  Soda
//
//  Created by Adam on 3/6/23.
//

import SwiftUI

@main
struct SodaApp: App {
//    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            HomeView()
//                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}

//
//  vt6002cem_mobile_appApp.swift
//  vt6002cem_mobile_app
//
//  Created by Aaron Tso  on 23/1/2025.
//

import SwiftUI

@main
struct vt6002cem_mobile_appApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}

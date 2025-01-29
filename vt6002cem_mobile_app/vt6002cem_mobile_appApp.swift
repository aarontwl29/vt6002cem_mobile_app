import SwiftUI

@main
struct vt6002cem_mobile_appApp: App {
    let persistenceController = PersistenceController.shared
    @StateObject var darkModeStore = DarkModeStore()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
                .environmentObject(darkModeStore)
        }
    }
}

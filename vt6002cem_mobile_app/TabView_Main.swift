import SwiftUI

struct TabView_Main: View {
    
    
    var body: some View {
        TabView {
            // Report Page
            ReportView()
                .tabItem {
                    Image(systemName: "pencil.circle.fill") // Replace with your custom icon if available
                    Text("Report")
                }
            
            // Finding Lost Page
            FindingLostView()
                .tabItem {
                    Image(systemName: "magnifyingglass.circle.fill")
                    Text("Finding Lost")
                }
            
            // Navigation (Map Guide on GPS) Page
            ReportView()
                .tabItem {
                    Image(systemName: "map.circle.fill")
                    Text("Navigation")
                }
            
            // Profile Page
            ReportView()
                .tabItem {
                    Image(systemName: "person.circle.fill")
                    Text("Profile")
                }
        }
        .accentColor(.blue) // Customizes the active tab color
    }
}


struct TabView_Main_Previews: PreviewProvider {
    static var previews: some View {
        TabView_Main().environmentObject(ReportManager())
    }
}


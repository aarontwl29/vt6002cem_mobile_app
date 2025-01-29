import SwiftUI
import CoreData

struct ContentView: View {
    @State private var isLoggedIn = AppSettings.isLoggedIn()
    
    var body: some View {
        
        Group {
            if isLoggedIn {
                WelcomeBackView()
            } else {
                View_Login()
            }
        }
        .onAppear {
            isLoggedIn = AppSettings.isLoggedIn()
        }


        //        View_Login()
    }

}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}


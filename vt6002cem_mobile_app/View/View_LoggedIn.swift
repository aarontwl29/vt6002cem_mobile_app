import SwiftUI

struct WelcomeBackView: View {

    @State private var user = AppSettings.getUser()
    @State private var isDarkMode = AppSettings.isDarkMode()
    @Environment(\.colorScheme) var colorScheme

    @State private var isNavigating = false
    
    @StateObject private var reportManager = ReportManager()
    @StateObject private var reportViewModel: ReportViewModel
    
    init() {
        let manager = ReportManager()
        _reportManager = StateObject(wrappedValue: manager)
        _reportViewModel = StateObject(wrappedValue: ReportViewModel(reportManager: manager))
    }
    
    var body: some View {
        VStack(spacing: 30) {
            Spacer()

            // Welcome Message
            VStack(spacing: 6) {
                Text("Welcome Back!")
                    .font(.largeTitle)
                    .bold()

                
                Text("You're signed in as ")
                    .font(.body)
                    .foregroundColor(.secondary) +
                Text(user.fullName)
                    .font(.body)
                    .bold()
                    .foregroundColor(.primary)
                
            }
            .multilineTextAlignment(.center)
            .padding(.horizontal, 30) // Limits width for better readability

            // Profile Card (Restructured)
            VStack {
                Circle()
                    .fill(Color.gray.opacity(0.8))
                    .frame(width: 85, height: 85)
                    .overlay(
                        Text(String(user.fullName.prefix(1)).uppercased()) // First letter as initials
                            .foregroundColor(.white)
                            .font(.largeTitle)
                            .bold()
                    )

                // Darker email for better visibility
                Text(user.email)
                    .font(.body)
                    .foregroundColor(.primary) // Uses system default text color (darker)
            }
            .padding()
            .frame(maxWidth: .infinity)
            .background(Color(UIColor.systemGray6))
            .cornerRadius(15)
            .padding(.horizontal)

            // Action Buttons
            VStack(spacing: 12) {
                Button(action: {
                    print("Continue tapped")
                    
                    reportViewModel.loadReports()
                    isNavigating = true
                    
                }) {
                    Text("Continue")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .cornerRadius(10)
                }
                .fullScreenCover(isPresented: $isNavigating) {
                    TabView_Main()
                        .environmentObject(reportManager)
                }

                Button(action: {
                    print("Sign in with Another Account tapped")
                    
                }) {
                    HStack {
                        Image(systemName: "arrow.triangle.2.circlepath.circle.fill") // Exchange-like icon
                            .foregroundColor(.red)
                        Text("Sign in with Another Account")
                            .foregroundColor(.red)
                            .fontWeight(.semibold)
                    }
                    .padding(.horizontal, 20)
                    .padding(.vertical, 10)
                }
            }
            .padding(.horizontal)

            Spacer()
        }
//        .background(Color(UIColor.systemGroupedBackground).edgesIgnoringSafeArea(.all))
        .background(isDarkMode ? Color.black : Color(UIColor.systemGroupedBackground))
        .preferredColorScheme(isDarkMode ? .dark : .light) // Apply dark mode globally
        .onAppear {
            user = AppSettings.getUser()
            isDarkMode = AppSettings.isDarkMode()
            
//            // Apply dark mode to entire app session
//            UIApplication.shared.windows.first?.overrideUserInterfaceStyle = isDarkMode ? .dark : .light
        }
    }
}

struct WelcomeBackView_Previews: PreviewProvider {
    static var previews: some View {
        WelcomeBackView()
    }
}

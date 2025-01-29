import SwiftUI

struct WelcomeBackView: View {
    // Sample user data (Replace later with actual login data)
    let username: String = "Aaron"
    let email: String = "aaron@example.com"

    var body: some View {
        VStack(spacing: 30) {
            Spacer()

            // Welcome Message
            VStack(spacing: 6) {
                Text("Welcome Back!")
                    .font(.largeTitle)
                    .bold()

                // Styling the name separately to ensure it is black and bold
                Text("You're signed in as ")
                    .font(.body)
                    .foregroundColor(.gray) +
                Text(username)
                    .font(.body)
                    .bold()
                    .foregroundColor(.black)
            }
            .multilineTextAlignment(.center)
            .padding(.horizontal, 30) // Limits width for better readability

            // Profile Card (Restructured)
            VStack {
                Circle()
                    .fill(Color.gray.opacity(0.8))
                    .frame(width: 85, height: 85)
                    .overlay(
                        Text(String(username.prefix(1)).uppercased()) // First letter as initials
                            .foregroundColor(.white)
                            .font(.largeTitle)
                            .bold()
                    )

                // Darker email for better visibility
                Text(email)
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
                }) {
                    Text("Continue")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .cornerRadius(10)
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
        .background(Color(UIColor.systemGroupedBackground).edgesIgnoringSafeArea(.all))
    }
}

struct WelcomeBackView_Previews: PreviewProvider {
    static var previews: some View {
        WelcomeBackView()
    }
}

import SwiftUI

struct View_Register: View {
    @State private var email = ""
    @State private var fullName = ""
    @State private var password = ""
    @State private var confirmPassword = ""
    @State private var isPasswordMatched = false

    var body: some View {
        VStack {
            Spacer()
            
            // Logo
            Image("logo_app") // Replace with your app logo
                .resizable()
                .frame(width: 100, height: 100)
                .padding()
            
            Text("Lost & Found+")
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding(.bottom, 30)
            
            // Email Address Field
            VStack(alignment: .leading) {
                Text("Email Address")
                    .font(.caption)
                    .foregroundColor(.gray)
                TextField("name@example.com", text: $email)
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(8)
            }
            .padding(.horizontal)
            .padding(.bottom, 10)
            
            // Full Name Field
            VStack(alignment: .leading) {
                Text("Full Name")
                    .font(.caption)
                    .foregroundColor(.gray)
                TextField("Enter your name", text: $fullName)
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(8)
            }
            .padding(.horizontal)
            .padding(.bottom, 10)
            
            // Password Field
            VStack(alignment: .leading) {
                Text("Password")
                    .font(.caption)
                    .foregroundColor(.gray)
                SecureField("Enter your password", text: $password)
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(8)
            }
            .padding(.horizontal)
            .padding(.bottom, 10)
            
            // Confirm Password Field
            VStack(alignment: .leading) {
                Text("Confirm Password")
                    .font(.caption)
                    .foregroundColor(.gray)
                HStack {
                    SecureField("Re-enter your password", text: $confirmPassword)
                        .padding()
                        .background(Color(.systemGray6))
                        .cornerRadius(8)
                    
                    // Match Indicator
                    if !confirmPassword.isEmpty {
                        Image(systemName: password == confirmPassword ? "checkmark.circle.fill" : "xmark.circle.fill")
                            .foregroundColor(password == confirmPassword ? .green : .red)
                            .padding(.trailing, 10)
                            .onChange(of: confirmPassword) { _ in
                                isPasswordMatched = (password == confirmPassword)
                            }
                    }
                }
            }
            .padding(.horizontal)
            .padding(.bottom, 20)
            
            // Sign Up Button
            Button(action: {
                // Add sign-up logic here
            }) {
                Text("SIGN UP")
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .cornerRadius(8)
            }
            .padding(.horizontal)
            .padding(.top, 10)
            
            Spacer()
            
            // Already have an account? Sign In
            HStack {
                Text("Already have an account?")
                    .foregroundColor(.gray)
                Button(action: {
                    // Navigate to Sign In view
                }) {
                    Text("Sign in")
                        .fontWeight(.bold)
                        .foregroundColor(.blue)
                }
            }
            .padding(.bottom, 30)
        }
    }
}

struct View_Register_Previews: PreviewProvider {
    static var previews: some View {
        View_Register()
    }
}

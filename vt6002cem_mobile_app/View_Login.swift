import SwiftUI

struct View_Login: View {
    var body: some View {
        VStack {
            Spacer()
            
            // Logo
            Image("logo_app")
                .resizable()
                .frame(width: 100, height: 100)
 
                .padding()

            Text("Lost & Found+")
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding(.bottom, 30)

            // Email Field
            TextField("Email Address", text: .constant(""))
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(8)
                .padding(.horizontal)

            // Password Field
            SecureField("Password", text: .constant(""))
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(8)
                .padding(.horizontal)

            // Sign In Button
            Button(action: {
                // Add sign-in action here
            }) {
                Text("SIGN IN")
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .cornerRadius(8)
                    .padding(.horizontal)
            }
            .padding(.top, 20)

            // Divider for Social Login
            HStack {
                Rectangle()
                    .frame(height: 1)
                    .foregroundColor(.gray)

                Text("or")
                    .foregroundColor(.gray)
                    .padding(.horizontal, 5)

                Rectangle()
                    .frame(height: 1)
                    .foregroundColor(.gray)
            }
            .padding(.vertical, 20)

            // Social Login Buttons
            VStack(spacing: 10) {
                Button(action: {
                    // Apple login action here
                }) {
                    HStack {
                        Image("logo_apple")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 40, height: 40)
                        Text("Sign in with Apple")
                            .font(.headline)
                            .foregroundColor(.black)
                    }
                    .frame(maxWidth: .infinity)
                    .frame(height: 22)
                    .padding()
                    .background(Color.white)
                    .cornerRadius(8)
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color.gray, lineWidth: 1)
                    )
                }

                Button(action: {
                    // Google login action here
                }) {
                    HStack {
                        Image("logo_google")
                            .resizable()
                            .frame(width: 20, height: 20)
                        Text("Sign in with Google")
                            .font(.headline)
                            .foregroundColor(.black)
                    }
                    .frame(maxWidth: .infinity)
                    .frame(height: 22)
                    .padding()
                    .padding(.leading, 12)
                    .background(Color.white)
                    .cornerRadius(8)
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color.gray, lineWidth: 1)
                    )
                }

                Button(action: {
                    // Facebook login action here
                }) {
                    HStack {
                        Image("logo_fb")
                            .resizable()
                            .frame(width: 20, height: 20)
                        Text("Sign in with Facebook")
                            .font(.headline)
                            .foregroundColor(.black)
                    }
                    .frame(maxWidth: .infinity)
                    .frame(height: 22)
                    .padding()
                    .padding(.leading, 15)
                    .background(Color.white)
                    .cornerRadius(8)
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color.gray, lineWidth: 1)
                    )
                }
            }
            .padding(.horizontal)

            Spacer()

            // Sign Up Prompt
            HStack {
                Text("Don't have an account?")
                    .foregroundColor(.gray)
                Button(action: {
                    // Navigate to sign-up page
                }) {
                    Text("Sign up")
                        .fontWeight(.bold)
                        .foregroundColor(.blue)
                }
            }
            .padding(.bottom, 30)
        }
    }
}

struct View_Login_Previews: PreviewProvider {
    static var previews: some View {
        View_Login()
    }
}


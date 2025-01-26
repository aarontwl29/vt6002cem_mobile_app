import SwiftUI
import Foundation

import WebKit

struct View_Login: View {
    
    @State private var email = ""
    @State private var password = ""
    @State private var isLoggedIn = false
    @State private var showAlert = false
    @State private var alertMessage = ""
    private let authManager = AuthManager()
    
    @State private var showGoogleLogin = false
    
    @StateObject private var reportManager = ReportManager()
    @StateObject private var reportViewModel: ReportViewModel
    
    init() {
        let manager = ReportManager()
        _reportManager = StateObject(wrappedValue: manager)
        _reportViewModel = StateObject(wrappedValue: ReportViewModel(reportManager: manager))
    }
    
    var body: some View {
        NavigationView {
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
                VStack(alignment: .leading) {
                    
                    TextField("Email Address", text: $email)
                        .padding()
                        .background(Color(.systemGray6))
                        .cornerRadius(8)
                }
                .padding(.horizontal)
                
                // Password Field
                VStack(alignment: .leading) {
                    
                    SecureField("Password", text: $password)
                        .padding()
                        .background(Color(.systemGray6))
                        .cornerRadius(8)
                }
                .padding(.horizontal)
                
                
                
                // Sign In Button
                Button(action: {
                    authManager.loginUser(email: email, password: password) { success, error in
                        DispatchQueue.main.async {
                            if success {
                                reportManager.email = email
                                isLoggedIn = true
                                
                                reportViewModel.loadReports()
                            } else {
                                email = ""
                                password = ""
                                
                                alertMessage = /*error ??*/ "Invalid credentials. Please try again."
                                showAlert = true
                            }
                        }
                    }
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
                .fullScreenCover(isPresented: $isLoggedIn) {
                    TabView_Main()
                        .environmentObject(reportManager)// The main TabView after login
                }
                .alert(isPresented: $showAlert) {
                    Alert(
                        title: Text("Login Failed"),
                        message: Text(alertMessage),
                        dismissButton: .default(Text("OK"))
                    )
                }
                
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
                        showGoogleLogin = true
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
                    .sheet(isPresented: $showGoogleLogin) {
                        WebView(url: URL(string: "https://accounts.google.com/signin")!)
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
                    NavigationLink(destination: View_Register()) {
                        Text("Sign up")
                            .fontWeight(.bold)
                            .foregroundColor(.blue)
                    }
                }
                .padding(.bottom, 30)
            }
        }
    }
}




struct WebView: UIViewRepresentable {
    let url: URL
    
    func makeUIView(context: Context) -> WKWebView {
        let webView = WKWebView()
        let request = URLRequest(url: url)
        webView.load(request)
        return webView
    }
    
    func updateUIView(_ uiView: WKWebView, context: Context) {}
}

struct WebViewWrapper: View {
    let url: URL
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        NavigationView {
            WebView(url: url)
                .navigationBarTitle("Google Login", displayMode: .inline)
                .navigationBarItems(leading: Button("Close") {
                    presentationMode.wrappedValue.dismiss()
                })
        }
    }
}



struct View_Login_Previews: PreviewProvider {
    static var previews: some View {
        View_Login()
    }
}



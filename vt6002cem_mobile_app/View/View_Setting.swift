import SwiftUI

struct ProfileView: View {
    @State private var user: User = AppSettings.getUser()
    @State private var isEditingPhone: Bool = false
    
    @EnvironmentObject var darkModeStore: DarkModeStore
    
    @State private var isLoggedOut = false
    
    var body: some View {
        NavigationView {
            VStack(spacing: 16) {
                // Profile Section
                VStack {
                    HStack {
                        Circle()
                            .fill(Color.gray)
                            .frame(width: 80, height: 80)
                            .overlay(
                                Text(getInitials(from: user.fullName))
                                    .foregroundColor(.white)
                                    .bold()
                                    .font(.largeTitle)
                            )
                        VStack(alignment: .leading) {
                            Text(user.fullName)
                                .font(.title2)
                                .bold()
                            Text(user.email)
                                .font(.body)
                                .foregroundColor(.gray)
                        }
                        Spacer()
                    }
                    .padding()
                }
                .background(Color(UIColor.systemGray6))
                .cornerRadius(12)
                .padding(.horizontal)
                .padding(.top, 50)  // top padding
                
                // General Section
                SectionHeader(title: "GENERAL")
                VStack(spacing: 0) {
                    HStack {
                        Image(systemName: "gear")
                            .foregroundColor(.gray)
                        Text("Version")
                        Spacer()
                        Text("1.0.0")
                            .foregroundColor(.gray)
                        Spacer(minLength: 16)
                        Button(action: {
                            // Handle update functionality
                            print("Update Now tapped")
                        }) {
                            Text("Update Now")
                                .font(.footnote)
                                .foregroundColor(.blue)
                                .bold()
                        }
                        .padding(.vertical, 6)
                        .padding(.horizontal, 12)
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color.blue, lineWidth: 1)
                        )
                    }
                    .padding()
                    
                    Divider()
                    
                    HStack {
                        Image(systemName: "moon.stars.fill")
                            .foregroundColor(.gray)
                        Text("Appearance")
                        Spacer()
                        Text("Dark")
                            .foregroundColor(.gray)
                        Toggle("", isOn: $darkModeStore.isDarkMode)
                            .labelsHidden()
                    }
                    .padding()
                }
                .background(Color(UIColor.systemGray6))
                .cornerRadius(12)
                .padding(.horizontal)

                
                // Account Section
                SectionHeader(title: "ACCOUNT")
                VStack(spacing: 0) {
                    HStack {
                        Image(systemName: "phone.fill")
                            .foregroundColor(.gray)
                        Text("Telephone No.")
                        Spacer()
                        TextField("Enter number", text: $user.phone)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .disabled(!isEditingPhone)
                            .frame(width: 150)
                        
                        Button(action: {
                            isEditingPhone.toggle()
                            if !isEditingPhone {
                                // Handle save logic
                                print("Telephone number saved: \($user.phone)")
                            }
                        }) {
                            Image(systemName: isEditingPhone ? "checkmark.circle.fill" : "pencil.circle")
                                .font(.title2)
                                .foregroundColor(isEditingPhone ? .green : .blue)
                        }
                    }
                    .padding()
                }
                .background(Color(UIColor.systemGray6))
                .cornerRadius(12)
                .padding(.horizontal)
                
                // Sign Out and Quit Section
                Divider()
                    .padding(.horizontal)
                
                HStack {
                    Spacer()
                    
                    Button(action: signOut) {
                        HStack {
                            Image(systemName: "arrowshape.turn.up.left.fill")
                                .foregroundColor(.red)
                            Text("Sign Out")
                                .foregroundColor(.red)
                                .fontWeight(.semibold)
                        }
                        .padding(.horizontal, 16)
                        .padding(.vertical, 8)
                        .background(Color(UIColor.systemGray6))
                        .cornerRadius(8)
                    }
                    
                    Spacer()
                    
                    Button(action: {
                        exit(0) // Quit the app
                    }) {
                        HStack {
                            Image(systemName: "rectangle.portrait.and.arrow.right.fill")
                                .foregroundColor(.orange)
                            Text("Quit")
                                .foregroundColor(.orange)
                                .fontWeight(.semibold)
                        }
                        .padding(.horizontal, 16)
                        .padding(.vertical, 8)
                        .background(Color(UIColor.systemGray6))
                        .cornerRadius(8)
                    }
                    
                    Spacer()
                }
                .padding(.horizontal)
                
                Spacer()
            }
            //            .navigationTitle("Profile")
            .background(Color(UIColor.systemGroupedBackground).edgesIgnoringSafeArea(.all))
            .fullScreenCover(isPresented: $isLoggedOut) {  // 🔹 Redirect to login
                View_Login()
            }
        }
    }
    
    private func signOut() {
        AppSettings.setLoggedIn(false)
        AppSettings.clearUser()
        
        isLoggedOut = true
        print("User signed out, login state cleared.")
    }
    
    private func getInitials(from fullName: String) -> String {
        let words = fullName.split(separator: " ")
        let initials = words.map { String($0.prefix(1)) }.joined().uppercased()
        return initials.isEmpty ? "?" : initials
    }
}

struct SectionHeader: View {
    let title: String
    
    var body: some View {
        HStack {
            Text(title)
                .font(.subheadline)
                .fontWeight(.bold)
                .foregroundColor(.gray)
                .padding(.leading)
            Spacer()
        }
        .padding(.top, 8)
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
            .preferredColorScheme(.light)
    }
}

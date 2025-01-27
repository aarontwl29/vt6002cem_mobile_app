import SwiftUI

struct ProfileView: View {
    @State private var telephoneNumber: String = "1234567890"
    @State private var isEditingPhone: Bool = false
    @State private var isDarkMode: Bool = false
    @Environment(\.colorScheme) var colorScheme

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
                                Text("MC")
                                    .foregroundColor(.white)
                                    .bold()
                                    .font(.largeTitle)
                            )
                        VStack(alignment: .leading) {
                            Text("Chan Man")
                                .font(.title2)
                                .bold()
                            Text("demo1@gmail.com")
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
                        Toggle("", isOn: $isDarkMode)
                            .labelsHidden()
                            .onChange(of: isDarkMode) { value in
                                UIApplication.shared.windows.first?.overrideUserInterfaceStyle = value ? .dark : .light
                            }
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
                        TextField("Enter number", text: $telephoneNumber)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .disabled(!isEditingPhone)
                            .frame(width: 150)

                        Button(action: {
                            isEditingPhone.toggle()
                            if !isEditingPhone {
                                // Handle save logic
                                print("Telephone number saved: \(telephoneNumber)")
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

                    Button(action: {
                        print("Sign Out tapped")
                    }) {
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
        }
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

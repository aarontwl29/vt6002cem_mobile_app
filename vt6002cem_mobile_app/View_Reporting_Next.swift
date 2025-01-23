import SwiftUI

struct View_Reporting_Next: View {
    @State private var description: String = ""
    
    @State private var isContactEnabled: Bool = false
    @State private var showFullName: Bool = false
    @State private var fullName: String = "Aaron Tso"
    @State private var phoneNumber: String = ""
    
    @State private var isRecording: Bool = false
    
    var body: some View {
        VStack(spacing: 20) {
            // 1. Description Box
            VStack(alignment: .leading, spacing: 5) {
                Text("Description")
                    .font(.headline)
                TextEditor(text: $description)
                    .frame(height: 100)
                    .padding(8)
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(8)
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color.gray.opacity(0.2), lineWidth: 1)
                    )
            }
            
            // 2. Comment in Sound
            VStack(alignment: .leading, spacing: 10) {
                Text("Record a Comment")
                    .font(.headline)
                
                Button(action: {
                    isRecording.toggle()
                    if isRecording {
                        startRecording()
                    } else {
                        stopRecording()
                    }
                }) {
                    HStack {
                        Image(systemName: isRecording ? "stop.circle.fill" : "mic.circle.fill")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 24, height: 24)
                        Text(isRecording ? "Stop Recording" : "Start Recording")
                            .font(.headline)
                    }
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(isRecording ? Color.red.opacity(0.8) : Color.blue.opacity(0.8))
                    .foregroundColor(.white)
                    .cornerRadius(8)
                }
            }
            
            // 2. Contact Information Toggle
            VStack(alignment: .leading, spacing: 10) {
                Toggle(isOn: $isContactEnabled) {
                    Text("Leave Contact Information")
                        .font(.headline)
                }
                .padding()
                .background(Color.gray.opacity(0.1))
                .cornerRadius(8)
            }
            
            // 3. Full Name and Phone Number
            if isContactEnabled {
                VStack(alignment: .leading, spacing: 15) {
                    // Full Name with Checkbox
                    HStack {
                        Text("Full Name")
                            .font(.headline)
                        Spacer()
                        Toggle("", isOn: $showFullName)
                            .labelsHidden()
                            .toggleStyle(SwitchToggleStyle())
                    }
                    .padding(.horizontal)
                    
                    if showFullName {
                        TextField("Enter your full name", text: $fullName)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .padding(.horizontal)
                    }
                    
                    // Phone Number
                    VStack(alignment: .leading, spacing: 5) {
                        Text("Phone Number")
                            .font(.headline)
                        TextField("Enter your phone number", text: $phoneNumber)
                            .keyboardType(.phonePad)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .padding(.horizontal)
                    }
                }
            }
            
            // 5. Submit Button
            Button(action: {
                submitFeedback()
            }) {
                Text("Submit")
                    .font(.headline)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.green.opacity(0.8))
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            
            Spacer()
        }
        .padding()
        .navigationTitle("Feedback Form")
    }
    
    // Dummy functions for recording
    private func startRecording() {
        print("Recording started...")
        // Add your actual recording logic here
    }
    
    private func stopRecording() {
        print("Recording stopped.")
        // Add your actual logic to stop recording and save the audio file
    }
    
    // Submit feedback function
    private func submitFeedback() {
        print("Feedback submitted:")
        print("Description: \(description)")
        print("Full Name: \(showFullName ? fullName : "N/A")")
        print("Phone Number: \(isContactEnabled ? phoneNumber : "N/A")")
    }
}



struct View_Reporting_Next_Previews: PreviewProvider {
    static var previews: some View {
        View_Reporting_Next()
    }
}

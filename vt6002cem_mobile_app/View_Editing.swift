import SwiftUI

struct View_Editing: View {
    var report: Report
    @EnvironmentObject var reportManager: ReportManager
    
    @State private var description: String
    @State private var isContactEnabled = true
    @State private var showFullName: Bool
    @State private var fullName: String
    @State private var phoneNumber: String
    
    // AudioControl instance
    @StateObject private var audioControl = AudioControl()
    @State private var includeAudio: Bool = false
    
    // MARK: - Init to populate the fields
    init(report: Report) {
        self.report = report
        
        _description = State(initialValue: report.description)
        
        let hadPhone = (report.phoneNumber != "" && report.phoneNumber != "N/A")
//        _isContactEnabled = true
        
        let hadFullName = (report.fullName != "" && report.fullName != "N/A")
        _showFullName = State(initialValue: hadFullName)
        
        _fullName = State(initialValue: hadFullName ? report.fullName : "")
        _phoneNumber = State(initialValue: hadPhone ? report.phoneNumber : "")
        

    }
    
    
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
            
            // 2. Record Audio Comment
            VStack(alignment: .leading, spacing: 10) {
                Text("Record a Comment")
                    .font(.headline)
                
                // Row 1: Record/Stop Button
                HStack(spacing: 15) {
                    Button(action: {
                        if audioControl.isRecording {
                            audioControl.stopRecording()
                        } else {
                            audioControl.startRecording()
                        }
                    }) {
                        HStack {
                            Image(systemName: audioControl.isRecording ? "stop.circle.fill" : "mic.circle.fill")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 24, height: 24)
                            
                            Text(audioControl.isRecording ? "Stop Recording" : "Start Recording")
                                .font(.headline)
                        }
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(audioControl.isRecording ? Color.red.opacity(0.8) : Color.blue.opacity(0.8))
                        .foregroundColor(.white)
                        .cornerRadius(8)
                    }
                }
                
                // Row 2: Play/Stop + Include Audio Toggle (only if there's a valid file)
                if audioControl.isFileValid {
                    HStack(spacing: 15) {
                        // Play/Stop Button
                        Button(action: {
                            if audioControl.isPlaying {
                                audioControl.stopPlaying()
                            } else {
                                audioControl.startPlaying()
                            }
                        }) {
                            HStack {
                                Image(systemName: audioControl.isPlaying ? "stop.circle.fill" : "play.circle.fill")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 24, height: 24)
                                
                                Text(audioControl.isPlaying ? "Stop Playing" : "Play Recording")
                                    .font(.headline)
                            }
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(audioControl.isPlaying ? Color.orange.opacity(0.8) : Color.green.opacity(0.8))
                            .foregroundColor(.white)
                            .cornerRadius(8)
                        }
                        
                        // Toggle for whether user wants to provide the audio
                        Toggle(isOn: $includeAudio) {
                            Text("Approve Audio Attachment")
                                .font(.headline)
                                .bold()
                        }
                        .toggleStyle(SwitchToggleStyle())
                        .frame(maxWidth: .infinity, alignment: .trailing)
                    }
                }
            }
            
            // 3. Contact Information Toggle
            VStack(alignment: .leading, spacing: 10) {
                Toggle(isOn: $isContactEnabled) {
                    Text("Leave Contact Information")
                        .font(.headline)
                }
                .padding()
                .background(Color.gray.opacity(0.1))
                .cornerRadius(8)
            }
            
            // 4. Full Name and Phone Number
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
                dismiss()
            }) {
                Text("Update Changes")
                    .font(.headline)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.blue.opacity(0.8))
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            
            Spacer()
        }
        .padding()
        .navigationTitle("Edit Report")
    }
    
    @Environment(\.dismiss) private var dismiss
    
    
    private func submitFeedback() {

        print("Original count: \(reportManager.reports.count)")
        
        
        var updatedReport = report
        updatedReport.description = description
        updatedReport.fullName = showFullName ? fullName : "N/A"
        updatedReport.phoneNumber = isContactEnabled ? phoneNumber : "N/A"
        
        if audioControl.isFileValid && includeAudio {
            updatedReport.audioFileURL = audioControl.getRecordingURL()
        } else {
            updatedReport.audioFileURL = nil
        }
        
        if let idx = reportManager.reports.firstIndex(where: { $0.id == report.id }) {
            reportManager.reports[idx] = updatedReport
            print("Replaced existing report at index \(idx)")
        } else {
            print("Could not find original report, appending instead.")
            reportManager.reports.append(updatedReport)
        }
        
//        reportManager.reports.append(updatedReport)
        print("Report added successfully. Total reports count: \(reportManager.reports.count)")
        
        print("Feedback submitted successfully:")
        print("Captured Images Count: \(updatedReport.capturedImages.count)")
        print("Species: \(updatedReport.species)")
        print("Latitude: \(updatedReport.latitude)")
        print("Longitude: \(updatedReport.longitude)")
        print("Selected Area: \(updatedReport.selectedArea)")
        print("Selected District: \(updatedReport.selectedDistrict)")
        print("Selected Date: \(updatedReport.selectedDate)")
        print("Description: \(updatedReport.description)")
        print("Full Name: \(updatedReport.fullName)")
        print("Phone Number: \(updatedReport.phoneNumber)")
        
        
        if let audioFileURL = updatedReport.audioFileURL {
            print("Audio File: \(audioFileURL.absoluteString)")
        } else {
            print("No audio file attached.")
        }
        
        print("Update done. Total count: \(reportManager.reports.count)")
        // Optional debug logs
        print("New Description: \(updatedReport.description)")
    }
}

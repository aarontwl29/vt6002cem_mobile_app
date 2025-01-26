import SwiftUI
import AVKit

struct TrackingReportView: View {
    @StateObject private var reportManager: ReportManager
    @StateObject private var reportViewModel: ReportViewModel
    @State private var report: Report? // Report to display
    @State private var isPlayingAudio = false
    @State private var audioPlayer: AVPlayer?
    @State private var showContactInfo = false // Toggle contact info visibility

    // Custom initializer to load the first report
    init() {
        let manager = ReportManager()
        _reportManager = StateObject(wrappedValue: manager)
        _reportViewModel = StateObject(wrappedValue: ReportViewModel(reportManager: manager))
    }

    var body: some View {
        NavigationView {
            VStack {
                if let report = report {
                    // Title and Top Button
                    HStack {
                        Text("Tracking Case")
                            .font(.title)
                            .bold()
                        Spacer()
                        Button(action: {
                            print("Lost Found tapped")
                        }) {
                            HStack(spacing: 5) {
                                Image(systemName: "checkmark.seal.fill")
                                    .font(.title3)
                                Text("Lost Found")
                                    .font(.headline)
                            }
                            .padding(10)
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(8)
                        }
                    }
                    .padding()

                    ScrollView {
                        VStack(spacing: 20) {
                            // 1. Scroll View for Images
                            if !report.capturedImages.isEmpty {
                                ScrollView(.horizontal, showsIndicators: false) {
                                    HStack(spacing: 10) {
                                        ForEach(report.capturedImages, id: \.self) { image in
                                            Image(uiImage: image)
                                                .resizable()
                                                .scaledToFit()
                                                .frame(width: 150, height: 150)
                                                .cornerRadius(10)
                                                .overlay(
                                                    RoundedRectangle(cornerRadius: 10)
                                                        .stroke(Color.gray, lineWidth: 1)
                                                )
                                        }
                                    }
                                    .padding(.horizontal)
                                }
                            } else {
                                Text("No images available")
                                    .foregroundColor(.gray)
                                    .italic()
                            }

                            // 2. Basic Information
                            Group {
                                InfoRow(title: "Type", content: report.species)
                                InfoRow(title: "Date", content: formatDate(report.selectedDate))
                            }
                            .padding(.horizontal)

                            // 3. Location Group
                            VStack(alignment: .leading, spacing: 5) {
                                Text("Location")
                                    .font(.headline)
                                    .bold()
                                Divider()
                                HStack {
                                    InfoRow(title: "Area", content: report.selectedArea)
                                    Spacer()
                                    InfoRow(title: "District", content: report.selectedDistrict)
                                }
                            }
                            .padding()

                            // 4. Description
                            InfoSection(title: "Description", content: report.description.isEmpty ? "No description provided." : report.description)

                            // 5. Voice Comment
                            if let audioURL = report.audioFileURL {
                                VStack(alignment: .leading, spacing: 5) {
                                    Text("Voice Comment")
                                        .font(.headline)
                                    Button(action: toggleAudioPlayback) {
                                        HStack {
                                            Image(systemName: isPlayingAudio ? "stop.fill" : "play.fill")
                                                .font(.title2)
                                            Text(isPlayingAudio ? "Stop" : "Play")
                                                .font(.headline)
                                        }
                                        .padding()
                                        .frame(maxWidth: .infinity)
                                        .background(Color.blue.opacity(0.8))
                                        .foregroundColor(.white)
                                        .cornerRadius(8)
                                    }
                                }
                            } else {
                                Text("No voice comment available")
                                    .foregroundColor(.gray)
                                    .italic()
                            }

                            // 6. Contact Information with Expand/Collapse
                            VStack(alignment: .leading, spacing: 5) {
                                HStack {
                                    Text("Contact Information")
                                        .font(.headline)
                                        .bold()
                                    Spacer()
                                    Button(action: {
                                        showContactInfo.toggle()
                                    }) {
                                        Image(systemName: showContactInfo ? "chevron.up" : "chevron.down")
                                            .foregroundColor(.blue)
                                    }
                                }
                                Divider()

                                if showContactInfo {
                                    InfoRow(title: "Full Name", content: report.fullName.isEmpty ? "N/A" : report.fullName)
                                    InfoRow(title: "Phone Number", content: report.phoneNumber.isEmpty ? "N/A" : report.phoneNumber)
                                }
                            }
                            .padding()
                        }
                        .padding()
                    }

                    // Circular Navigation Button at the Bottom
                   
                    Button(action: {
                        print("Start navigation tapped")
                    }) {
                        Image(systemName: "location.fill")
                            .font(.title)
                            .foregroundColor(.white)
                            .frame(width: 60, height: 60)
                            .background(Color.green)
                            .clipShape(Circle())
                            .shadow(radius: 5)
                    }
        
                } else {
                    Text("Loading report...")
                        .onAppear {
                            loadFirstReport()
                        }
                }
            }
        }
        .onAppear {
            reportViewModel.loadReports()
        }
    }

    // Helper function to format the date
    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: date)
    }

    // Helper function to load the first report
    private func loadFirstReport() {
        print("Starting to load the first report...") // Debug message
        reportViewModel.loadReports()

        DispatchQueue.main.asyncAfter(deadline: .now() + 1) { // Simulate loading time
            if let firstReport = reportManager.reports.first {
                self.report = firstReport
                print("First report loaded successfully: \(firstReport)") // Debug message
            } else {
                print("No reports found in the database.") // Debug message
            }
        }
    }

    // Toggle audio playback
    private func toggleAudioPlayback() {
        guard let url = report?.audioFileURL else { return }

        if isPlayingAudio {
            stopAudioPlayback()
        } else {
            audioPlayer = AVPlayer(url: url)
            audioPlayer?.play()
            isPlayingAudio = true
        }
    }

    // Stop audio playback
    private func stopAudioPlayback() {
        audioPlayer?.pause()
        isPlayingAudio = false
    }
}

// Subview for a single row of information
struct InfoRow: View {
    let title: String
    let content: String

    var body: some View {
        HStack {
            Text("\(title):")
                .font(.headline)
                .foregroundColor(.gray)
            Spacer()
            Text(content)
                .font(.body)
                .foregroundColor(.primary)
                .padding(.vertical, 4)
                .padding(.horizontal, 8)
                .background(Color.gray.opacity(0.1))
                .cornerRadius(8)
        }
    }
}

// Subview for grouped sections
struct InfoSection: View {
    let title: String
    let content: String

    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            Text(title)
                .font(.headline)
            Text(content)
                .font(.body)
                .padding()
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(Color.gray.opacity(0.1))
                .cornerRadius(8)
        }
    }
}

struct TrackingReportView_Previews: PreviewProvider {
    static var previews: some View {
        TrackingReportView()
    }
}

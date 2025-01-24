import SwiftUI

struct ReportDetailsView: View {
    let report: Report
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // Section 1: Multi-Image Scrolling View
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
                                            .stroke(Color.gray.opacity(0.5), lineWidth: 1)
                                    )
                            }
                        }
                        .padding(.horizontal)
                    }
                } else {
                    Text("No Images Available")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                        .padding()
                        .frame(maxWidth: .infinity, alignment: .center)
                        .background(Color.gray.opacity(0.1))
                        .cornerRadius(10)
                        .padding(.horizontal)
                }
                
                // Section 2: Description
                VStack(alignment: .leading, spacing: 10) {
                    Text("Description")
                        .font(.headline)
                        .bold()
                        .padding(.horizontal)
                    
                    TextEditor(text: .constant(report.description.isEmpty ? "No Description Provided" : report.description))
                        .frame(height: 80) // 3-4 rows for better visibility
                        .disabled(true) // Make the text editor read-only
                        .padding(8)
                        .background(Color.gray.opacity(0.1))
                        .cornerRadius(10)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.gray.opacity(0.5), lineWidth: 1)
                        )
                        .padding(.horizontal)
                }
                
                // Section 3: Comment (Sound)
                VStack(alignment: .leading, spacing: 10) {
                    Text("Comment (Audio)")
                        .font(.headline)
                        .bold()
                        .padding(.horizontal)
                    
                    if let audioFileURL = report.audioFileURL {
                        Button(action: {
                            // Logic to play the audio
                            print("Playing audio: \(audioFileURL.absoluteString)")
                        }) {
                            HStack {
                                Image(systemName: "play.circle.fill")
                                    .resizable()
                                    .frame(width: 24, height: 24)
                                    .foregroundColor(.blue)
                                Text("Play Audio")
                                    .font(.subheadline)
                                    .foregroundColor(.blue)
                            }
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.blue.opacity(0.1))
                            .cornerRadius(10)
                        }
                        .padding(.horizontal)
                    } else {
                        HStack {
                            Image(systemName: "exclamationmark.circle.fill")
                                .resizable()
                                .frame(width: 24, height: 24)
                                .foregroundColor(.blue)
                            Text("No Audio Comment Provided")
                                .font(.subheadline)
                                .foregroundColor(.gray)
                        }
                        .padding()
                        .frame(maxWidth: .infinity, alignment: .center)
                        .background(Color.gray.opacity(0.1))
                        .cornerRadius(10)
                        .padding(.horizontal)
                    }
                }
                
                // Section 4: Full Name
                VStack(alignment: .leading, spacing: 10) {
                    Text("Full Name")
                        .font(.headline)
                        .bold()
                        .padding(.horizontal)
                    
                    TextField("", text: .constant(report.fullName.isEmpty ? "No Name Provided" : report.fullName))
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .disabled(true) // Disable interaction
                        .foregroundColor(report.fullName.isEmpty ? .gray : .primary)
                        .padding(.horizontal)
                }
                
                // Section 5: Phone Number
                VStack(alignment: .leading, spacing: 10) {
                    Text("Phone Number")
                        .font(.headline)
                        .bold()
                        .padding(.horizontal)
                    
                    TextField("", text: .constant(report.phoneNumber.isEmpty ? "No Phone Number Provided" : report.phoneNumber))
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .disabled(true) // Disable interaction
                        .foregroundColor(report.phoneNumber.isEmpty ? .gray : .primary)
                        .padding(.horizontal)
                }
            }
            .padding()
        }
        .navigationTitle("Report Details")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct ReportDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        let exampleReport = Report(
            capturedImages: [UIImage(systemName: "photo")!, UIImage(systemName: "photo")!],
            species: "Wallet",
            selectedArea: "Area A",
            selectedDistrict: "District A",
            selectedDate: Date(),
            description: "A wallet was found near the park.",
            fullName: "John Doe",
            phoneNumber: "123456789",
            audioFileURL: nil // Replace with a valid URL if needed
        )
        ReportDetailsView(report: exampleReport)
    }
}

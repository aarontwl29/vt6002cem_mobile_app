import SwiftUI

// View for an individual report card
struct ReportCard: View {
    let report: Report
    let onEditTapped: () -> Void // Action for editing the report
    let onDeleteTapped: () -> Void // Action for deleting the report
    
    var body: some View {
        VStack {
            HStack {
                // Completion Status Icon
                Image(systemName: report.isFinished ? "checkmark.circle.fill" : "clock")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 24, height: 24)
                    .foregroundColor(report.isFinished ? .green : .gray)
                    .padding(.trailing, 8)
                
                
                // Image section (larger size)
                if let firstImage = report.capturedImages.first {
                    Image(uiImage: firstImage)
                        .resizable()
                        .scaledToFill()
                        .frame(width: 120, height: 100) // Larger image
                        .clipped()
                        .cornerRadius(8)
                        .padding(.trailing, 8)
                } else {
                    Image(systemName: "photo")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 100, height: 100) // Placeholder size matches the image
                        .foregroundColor(.gray)
                        .padding(.trailing, 8)
                }
                
                // Details section
                VStack(alignment: .leading, spacing: 4) {
                    Text("\(report.species)")
                        .font(.subheadline)
                        .foregroundColor(.primary)
                        .bold()
                    Text("\(report.selectedDistrict)")
                        .font(.subheadline)
                        .foregroundColor(.primary)
                    Text("\(report.selectedArea)")
                        .font(.subheadline)
                        .foregroundColor(.primary)
                    Text("\(formatDate(report.selectedDate))")
                        .font(.subheadline)
                        .foregroundColor(.primary)
                }
                
                Spacer()
                
                // Buttons section
                VStack {
                    Button(action: onEditTapped) {
                        Image(systemName: "pencil") // Edit icon
                            .resizable()
                            .scaledToFit()
                            .frame(width: 24, height: 24)
                            .padding(8)
                            .background(Color.blue.opacity(0.2))
                            .clipShape(Circle())
                    }
                    
                    Spacer()
                    
                    Button(action: onDeleteTapped) {
                        Image(systemName: "trash") // Delete icon
                            .resizable()
                            .scaledToFit()
                            .frame(width: 24, height: 24)
                            .padding(8)
                            .background(Color.red.opacity(0.2))
                            .clipShape(Circle())
                    }
                }
            }
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(10)
        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 5)
    }
    
    // Format the date to a user-readable string
    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        return formatter.string(from: date)
    }
}

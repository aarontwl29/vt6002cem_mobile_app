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





struct ResultCard: View {
    @Binding var report: Report
    let onTapDetails: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(alignment: .center, spacing: 10) { // Center-align all elements vertically
                // Checkbox for "isFavour"
                Button(action: {
                    report.isFavour.toggle() // Toggle isFavour
                }) {
                    Image(systemName: report.isFavour ? "checkmark.circle.fill" : "circle")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 24, height: 24)
                        .foregroundColor(report.isFavour ? .blue : .gray)
                }
                .frame(maxHeight: .infinity, alignment: .center) // Center-align checkbox

             
                if let firstImage = report.capturedImages.first {
                    Image(uiImage: firstImage)
                        .resizable()
                        .scaledToFill()
                        .frame(width: 80, height: 80)
                        .clipped()
                        .cornerRadius(8)
                } else {
                    Image(systemName: "photo")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 80, height: 80)
                        .foregroundColor(.gray)
                        .cornerRadius(8)
                }
                

                VStack(alignment: .leading, spacing: 4) {
                    Text(report.species)
                        .font(.subheadline)
                        .bold()
                    Text("District: \(report.selectedDistrict)")
                        .font(.subheadline)
                        .bold()
                    Text("Area: \(report.selectedArea)")
                        .font(.subheadline)
                        .bold()

                    HStack {
                        Text(formatDate(report.selectedDate))
                            .font(.subheadline)
                            .bold()

                        Spacer()

                        Button(action: onTapDetails) {
                            Text("View Details")
                                .font(.footnote)
                                .foregroundColor(.blue)
                                .underline()
                        }
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(10)
        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 5)
    }

    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        return formatter.string(from: date)
    }
}




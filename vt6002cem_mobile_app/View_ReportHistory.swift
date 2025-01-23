import SwiftUI

struct ReportView: View {
    @EnvironmentObject var reportManager: ReportManager
    
    // SAMPLE data for static records
    let records = [
        Record(id: 1, title: "Metal", subtitle: "Cleaning Recycling",
               description: "Remove non-metal parts. Empty and rinse metal containers.", imageName: "metal_icon"),
        Record(id: 2, title: "Paper", subtitle: "Cleaning Recycling",
               description: "Tear off plastic tape, remove non-paper materials and keep dry.", imageName: "paper_icon")
    ]
    
    // <<< ADDED: This state var controls the sheet for ReportFormView >>>
    @State private var showReportForm = false
    
    var body: some View {
        NavigationView {
            VStack {
                
                // <<< EXAMPLE: Combined scroll for static records plus new reports >>>
                ScrollView {
                    VStack(spacing: 16) {
                        // 1) SHOW STATIC RECORDS
                        ForEach(records) { record in
                            ReportCard(record: record)
                        }
                        
                        Divider()
                        
                        // 2) SHOW NEWLY SUBMITTED REPORTS FROM reportManager
                        ForEach(reportManager.reports.indices, id: \.self) { index in
                            // Just a simple text display or a custom UI
                            VStack(alignment: .leading, spacing: 4) {
                                Text("Species: \(reportManager.reports[index].species)")
                                    .font(.headline)
                                Text("Latitude: \(reportManager.reports[index].latitude)")
                                Text("Longitude: \(reportManager.reports[index].longitude)")
                            }
                            .padding()
                            .background(Color(.systemGray6))
                            .cornerRadius(8)
                        }
                    }
                    .padding()
                }
                
            }
            .navigationTitle("History")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    // <<< CHANGED: Instead of NavigationLink(.constant(false)), use a Button + sheet >>>
                    Button {
                        showReportForm = true
                    } label: {
                        Image(systemName: "plus")
                            .font(.title2)
                    }
                }
            }
            
            // <<< ADDED: Present the ReportFormView as a sheet >>>
            .sheet(isPresented: $showReportForm) {
                ReportFormView(isPresented: $showReportForm)
                    .environmentObject(reportManager) // Pass environment object so we can append new reports
            }
        }
    }
}

// Data model for the records (your static data)
struct Record: Identifiable {
    let id: Int
    let title: String
    let subtitle: String
    let description: String
    let imageName: String
}

// View for an individual "static" card
struct ReportCard: View {
    let record: Record
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Image(record.imageName)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 60, height: 60)
                    .cornerRadius(8)
                    .padding(.trailing, 12)
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(record.title)
                        .font(.headline)
                        .fontWeight(.bold)
                    Text(record.subtitle)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                Spacer()
            }
            Text(record.description)
                .font(.footnote)
                .foregroundColor(.gray)
                .padding(.top, 4)
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(10)
        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 5)
    }
}

struct ReportView_Previews: PreviewProvider {
    static var previews: some View {
        // Provide environmentObject for preview
        ReportView()
            .environmentObject(ReportManager())
    }
}

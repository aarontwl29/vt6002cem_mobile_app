import SwiftUI

struct ReportView: View {
    @EnvironmentObject var reportManager: ReportManager
    
    // New case
    @State private var showReportForm = false
    // Edit
    @State private var selectedReport: Report?
    @State private var showEditingView = false
    
    var body: some View {
        NavigationView {
            VStack {
                
                // Top bar: Title and Button
                HStack {
                    Text("History")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                    
                    Spacer()
                    
                    Button(action: {
                        showReportForm = true
                    }) {
                        HStack {
                            Image(systemName: "square.and.pencil")
                                .font(.title2)
                                .foregroundColor(.blue)
                        }
                        .padding(8)
                        .background(Color(.systemGray6))
                        .cornerRadius(8)
                        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
                    }
                }
                .padding(.horizontal)
                .padding(.top)
                
                
       
                ScrollView {
                    VStack(spacing: 16) {

                        // SHOW STATIC RECORDS
                        ForEach(reportManager.reports.indices, id: \.self) { index in
                            ReportCard(
                                report: reportManager.reports[index],
                                onEditTapped: {
                                    // Action for editing the report
                                    selectedReport = reportManager.reports[index]
                                    showEditingView = true
                                    print("Edit tapped for report: \(reportManager.reports[index])")
                                },
                                onDeleteTapped: {
                                    // Action for deleting the report
                                    reportManager.reports.remove(at: index)
                                    print("Report deleted.")
                                }
                            )
                        }
                    }
                    .padding()
                }
                
            }
            .sheet(isPresented: $showReportForm) {
                ReportFormView(isPresented: $showReportForm)
                    .environmentObject(reportManager) // Pass environment object so we can append new reports
            }
            .sheet(isPresented: $showEditingView) {
                if let reportToEdit = selectedReport {
                    View_Editing(report: reportToEdit)
                        .environmentObject(reportManager)
                }
            }
        }
    }

}





struct ReportView_Previews: PreviewProvider {
    static var previews: some View {
        // Provide environmentObject for preview
        ReportView()
            .environmentObject(ReportManager())
    }
}

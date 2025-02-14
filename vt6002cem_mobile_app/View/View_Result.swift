import SwiftUI

struct FindingLostResultView: View {
    @EnvironmentObject var reportManager: ReportManager
    @EnvironmentObject var findingLostViewModel: FindingLostViewModel
    var onClose: () -> Void
    
    @State private var selectedReport: Report?
    @State private var showDetailsSheet: Bool = false
    


    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                
                Spacer()
                
                Text("Search Results")
                    .font(.title)
                    .fontWeight(.bold)
                    .multilineTextAlignment(.center)
                


                
                ScrollView {
                    VStack(spacing: 16) {
                        ForEach(findingLostViewModel.matchedReports.indices, id: \.self) { index in
                            ResultCard(
                                report: $findingLostViewModel.matchedReports[index],
                                onTapDetails: {
                                    selectedReport = findingLostViewModel.matchedReports[index]
                                    showDetailsSheet = true
                                }
                            )
                        }
                    }
                    .padding(.horizontal)
                }
                
                
                Spacer()

                // Save Button
                Button(action: {
                    saveFavourites()
                    
                    onClose()
                }) {
                    Text("Save")
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.green)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .padding(.horizontal)
                
                Spacer()
                
            }
            .padding()
//            .navigationTitle("Results")
            .navigationBarTitleDisplayMode(.inline)
            .sheet(isPresented: $showDetailsSheet) {
                if let selectedReport = selectedReport {
                    ReportDetailsView(report: selectedReport)
                        .presentationDetents([.fraction(0.8)])// Pass the selected report to details view
                }
            }
            

        }
    }

    
    // Save AI-matched reports into `reportManager.reports`
    private func saveFavourites() {
        for matchedReport in findingLostViewModel.matchedReports {
            if let index = reportManager.reports.firstIndex(where: { $0.id == matchedReport.id }) {
                reportManager.reports[index] = matchedReport  // Update correctly
            } else {
                reportManager.reports.append(matchedReport)  // Append new if missing
            }
        }
    }

}




struct FindingLostResultView_Previews: PreviewProvider {
    static var previews: some View {
        FindingLostResultView(onClose: {})
            .environmentObject(ReportManager())
            .environmentObject(FindingLostViewModel())
    }
}


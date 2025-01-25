import SwiftUI

struct FindingLostResultView: View {
    @EnvironmentObject var reportManager: ReportManager
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
                        ForEach(reportManager.reports.indices, id: \.self) { index in
                            ResultCard(
                                report: $reportManager.reports[index],
                                onTapDetails: {
                                    selectedReport = reportManager.reports[index]
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
}




struct FindingLostResultView_Previews: PreviewProvider {
    static var previews: some View {
        FindingLostResultView(onClose: {})
            .environmentObject(ReportManager())
    }
}

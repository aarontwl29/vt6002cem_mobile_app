import SwiftUI
import Foundation

class ReportManager: ObservableObject {
    @Published var reports: [Report] = []
    @Published var email: String?
    
    // sameple
    init() {
        // Create and add a sample report
        let sampleReport = Report(
            capturedImages: [UIImage(named: "logo_apple")!],
            species: "Laptops",
            latitude: "22.3964° N",
            longitude: "114.1095° E",
            selectedArea: "Kowloon",
            selectedDistrict: "Yau Tsim Mong",
            selectedDate: Date(),
            description: "A plastic bottle found near the park.",
            fullName: "Aaron Tso",
            phoneNumber: "",
            isFinished: true,
            isFavour: false
        )
        
        reports.append(sampleReport)
    }
}


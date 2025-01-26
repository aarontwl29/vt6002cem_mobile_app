import SwiftUI
import Foundation

class ReportManager: ObservableObject {
    @Published var reports: [Report] = []
    @Published var email: String?
    

}


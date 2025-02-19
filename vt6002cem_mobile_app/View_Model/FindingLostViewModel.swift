import Foundation
import UIKit

class FindingLostViewModel: ObservableObject {
    
    @Published var topMatches: [(String, Double)] = [] // Stores (image URL, similarity %)
    @Published var matchedReports: [Report] = [] // Stores reports matching the images
    @Published var isSearching = false
    @Published var errorMessage: String?
    
    private let matchURL = "http://127.0.0.1:5002/match_image"
    
    func findMatchingImages(image: UIImage, reportManager: ReportManager, completion: @escaping (Bool) -> Void) {
        guard let url = URL(string: matchURL) else {
            self.errorMessage = "Invalid URL"
            completion(false)
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        let boundary = UUID().uuidString
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        var body = Data()
        
        guard let imageData = image.jpegData(compressionQuality: 0.8) else {
            self.errorMessage = "Failed to convert image"
            completion(false)
            return
        }
        
        let filename = "\(UUID().uuidString).jpg"
        
        body.append("--\(boundary)\r\n".data(using: .utf8)!)
        body.append("Content-Disposition: form-data; name=\"file\"; filename=\"\(filename)\"\r\n".data(using: .utf8)!)
        body.append("Content-Type: image/jpeg\r\n\r\n".data(using: .utf8)!)
        body.append(imageData)
        body.append("\r\n--\(boundary)--\r\n".data(using: .utf8)!)
        
        request.httpBody = body
        
        isSearching = true
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                self.isSearching = false
            }
            
            if let data = data,
               let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: [[String: Any]]],
               let matches = json["matches"] {
                
                DispatchQueue.main.async {
                    self.topMatches = matches.compactMap {
                        guard let url = $0["image"] as? String,
                              let similarity = $0["similarity"] as? Double else { return nil }
                        return (url, similarity)
                    }
                    
                    // 🔹 Find matching reports based on image URLs and filter out finished ones
                    self.findMatchingReports(reportManager: reportManager) {
                        completion(true)  // 🔹 Ensure UI updates after matches are found
                    }
                }
            } else {
                DispatchQueue.main.async {
                    self.errorMessage = "Failed to get matches"
                    completion(false)
                }
            }
        }.resume()
    }
    
    // 🔹 Function to find matching reports from local storage
    private func findMatchingReports(reportManager: ReportManager, completion: @escaping () -> Void) {
        matchedReports = [] // Clear previous results
        
        let baseURL = "http://127.0.0.1:5000/"  // Base URL for stored images

        for match in topMatches {
            let matchedUrl = match.0  // AI returned "uploads/..."
            let fullMatchedUrl = baseURL + matchedUrl  // Convert it to "http://127.0.0.1:5000/uploads/..."

            if let report = reportManager.reports.first(where: { $0.imageUrls.contains(fullMatchedUrl) && !$0.isFinished }) {
                matchedReports.append(report)
            }
        }

        completion()  // 🔹 Ensure UI updates after matches are found
    }
}

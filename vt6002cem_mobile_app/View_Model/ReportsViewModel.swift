import Foundation
import SwiftUI

class ReportViewModel: ObservableObject {
    
    // We do NOT store our own `reports` here. Instead, we reference `reportManager`
    private let reportManager: ReportManager
    
    // Base URL for Firestore "Reports" collection
    private let baseURL = "https://firestore.googleapis.com/v1/projects/vt6002cemapp/databases/(default)/documents/Reports"
    
    // Optionally track loading/error states
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    // Inject the same `ReportManager` instance
    init(reportManager: ReportManager) {
        self.reportManager = reportManager
    }
    
    // 1) Fetch from Firestore, then store in `reportManager.reports`
    func fetchReports() {
        guard let url = URL(string: baseURL) else { return }
        
        isLoading = true
        URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            DispatchQueue.main.async {
                self?.isLoading = false
            }
            
            if let error = error {
                DispatchQueue.main.async {
                    self?.errorMessage = "Fetch error: \(error.localizedDescription)"
                }
                return
            }
            guard let data = data else { return }
            
            do {
                let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
                if let documents = json?["documents"] as? [[String: Any]] {
                    var fetchedReports: [Report] = []
                    
                    for doc in documents {
                        if let fields = doc["fields"] as? [String: Any] {
                            // parse your fields
                            let species = (fields["species"] as? [String: Any])?["stringValue"] as? String ?? ""
                            let latitude = (fields["latitude"] as? [String: Any])?["stringValue"] as? String ?? ""
                            let longitude = (fields["longitude"] as? [String: Any])?["stringValue"] as? String ?? ""
                            let selectedArea = (fields["selectedArea"] as? [String: Any])?["stringValue"] as? String ?? ""
                            let selectedDistrict = (fields["selectedDistrict"] as? [String: Any])?["stringValue"] as? String ?? ""
                            let description = (fields["description"] as? [String: Any])?["stringValue"] as? String ?? ""
                            let fullName = (fields["fullName"] as? [String: Any])?["stringValue"] as? String ?? ""
                            let phoneNumber = (fields["phoneNumber"] as? [String: Any])?["stringValue"] as? String ?? ""
                            let isFinished = (fields["isFinished"] as? [String: Any])?["booleanValue"] as? Bool ?? false
                            let isFavour = (fields["isFavour"] as? [String: Any])?["booleanValue"] as? Bool ?? false
                            
                            let r = Report(
                                species: species,
                                latitude: latitude,
                                longitude: longitude,
                                selectedArea: selectedArea,
                                selectedDistrict: selectedDistrict,
                                description: description,
                                fullName: fullName,
                                phoneNumber: phoneNumber,
                                isFinished: isFinished,
                                isFavour: isFavour
                            )
                            fetchedReports.append(r)
                        }
                    }
                    
                    DispatchQueue.main.async {
                        // Overwrite local array with newly fetched data
                        self?.reportManager.reports = fetchedReports
                    }
                }
            } catch {
                DispatchQueue.main.async {
                    self?.errorMessage = "JSON decode error: \(error.localizedDescription)"
                }
            }
        }.resume()
    }
    
    // 2) Add a new doc to Firestore, then also insert it into `reportManager.reports`
    func addReport(_ report: Report, completion: @escaping (Bool) -> Void) {
        guard let url = URL(string: baseURL) else {
            completion(false)
            return
        }
        
        let body: [String: Any] = [
            "fields": [
                "species": ["stringValue": report.species],
                "latitude": ["stringValue": report.latitude],
                "longitude": ["stringValue": report.longitude],
                "selectedArea": ["stringValue": report.selectedArea],
                "selectedDistrict": ["stringValue": report.selectedDistrict],
                "selectedDate": ["timestampValue": ISO8601DateFormatter().string(from: report.selectedDate)],
                "description": ["stringValue": report.description],
                "fullName": ["stringValue": report.fullName],
                "phoneNumber": ["stringValue": report.phoneNumber],
                "capturedImages": ["arrayValue": [
                    "values": report.imageUrls.map { ["stringValue": $0] }
                ]],
                "audioFileURL": ["stringValue": report.audioFileURL ?? ""],
                "isFinished": ["booleanValue": report.isFinished],
                "isFavour": ["booleanValue": report.isFavour]
            ]
        ]
        
        guard let jsonData = try? JSONSerialization.data(withJSONObject: body) else {
            completion(false)
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        // If your Firestore rules require auth tokens, add them here:
        // request.addValue("Bearer SOME_TOKEN", forHTTPHeaderField: "Authorization")
        
        request.httpBody = jsonData
        
        isLoading = true
        URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
            DispatchQueue.main.async {
                self?.isLoading = false
            }
            guard error == nil, let httpRes = response as? HTTPURLResponse else {
                print("Error adding doc: \(error?.localizedDescription ?? "Unknown")")
                completion(false)
                return
            }
            
            if httpRes.statusCode == 200 {
                print("Document added successfully via REST!")
                DispatchQueue.main.async {
                    // Insert the new report into the local array as well
                    self?.reportManager.reports.append(report)
                }
                completion(true)
            } else {
                print("Failed to add doc. Code: \(httpRes.statusCode)")
                if let data = data {
                    let bodyStr = String(data: data, encoding: .utf8) ?? ""
                    print("Response body: \(bodyStr)")
                }
                completion(false)
            }
        }.resume()
    }
    
    // Load all reports from Firestore and download images
    func loadReports() {
        guard let url = URL(string: baseURL) else { return }
        
        isLoading = true
        URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            DispatchQueue.main.async {
                self?.isLoading = false
            }
            
            if let error = error {
                DispatchQueue.main.async {
                    self?.errorMessage = "Fetch error: \(error.localizedDescription)"
                }
                return
            }
            guard let data = data else { return }
            
            do {
                let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
                if let documents = json?["documents"] as? [[String: Any]] {
                    var fetchedReports: [Report] = []
                    
                    for doc in documents {
                        if let fields = doc["fields"] as? [String: Any] {
                            // Extract capturedImages field
                            let imageUrls = self?.extractImageUrls(from: fields["capturedImages"])
                            
                            // Build the Report object
                            let report = Report(
                                capturedImages: [], // Images will be downloaded later
                                imageUrls: imageUrls ?? [],
                                species: (fields["species"] as? [String: Any])?["stringValue"] as? String ?? "",
                                latitude: (fields["latitude"] as? [String: Any])?["stringValue"] as? String ?? "",
                                longitude: (fields["longitude"] as? [String: Any])?["stringValue"] as? String ?? "",
                                selectedArea: (fields["selectedArea"] as? [String: Any])?["stringValue"] as? String ?? "",
                                selectedDistrict: (fields["selectedDistrict"] as? [String: Any])?["stringValue"] as? String ?? "",
                                selectedDate: ISO8601DateFormatter().date(from: (fields["selectedDate"] as? [String: Any])?["timestampValue"] as? String ?? "") ?? Date(),
                                description: (fields["description"] as? [String: Any])?["stringValue"] as? String ?? "",
                                fullName: (fields["fullName"] as? [String: Any])?["stringValue"] as? String ?? "",
                                phoneNumber: (fields["phoneNumber"] as? [String: Any])?["stringValue"] as? String ?? "",
                                audioFileURL: URL(string: (fields["audioFileURL"] as? [String: Any])?["stringValue"] as? String ?? ""),
                                isFinished: (fields["isFinished"] as? [String: Any])?["booleanValue"] as? Bool ?? false,
                                isFavour: (fields["isFavour"] as? [String: Any])?["booleanValue"] as? Bool ?? false
                            )
                            fetchedReports.append(report)
                        }
                    }
                    
                    DispatchQueue.main.async {
                        self?.reportManager.reports = fetchedReports
                        self?.downloadImagesForReports()
                    }
                }
            } catch {
                DispatchQueue.main.async {
                    self?.errorMessage = "JSON decode error: \(error.localizedDescription)"
                }
            }
        }.resume()
    }
    
    // Extract image URLs from the capturedImages field
    private func extractImageUrls(from field: Any?) -> [String] {
        guard let arrayValue = field as? [String: Any],
              let values = arrayValue["arrayValue"] as? [String: Any],
              let urls = values["values"] as? [[String: Any]] else {
            return []
        }
        return urls.compactMap { $0["stringValue"] as? String }
    }
    
    
    // Download images from URLs and update `capturedImages` for each report
    private func downloadImagesForReports() {
        for (index, report) in reportManager.reports.enumerated() {
            var updatedImages: [UIImage] = []
            let group = DispatchGroup()
            
            for urlString in report.imageUrls {
                guard let url = URL(string: urlString) else { continue }
                
                group.enter()
                URLSession.shared.dataTask(with: url) { data, response, error in
                    if let data = data, let image = UIImage(data: data) {
                        updatedImages.append(image)
                    } else {
                        print("Failed to download image from URL: \(urlString)")
                    }
                    group.leave()
                }.resume()
            }
            
            group.notify(queue: .main) {
                self.reportManager.reports[index].capturedImages = updatedImages
            }
        }
    }
}




func uploadImages(images: [UIImage], completion: @escaping ([String]?) -> Void) {
    var uploadedURLs: [String] = []
    let group = DispatchGroup()
    
    
    for image in images {
        group.enter()
        uploadImage(image: image) { result in
            switch result {
            case .success(let url):
                uploadedURLs.append(url)
            case .failure(let error):
                print("Image upload failed: \(error.localizedDescription)")
            }
            group.leave()
        }
    }
    
    group.notify(queue: .main) {
        completion(uploadedURLs.isEmpty ? nil : uploadedURLs)
    }
}

func uploadImage(image: UIImage, completion: @escaping (Result<String, Error>) -> Void) {
    guard let url = URL(string: "http://127.0.0.1:5000/upload") else {
        completion(.failure(NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"])))
        return
    }
    
    var request = URLRequest(url: url)
    request.httpMethod = "POST"
    
    let boundary = UUID().uuidString
    request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
    
    var body = Data()
    
    // Auto-generate filename using UUID
    let uniqueFilename = "\(UUID().uuidString).jpg"
    
    let imageData = image.jpegData(compressionQuality: 0.8)!
    body.append("--\(boundary)\r\n".data(using: .utf8)!)
    body.append("Content-Disposition: form-data; name=\"file\"; filename=\"\(uniqueFilename)\"\r\n".data(using: .utf8)!)
    
    body.append("Content-Type: image/jpeg\r\n\r\n".data(using: .utf8)!)
    body.append(imageData)
    body.append("\r\n--\(boundary)--\r\n".data(using: .utf8)!)
    request.httpBody = body
    
    URLSession.shared.dataTask(with: request) { data, response, error in
        if let error = error {
            completion(.failure(error))
            return
        }
        
        guard let data = data,
              let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: String],
              let url = json["url"] else {
            completion(.failure(NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Invalid response"])))
            return
        }
        
        completion(.success(url))
    }.resume()
}




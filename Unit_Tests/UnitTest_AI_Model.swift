import XCTest
import UIKit

class AIModelTests: XCTestCase {

    let matchURL = "http://127.0.0.1:5002/match_image"

    func testImageMatching() {
        let expectation = self.expectation(description: "Matching image with AI model")

        // Load image from Assets
        guard let image = UIImage(named: "UnitTest_image") else {
            XCTFail("❌ Image not found in Assets")
            return
        }

        guard let url = URL(string: matchURL) else {
            XCTFail("❌ Invalid AI server URL")
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"

        let boundary = UUID().uuidString
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")

        var body = Data()

        guard let imageData = image.jpegData(compressionQuality: 0.9) else {
            XCTFail("❌ Failed to convert image to JPEG data")
            return
        }

        let filename = "test_image.jpg"

        body.append("--\(boundary)\r\n".data(using: .utf8)!)
        body.append("Content-Disposition: form-data; name=\"file\"; filename=\"\(filename)\"\r\n".data(using: .utf8)!)
        body.append("Content-Type: image/jpeg\r\n\r\n".data(using: .utf8)!)
        body.append(imageData)
        body.append("\r\n--\(boundary)--\r\n".data(using: .utf8)!)

        request.httpBody = body

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            XCTAssertNil(error, "❌ Request failed: \(error?.localizedDescription ?? "Unknown error")")

            guard let data = data,
                  let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                  let matches = json["matches"] as? [[String: Any]] else {
                XCTFail("❌ Failed to parse AI model response")
                expectation.fulfill()
                return
            }

            XCTAssertFalse(matches.isEmpty, "❌ No matches found. Ensure the AI model has images to compare.")

            print("AI Model Response: \(matches)")

            expectation.fulfill()
        }
        task.resume()

        wait(for: [expectation], timeout: 10.0)
    }
}

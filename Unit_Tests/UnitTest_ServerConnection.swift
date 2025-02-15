import XCTest

class ServerConnectionTests: XCTestCase {
    
    let baseURL = "http://127.0.0.1:5000"

    // Test if the server is running by making a simple request
    func testServerIsRunning() {
        let expectation = self.expectation(description: "Server should respond")
        let url = URL(string: "\(baseURL)/uploads")!

        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            XCTAssertNil(error, "❌ Server is not running or not reachable!")
            if let httpResponse = response as? HTTPURLResponse {
                XCTAssertEqual(httpResponse.statusCode, 404, "❌ Server is running but route may not exist")
            }
            expectation.fulfill()
        }
        task.resume()
        wait(for: [expectation], timeout: 5.0)
    }

    // Test if the upload endpoint (`/upload`) is accessible
    func testUploadEndpoint() {
        let expectation = self.expectation(description: "Upload endpoint should be accessible")
        let url = URL(string: "\(baseURL)/upload")!
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            XCTAssertNil(error, "❌ Upload endpoint not reachable!")
            if let httpResponse = response as? HTTPURLResponse {
                XCTAssertEqual(httpResponse.statusCode, 400, "❌ Upload endpoint reachable (Expected 400 Bad Request without file)")
            }
            expectation.fulfill()
        }
        task.resume()
        wait(for: [expectation], timeout: 5.0)
    }

    // Test if an audio file can be retrieved from `/uploads/audio/sample.mp3`
    func testAudioFileRetrieval() {
        let expectation = self.expectation(description: "Audio file should be retrievable")
        let audioURL = URL(string: "\(baseURL)/uploads/audio/sample_announcement.mp3")!

        let task = URLSession.shared.dataTask(with: audioURL) { data, response, error in
            XCTAssertNil(error, "❌ Audio file request failed!")
            if let httpResponse = response as? HTTPURLResponse {
                if httpResponse.statusCode == 200 {
                    XCTAssertNotNil(data, "Audio file exists and is downloadable")
                } else {
                    XCTAssertEqual(httpResponse.statusCode, 404, "❌ Audio file not found on server")
                }
            }
            expectation.fulfill()
        }
        task.resume()
        wait(for: [expectation], timeout: 5.0)
    }
}

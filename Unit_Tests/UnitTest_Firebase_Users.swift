import XCTest

class UserDatabaseTests: XCTestCase {
    
    let baseURL = "https://firestore.googleapis.com/v1/projects/vt6002cemapp/databases/(default)/documents/Users"
    let testEmail = "ABC@email.com"
    let testFullName = "Anonymous"
    let initialPassword = "ABC123"
    let updatedPassword = "DEF456"
    
    // Create a new user record
    func testCreateUser() {
        let expectation = self.expectation(description: "Create user in Firestore")
        
        let url = URL(string: baseURL)!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let userData: [String: Any] = [
            "fields": [
                "email": ["stringValue": testEmail],
                "fullName": ["stringValue": testFullName],
                "password": ["stringValue": initialPassword]
            ]
        ]
        
        request.httpBody = try? JSONSerialization.data(withJSONObject: userData, options: [])
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            XCTAssertNil(error, "❌ Failed to create user!")
            if let httpResponse = response as? HTTPURLResponse {
                XCTAssertEqual(httpResponse.statusCode, 200, "User created successfully")
            }
            expectation.fulfill()
        }
        task.resume()
        wait(for: [expectation], timeout: 5.0)
    }
    
    // Query user by Email & Password
    func testQueryUser() {
        let expectation = self.expectation(description: "Query user from Firestore")
        
        let url = URL(string: baseURL)!
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            XCTAssertNil(error, "❌ Failed to query Firestore")
            guard let data = data,
                  let jsonResponse = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                  let documents = jsonResponse["documents"] as? [[String: Any]] else {
                XCTFail("❌ Failed to parse response")
                expectation.fulfill()
                return
            }
            
            let matchedUsers = documents.filter { doc in
                if let fields = doc["fields"] as? [String: Any],
                   let email = fields["email"] as? [String: Any],
                   let password = fields["password"] as? [String: Any],
                   email["stringValue"] as? String == self.testEmail,
                   password["stringValue"] as? String == self.initialPassword {
                    return true
                }
                return false
            }
            
            XCTAssertEqual(matchedUsers.count, 1, "Found 1 user with matching email and password")
            expectation.fulfill()
        }
        task.resume()
        wait(for: [expectation], timeout: 5.0)
    }
    
    // Update User Password
    func testUpdateUserPassword() {
        let expectation = self.expectation(description: "Update user password in Firestore")
        
        // 🔹 Fetch all users
        let url = URL(string: baseURL)!
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data,
                  let jsonResponse = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                  let documents = jsonResponse["documents"] as? [[String: Any]] else {
                XCTFail("❌ Failed to fetch users")
                expectation.fulfill()
                return
            }
            
            // 🔹 **Find the document with matching email**
            guard let matchingUser = documents.first(where: { doc in
                if let fields = doc["fields"] as? [String: Any],
                   let email = fields["email"] as? [String: Any],
                   email["stringValue"] as? String == self.testEmail {
                    return true
                }
                return false
            }), let documentPath = matchingUser["name"] as? String else {
                XCTFail("❌ No matching user found")
                expectation.fulfill()
                return
            }
            
            print("Found user: \(documentPath)")
            
            
            let updateURL = URL(string: "https://firestore.googleapis.com/v1/\(documentPath)?updateMask.fieldPaths=password")!
            var request = URLRequest(url: updateURL)
            request.httpMethod = "PATCH"
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            
            let updateData: [String: Any] = [
                "fields": [
                    "password": ["stringValue": self.updatedPassword]
                ]
            ]
            request.httpBody = try? JSONSerialization.data(withJSONObject: updateData, options: [])
            
            URLSession.shared.dataTask(with: request) { _, updateResponse, updateError in
                XCTAssertNil(updateError, "❌ Failed to update password")
                if let httpResponse = updateResponse as? HTTPURLResponse {
                    XCTAssertEqual(httpResponse.statusCode, 200, "Password updated successfully")
                }
                expectation.fulfill()
            }.resume()
        }.resume()
        
        wait(for: [expectation], timeout: 5.0)
    }
    
    // Delete User By Email
    func testDeleteUser() {
        let expectation = self.expectation(description: "Delete user from Firestore")
        
        let url = URL(string: baseURL)!
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            XCTAssertNil(error, "❌ Failed to query Firestore")
            guard let data = data,
                  let jsonResponse = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                  let documents = jsonResponse["documents"] as? [[String: Any]] else {
                XCTFail("❌ Failed to parse response")
                expectation.fulfill()
                return
            }
            
            // 🔹 **Find the document with matching email & password**
            guard let matchingUser = documents.first(where: { doc in
                if let fields = doc["fields"] as? [String: Any],
                   let email = fields["email"] as? [String: Any],
                   let password = fields["password"] as? [String: Any],
                   email["stringValue"] as? String == self.testEmail,
                   password["stringValue"] as? String == self.updatedPassword {
                    return true
                }
                return false
            }), let documentPath = matchingUser["name"] as? String else {
                XCTFail("❌ No matching user found for deletion")
                expectation.fulfill()
                return
            }
            
            print("Found user to delete: \(documentPath)")
            
            let deleteURL = URL(string: "https://firestore.googleapis.com/v1/\(documentPath)")!
            var request = URLRequest(url: deleteURL)
            request.httpMethod = "DELETE"
            
            let deleteTask = URLSession.shared.dataTask(with: request) { deleteData, deleteResponse, deleteError in
                XCTAssertNil(deleteError, "❌ Failed to delete user")
                
                if let httpResponse = deleteResponse as? HTTPURLResponse {
                    if httpResponse.statusCode == 200 {
                        print("User deleted successfully")
                    } else {
                        XCTFail("❌ Failed to delete user - Status Code: \(httpResponse.statusCode)")
                    }
                }
                expectation.fulfill()
            }
            deleteTask.resume()
        }
        task.resume()
        wait(for: [expectation], timeout: 5.0)
    }
    
}

import Foundation

class AuthManager {
    let baseURL = "https://firestore.googleapis.com/v1/projects/vt6002cemapp/databases/(default)/documents/Users"
    
    // MARK: - Register User
    func registerUser(email: String, fullName: String, password: String, completion: @escaping (Bool, String?) -> Void) {
        guard let url = URL(string: baseURL) else {
            completion(false, "Invalid URL")
            return
        }
        
        // Prepare the data for the new user
        let userData: [String: Any] = [
            "fields": [
                "email": ["stringValue": email],
                "fullName": ["stringValue": fullName],
                "password": ["stringValue": password]
            ]
        ]
        
        // Convert user data to JSON
        guard let jsonData = try? JSONSerialization.data(withJSONObject: userData) else {
            completion(false, "Failed to encode user data")
            return
        }
        
        // Create the request
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = jsonData
        
        // Execute the request
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(false, error.localizedDescription)
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                completion(false, "Failed to register user")
                return
            }
            
            completion(true, nil)
        }.resume()
    }
    
    // MARK: - Login User
    func loginUser(email: String, password: String, completion: @escaping (Bool, String?) -> Void) {
        guard let url = URL(string: baseURL) else {
            completion(false, "Invalid URL")
            return
        }
        
        // Fetch all users to verify login credentials
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(false, error.localizedDescription)
                return
            }
            
            guard let data = data,
                  let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
                  let documents = json["documents"] as? [[String: Any]] else {
                completion(false, "Failed to parse user data")
                return
            }
            
            // Check if the provided email and password match any user
            for document in documents {
                if let fields = document["fields"] as? [String: Any],
                   let emailField = fields["email"] as? [String: Any],
                   let storedEmail = emailField["stringValue"] as? String,
                   let passwordField = fields["password"] as? [String: Any],
                   let storedPassword = passwordField["stringValue"] as? String,
                   storedEmail == email, storedPassword == password {
                    completion(true, nil)
                    return
                }
            }
            
            completion(false, "Invalid email or password")
        }.resume()
    }
}

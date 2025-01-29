import Foundation

class User: Identifiable, Codable {
    var id: String
    var email: String
    var fullName: String
    var phone: String
    
    init(id: String = UUID().uuidString, email: String, fullName: String, phone: String) {
        self.id = id
        self.email = email
        self.fullName = fullName
        self.phone = phone
    }
}

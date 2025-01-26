import Foundation

class User: Identifiable {
    var id: String
    var email: String
    var fullName: String
    var password: String
    var phone: String

    init(id: String = UUID().uuidString, email: String, fullName: String, password: String, phone: String) {
        self.id = id
        self.email = email
        self.fullName = fullName
        self.password = password
        self.phone = phone
    }
}

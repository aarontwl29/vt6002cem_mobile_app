import Foundation

class AppSettings {
    private static let loginKey = "isLoggedIn"
    private static let darkModeKey = "isDarkMode"
    private static let userKey = "userData" // Store the entire User object as JSON

    // MARK: - Login State
    static func setLoggedIn(_ status: Bool) {
        UserDefaults.standard.set(status, forKey: loginKey)
    }

    static func isLoggedIn() -> Bool {
        return UserDefaults.standard.bool(forKey: loginKey)
    }

    // MARK: - Dark Mode
    static func setDarkMode(_ enabled: Bool) {
        UserDefaults.standard.set(enabled, forKey: darkModeKey)
    }

    static func isDarkMode() -> Bool {
        return UserDefaults.standard.bool(forKey: darkModeKey)
    }

    // MARK: - User Details
    static func saveUser(_ user: User) {
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(user) {
            UserDefaults.standard.set(encoded, forKey: userKey)
        }
    }

    static func getUser() -> User {
        let decoder = JSONDecoder()
        if let userData = UserDefaults.standard.data(forKey: userKey),
           let user = try? decoder.decode(User.self, from: userData) {
            return user
        }
        // Return a default user if none is stored
        return User(email: "noemail@example.com", fullName: "Unknown User", phone: "N/A")
    }

    static func clearUser() {
        UserDefaults.standard.removeObject(forKey: userKey)
    }
}

import SwiftUI
import CoreLocation

class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    private let locationManager = CLLocationManager()
    
    @Published var latitude: String = "Latitude: Not Available"
    @Published var longitude: String = "Longitude: Not Available"

    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
    }
    
    func requestLocation() {
        if CLLocationManager.locationServicesEnabled() {
            locationManager.requestLocation()
        } else {
            latitude = "Location Services Disabled"
            longitude = "Enable Location Services"
        }
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            latitude = "Latitude: \(location.coordinate.latitude)"
            longitude = "Longitude: \(location.coordinate.longitude)"
        }
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Failed to find user's location: \(error.localizedDescription)")
    }
}



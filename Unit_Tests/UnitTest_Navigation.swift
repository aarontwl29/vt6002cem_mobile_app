import CoreLocation
import XCTest
import MapKit

@testable import vt6002cem_mobile_app


class MockLocationManager: CLLocationManager {
    var mockLocation: CLLocation?

    override var location: CLLocation? {
        return mockLocation
    }
}

class NavigationTests: XCTestCase {

    var directionsRequest: MKDirections.Request!
    var locationManager: MockLocationManager!

    override func setUp() {
        super.setUp()
        
        locationManager = MockLocationManager()
        
        // Setup Mock Directions Request (From HK to HK Central)
        let startLocation = MKPlacemark(coordinate: CLLocationCoordinate2D(latitude: 22.3193, longitude: 114.1694)) // Hong Kong
        let destination = MKPlacemark(coordinate: CLLocationCoordinate2D(latitude: 22.2855, longitude: 114.1577)) // HK Central

        directionsRequest = MKDirections.Request()
        directionsRequest.source = MKMapItem(placemark: startLocation)
        directionsRequest.destination = MKMapItem(placemark: destination)
        directionsRequest.transportType = .automobile
    }
    
    // Test Fetching Mocked GPS Location
    func testFetchLocation() {
        let mockLocation = CLLocation(latitude: 22.3193, longitude: 114.1694) 
        locationManager.mockLocation = mockLocation
        
        let fetchedLocation = locationManager.location
        
        XCTAssertEqual(fetchedLocation?.coordinate.latitude, 22.3193, "Latitude does not match")
        XCTAssertEqual(fetchedLocation?.coordinate.longitude, 114.1694, "Longitude does not match")
    }

    // Test Route Calculation
    func testCalculateRoute() {
        let directions = MKDirections(request: directionsRequest)
        let expectation = self.expectation(description: "Route calculation")
        
        directions.calculate { response, error in
            XCTAssertNotNil(response, "Response should not be nil")
            XCTAssertNil(error, "Error should be nil")
            XCTAssertGreaterThan(response?.routes.count ?? 0, 0, "No routes found")
            
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 5, handler: nil)
    }
}

import Foundation
import UIKit

struct Report {
    let id = UUID()
    
    var capturedImages: [UIImage] = []
    var imageUrls: [String] = [] 
    var species: String = "Select Item"
    var latitude: String = "Latitude: N/A"
    var longitude: String = "Longitude: N/A"
    var selectedArea: String = "Select Area"
    var selectedDistrict: String = "Select District"
    var selectedDate: Date = Date()
    
    var description: String = ""
    var fullName: String = ""
    var phoneNumber: String = ""
    var audioFileURL: URL? = nil

    var isFinished: Bool = false
    var isFavour: Bool = false
}


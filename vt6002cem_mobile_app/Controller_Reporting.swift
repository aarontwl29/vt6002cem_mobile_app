import Foundation
import SwiftUI
import UIKit

class Controller_Reporting: ObservableObject {
    
    func addPhoto() {
        print("Add Photo functionality goes here.")
    }
    
    func getLocation(completion: @escaping (String, String) -> Void) {
        // Simulate fetching location
        completion("Latitude: 22.3193", "Longitude: 114.1694")
    }
    
    func getCurrentDateTime(completion: @escaping (Date) -> Void) {
        completion(Date())
    }
}




struct CameraCaptureView: UIViewControllerRepresentable {
    @Binding var isShown: Bool
    @Binding var image: UIImage?

    func makeCoordinator() -> Coordinator {
        return Coordinator(isShown: $isShown, image: $image)
    }

    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.delegate = context.coordinator
        picker.sourceType = .camera
        return picker
    }

    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}

    class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
        @Binding var isShown: Bool
        @Binding var image: UIImage?

        init(isShown: Binding<Bool>, image: Binding<UIImage?>) {
            _isShown = isShown
            _image = image
        }

        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
            if let selectedImage = info[.originalImage] as? UIImage {
                image = selectedImage // Store the captured image
            }
            isShown = false // Dismiss the camera
        }

        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            isShown = false // Dismiss the camera
        }
    }
}



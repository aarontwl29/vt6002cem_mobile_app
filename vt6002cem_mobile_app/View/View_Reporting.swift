import SwiftUI
import PhotosUI

struct ReportFormView: View {
    
    @StateObject private var controller = Controller_Reporting()
    @State private var showCamera = false
    @State private var capturedImages: [UIImage] = []
    @State private var selectedPhotos: [PhotosPickerItem] = []
    
    @StateObject private var locationManager = LocationManager()
    
    @State private var showNextSheet = false
    
    //others
    @State private var species: String = "Select Item"
    
    @State private var selectedArea: String = "Select Area"
    @State private var selectedDistrict: String = "Select District"
    @State private var selectedDate = Date() // For current date and time
    
    
    @Binding var isPresented: Bool // Binding to control the sheet dismissal
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    
                    // Display Captured Images
                    if !capturedImages.isEmpty {
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 10) {
                                ForEach(capturedImages, id: \.self) { image in
                                    Image(uiImage: image)
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 100, height: 100)
                                        .cornerRadius(8)
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 8)
                                                .stroke(Color.gray, lineWidth: 1)
                                        )
                                }
                            }
                            .padding(.horizontal)
                        }
                    } else {
                        Text("No Images Added")
                            .foregroundColor(.gray)
                            .padding()
                    }
                    
                    
                    // Camera and Add Photos Buttons in the Same Row
                    HStack(spacing: 15) {
                        
                        Button(action: {
                            showCamera = true
                        }) {
                            HStack {
                                Image(systemName: "camera.fill")
                                    .font(.headline)
                                Text("Take Photo")
                                    .font(.headline)
                            }
                            .padding()
                            .background(Color.blue.opacity(0.8))
                            .foregroundColor(.white)
                            .cornerRadius(8)
                        }
                        
                        // Photos Picker (multiple selection)
                        PhotosPicker(
                            selection: $selectedPhotos,
                            maxSelectionCount: 10,          // <-- Set your max selection count
                            matching: .images,
                            photoLibrary: .shared()
                        ) {
                            HStack {
                                Image(systemName: "photo.fill")
                                    .font(.headline)
                                Text("Select Photos")
                                    .font(.headline)
                            }
                            .padding()
                            .background(Color.green.opacity(0.8))
                            .foregroundColor(.white)
                            .cornerRadius(8)
                        }
                        // As soon as new items are selected, load them into UIImages
                        .onChange(of: selectedPhotos) { newItems in
                            Task {
                                for item in newItems {
                                    if let data = try? await item.loadTransferable(type: Data.self),
                                       let uiImage = UIImage(data: data) {
                                        // Append each new image to your existing list
                                        capturedImages.append(uiImage)
                                    }
                                }
                                // Clear the selection if you like, or leave them in `selectedPhotos`
                                selectedPhotos.removeAll()
                            }
                        }
                        
                    }
                    // End of camera and photos
                    
                    // 2. Species Dropdown
                    VStack(alignment: .leading, spacing: 5) {
                        Text("Item Type")
                            .font(.headline)
                        Menu {
                            ForEach(speciesOptions, id: \.self) { item in
                                Button(action: {
                                    species = item
                                }) {
                                    Text(item)
                                }
                            }
                        } label: {
                            HStack {
                                Text(species)
                                    .foregroundColor(.primary)
                                Spacer()
                                Image(systemName: "chevron.down")
                                    .foregroundColor(.gray)
                            }
                            .padding()
                            .background(Color.gray.opacity(0.1))
                            .cornerRadius(8)
                        }
                    }
                    
                    // 3. Location Result + Get Location Button in the Same Row
                    HStack(spacing: 15) {
                        // Longitude and Latitude Display
                        VStack(alignment: .leading, spacing: 10) {
                            // Latitude
                            VStack(alignment: .leading, spacing: 5) {
                                Text(locationManager.latitude)
                                    .font(.headline)
                                    .foregroundColor(.black)
                            }
                            .padding()
                            .background(Color.gray.opacity(0.1))
                            .cornerRadius(8)
                            
                            // Longitude
                            VStack(alignment: .leading, spacing: 5) {
                                Text(locationManager.longitude)
                                    .font(.headline)
                                    .foregroundColor(.black)
                            }
                            .padding()
                            .background(Color.gray.opacity(0.1))
                            .cornerRadius(8)
                        }
                        .frame(maxWidth: .infinity)
                        
                        // Get Current Location Button
                        Button(action: {
                            locationManager.requestLocation()
                            print("Get Location tapped")
                            
                            
                            selectedArea = "New Territories"
                            districtOptions = areaDistrictMapping[selectedArea] ?? [] // Update district options
                            selectedDistrict = "Sha Tin"
                        }) {
                            HStack {
                                Image(systemName: "location.circle.fill") // Location icon
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 20, height: 20)
                                Text("Current\nLocation")
                                    .font(.headline)
                                    .multilineTextAlignment(.center)
                            }
                            .padding()
                            .frame(width: 130, height: 80) // Larger button size
                            .background(Color.orange.opacity(0.8))
                            .foregroundColor(.white)
                            .cornerRadius(10)
                        }
                    }
                    .padding(.horizontal)
                    
                    
                    // 4. Area and District Dropdown in the Same Row
                    HStack(spacing: 5) {
                        // Area Dropdown
                        VStack(alignment: .leading, spacing: 5) {
                            Text("Area")
                                .font(.headline)
                            Menu {
                                ForEach(areaDistrictMapping.keys.sorted(), id: \.self) { area in
                                    Button(action: {
                                        selectedArea = area
                                        districtOptions = areaDistrictMapping[area] ?? [] // Update districts
                                        selectedDistrict = "Select District" // Reset district selection
                                    }) {
                                        Text(area)
                                    }
                                }
                            } label: {
                                HStack {
                                    Text(selectedArea)
                                        .foregroundColor(.primary)
                                    Spacer()
                                    Image(systemName: "chevron.down")
                                        .foregroundColor(.gray)
                                }
                                .padding()
                                .background(Color.gray.opacity(0.1))
                                .cornerRadius(8)
                            }
                        }
                        
                        // District Dropdown
                        VStack(alignment: .leading, spacing: 5) {
                            Text("District")
                                .font(.headline)
                            Menu {
                                ForEach(districtOptions, id: \.self) { district in
                                    Button(action: {
                                        selectedDistrict = district
                                    }) {
                                        Text(district)
                                    }
                                }
                            } label: {
                                HStack {
                                    Text(selectedDistrict)
                                        .foregroundColor(.primary)
                                    Spacer()
                                    Image(systemName: "chevron.down")
                                        .foregroundColor(.gray)
                                }
                                .padding()
                                .background(Color.gray.opacity(0.1))
                                .cornerRadius(8)
                            }
                        }
                    }
                    
                    
                    // 5. Date and Time Input + Get Current Date Button
                    VStack(alignment: .leading, spacing: 10) {
                        
                        
                        HStack(spacing: 0) {
                            // Date Display
                            HStack {
                                Text("Date:")
                                    .font(.subheadline)
                                    .foregroundColor(.black)
                                DatePicker("", selection: Binding(
                                    get: { selectedDate },
                                    set: { newValue in
                                        selectedDate = newValue
                                        print("Date updated: \(formatDate(selectedDate))") // Log local time
                                    }
                                ), displayedComponents: .date)
                                .labelsHidden()
                                .background(
                                    RoundedRectangle(cornerRadius: 8)
                                        .fill(Color.gray.opacity(0.1))
                                        .frame(height: 36)
                                )
                            }
                            
                            Spacer()
                            
                            // Time Display
                            HStack {
                                Text("Time:")
                                    .font(.subheadline)
                                    .foregroundColor(.black)
                                DatePicker("", selection: Binding(
                                    get: { selectedDate },
                                    set: { newValue in
                                        selectedDate = newValue
                                        print("Time updated: \(formatDate(selectedDate))") // Log local time
                                    }
                                ), displayedComponents: .hourAndMinute)
                                .labelsHidden()
                                .background(
                                    RoundedRectangle(cornerRadius: 8)
                                        .fill(Color.gray.opacity(0.1))
                                        .frame(height: 36)
                                )
                            }
                        }
                        .padding(.horizontal)
                    }
                    
                    
                    // Next Button
                    Button(action: {
                        showNextSheet = true // Trigger the sheet
                    }) {
                        Text("Next")
                            .font(.headline)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.blue.opacity(0.8))
                            .foregroundColor(.white)
                            .cornerRadius(10)
                            .padding(.horizontal)
                    }
                }
                .padding()
            }
            .navigationTitle("Report Case")
            .sheet(isPresented: $showCamera) {
                CameraCaptureView(isShown: $showCamera, image: Binding(
                    get: { nil }, // This is temporary for binding
                    set: { newImage in
                        if let image = newImage {
                            capturedImages.append(image) // Add new image to the array
                        }
                    }
                ))
            }
            .sheet(isPresented: $showNextSheet) {
                
                let report = Report(
                    capturedImages: capturedImages,
                    species: species,
                    latitude: locationManager.latitude,
                    longitude: locationManager.longitude,
                    selectedArea: selectedArea,
                    selectedDistrict: selectedDistrict,
                    selectedDate: selectedDate
                )
                View_Reporting_Next(report: report, dismissAllSheets: {
                    dismissAllSheets()
                })
                .presentationDragIndicator(.visible) // Optional drag indicator
            }
            
        }
    }
    
    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        formatter.timeZone = .current // Use the user's current time zone
        return formatter.string(from: date)
    }
    
    // A helper to fully dismiss *both* sheets
    private func dismissAllSheets() {
        // Close the "Next" sheet
        showNextSheet = false
        // Close this entire form sheet
        isPresented = false
    }
    
    
    // Options for Dropdowns
    private let speciesOptions = [
        "Wallets", "Keys", "Mobile phones", "Laptops",
        "Identification documents", "Credit cards",
        "Headphones or earbuds", "Bags", "Jewelry", "Eyewear"
    ]
    
    
    private let areaDistrictMapping: [String: [String]] = [
        "Hong Kong": ["Central and Western", "Wan Chai", "Eastern", "Southern"],
        "Kowloon": ["Yau Tsim Mong", "Sham Shui Po", "Kowloon City", "Wong Tai Sin", "Kwun Tong"],
        "New Territories": ["Kwai Tsing", "Tsuen Wan", "Tuen Mun", "Yuen Long", "North", "Tai Po", "Sha Tin", "Sai Kung", "Islands"]
    ]
    @State private var districtOptions: [String] = []  // Dynamic district options based on selected area
}



struct ReportFormView_Previews: PreviewProvider {
    static var previews: some View {
        ReportFormView(isPresented: .constant(true)).environmentObject(ReportManager())
    }
}




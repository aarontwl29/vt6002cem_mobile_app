import SwiftUI

struct ReportFormView: View {

    @StateObject private var controller = Controller_Reporting()
    @State private var showCamera = false
    @State private var capturedImages: [UIImage] = [] 

    
    @State private var selectedPhoto: UIImage? = nil
    @State private var species: String = "Select Item"
    @State private var latitude: String = "Latitude: N/A"
    @State private var longitude: String = "Longitude: N/A"
    @State private var selectedArea: String = "Select Area"
    @State private var selectedDistrict: String = "Select District"
    @State private var selectedDate = Date() // For current date and time

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
                    
                    
                    
                    // 1. Camera and Add Photos Buttons in the Same Row
                    HStack(spacing: 15) {
                        Button(action: {
                            showCamera = true
                        }) {
                            HStack {
                                Image(systemName: "camera.fill")
                                    .font(.headline)
                                Text("Camera")
                                    .font(.headline)
                            }
                            .padding()
                            .background(Color.blue.opacity(0.8))
                            .foregroundColor(.white)
                            .cornerRadius(8)
                        }

                     
                        
                        
                        Button(action: {
                            print("Add Photos tapped")
                        }) {
                            HStack {
                                Image(systemName: "photo.fill")
                                    .font(.headline)
                                Text("Add Photos")
                                    .font(.headline)
                            }
                            .padding()
                            .background(Color.green.opacity(0.8))
                            .foregroundColor(.white)
                            .cornerRadius(8)
                        }
                    }

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
                    HStack {
                        VStack(alignment: .leading) {
                            Text(latitude)
                                .font(.subheadline)
                                .foregroundColor(.gray)
                            Text(longitude)
                                .font(.subheadline)
                                .foregroundColor(.gray)
                        }
                        Spacer()

                        Button(action: {
                            latitude = "Latitude: 22.3193"
                            longitude = "Longitude: 114.1694"
                            print("Get Location tapped")
                        }) {
                            Text("Get Location")
                                .font(.headline)
                                .padding()
                                .background(Color.orange.opacity(0.8))
                                .foregroundColor(.white)
                                .cornerRadius(8)
                        }
                    }

                    // 4. Area and District Dropdown in the Same Row
                    HStack(spacing: 15) {
                        VStack(alignment: .leading, spacing: 5) {
                            Text("Area")
                                .font(.headline)
                            Menu {
                                ForEach(areaOptions, id: \.self) { area in
                                    Button(action: {
                                        selectedArea = area
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
                        Text("Time of Incident")
                            .font(.headline)

                        HStack(spacing: 15) {
                            DatePicker("Date", selection: $selectedDate, displayedComponents: .date)
                                .labelsHidden()

                            DatePicker("Time", selection: $selectedDate, displayedComponents: .hourAndMinute)
                                .labelsHidden()

                            
                        }
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
        }
    }

    // Options for Dropdowns
    private let speciesOptions = [
        "Wallets", "Keys", "Mobile phones", "Laptops",
        "Identification documents", "Credit cards",
        "Headphones or earbuds", "Bags", "Jewelry", "Eyewear"
    ]

    private let areaOptions = ["Area 1", "Area 2", "Area 3", "Area 4"]
    private let districtOptions = ["District A", "District B", "District C", "District D"]
}

struct ReportFormView_Previews: PreviewProvider {
    static var previews: some View {
        ReportFormView()
    }
}





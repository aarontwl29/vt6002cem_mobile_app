import SwiftUI
import PhotosUI

struct FindingLostView: View {
    
    @State private var capturedImage: UIImage?
    @State private var selectedPhotos: [PhotosPickerItem] = []
    @State private var species: String = "Select Item"
    
    @State private var selectedArea: String = "Select Area"
    @State private var selectedDistrict: String = "Select District"
    @State private var districtOptions: [String] = []
    
    @State private var selectedDate = Date()
    @State private var startTime = Date()
    @State private var endTime = Date()
    
    
    @State private var isLoading: Bool = false
    @State private var showResult: Bool = false
    
    var body: some View {
        ZStack {
            NavigationView {
                ScrollView {
                    VStack(spacing: 20) {
                        // Title
                        Text("Finding Lost")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.horizontal)
                        
                        // Display selected image or placeholder
                        if let image = capturedImage {
                            Image(uiImage: image)
                                .resizable()
                                .scaledToFit()
                                .frame(height: 150)
                                .cornerRadius(10)
                                .padding(.horizontal)
                        } else {
                            Text("No Image Selected")
                                .font(.subheadline)
                                .foregroundColor(.gray)
                                .frame(height: 150)
                                .frame(maxWidth: .infinity)
                                .background(Color.gray.opacity(0.1))
                                .cornerRadius(10)
                                .padding(.horizontal)
                        }
                        
                        // Upload Image Button
                        PhotosPicker(selection: $selectedPhotos, matching: .images) {
                            HStack {
                                Image(systemName: "photo.on.rectangle")
                                Text("Upload Image")
                            }
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                        }
                        .padding(.horizontal)
                        .onChange(of: selectedPhotos) { newItems in
                            Task {
                                for item in newItems {
                                    if let data = try? await item.loadTransferable(type: Data.self),
                                       let uiImage = UIImage(data: data) {
                                        capturedImage = uiImage
                                    }
                                }
                            }
                        }
                        
                        // Item Type (species) Dropdown
                        VStack(alignment: .leading) {
                            Text("Item Type")
                                .font(.headline)
                                .padding(.horizontal)
                            
                            Menu {
                                ForEach(speciesOptions, id: \.self) { item in
                                    Button(item) {
                                        species = item
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
                                .cornerRadius(10)
                                .padding(.horizontal)
                            }
                        }
                        
                        // Area + District
                        HStack(spacing: 10) {
                            VStack(alignment: .leading) {
                                Text("Area").font(.headline)
                                Menu {
                                    ForEach(areaDistrictMapping.keys.sorted(), id: \.self) { area in
                                        Button(area) {
                                            print("User picked area: \(area)")
                                            selectedArea = area
                                            districtOptions = areaDistrictMapping[area] ?? []
                                            selectedDistrict = "Select District"
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
                                    .cornerRadius(10)
                                }
                            }
                            
                            VStack(alignment: .leading) {
                                Text("District").font(.headline)
                                Menu {
                                    ForEach(districtOptions, id: \.self) { district in
                                        Button(district) {
                                            selectedDistrict = district
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
                                    .cornerRadius(10)
                                }
                            }
                        }
                        .padding(.horizontal)
                        
                        // Date Picker
                        VStack(alignment: .leading) {
                            Text("Date")
                                .font(.headline)
                                .padding(.horizontal)
                            DatePicker("", selection: $selectedDate, displayedComponents: .date)
                                .labelsHidden()
                                .datePickerStyle(.graphical)
                                .frame(maxWidth: .infinity)
                                .padding(.horizontal)
                        }
                        
                        // Time Range
                        HStack(spacing: 10) {
                            VStack(alignment: .leading) {
                                Text("Start Time")
                                    .font(.headline)
                                DatePicker("", selection: $startTime, displayedComponents: .hourAndMinute)
                                    .labelsHidden()
                                    .padding()
                                    .background(Color.gray.opacity(0.1))
                                    .cornerRadius(10)
                            }
                            VStack(alignment: .leading) {
                                Text("End Time")
                                    .font(.headline)
                                DatePicker("", selection: $endTime, displayedComponents: .hourAndMinute)
                                    .labelsHidden()
                                    .padding()
                                    .background(Color.gray.opacity(0.1))
                                    .cornerRadius(10)
                            }
                        }
                        .padding(.horizontal)
                        
                        Divider()
                        
                        // Search Button
                        Button {
                            startSearch()
                        } label: {
                            Text("Search")
                                .font(.headline)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.green)
                                .foregroundColor(.white)
                                .cornerRadius(10)
                        }
                        .padding(.horizontal)
                        .frame(width: UIScreen.main.bounds.width * 0.6)
                        
                        Spacer()
                    }
                    .padding(.top)
                }
            }
            
            // Loading Overlay
            if isLoading {
                Color.black.opacity(0.3)
                    .ignoresSafeArea()
                VStack(spacing: 20) {
                    ProgressView("Searching...")
                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.black.opacity(0.7))
                        .cornerRadius(12)
                }
            }
        }
        .sheet(isPresented: $showResult, onDismiss: {
            // Optionally do something after dismiss
        }) {
            FindingLostResultView(
                onClose: {
                    // Called when user taps "Try Again" or "Save"
                    resetForm()
                    showResult = false
                }
            )
        }
    }
    
    
    private func startSearch() {
        print("Search pressed with details:")
        print("Species: \(species), Area: \(selectedArea), District: \(selectedDistrict)")
        print("Date: \(selectedDate)")
        print("Time range: \(startTime) to \(endTime)")
        
        isLoading = true
  
        Task {
            try? await Task.sleep(nanoseconds: 2_000_000_000)
            isLoading = false
            showResult = true
        }
    }
    
    private func resetForm() {
        capturedImage = nil
        selectedPhotos.removeAll()
        species = "Select Item"
        selectedArea = "Select Area"
        selectedDistrict = "Select District"
        districtOptions = []
        selectedDate = Date()
        startTime = Date()
        endTime = Date()
    }
    
    // Dropdown options
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
}


struct FindingLostView_Previews: PreviewProvider {
    static var previews: some View {
        FindingLostView()
    }
}

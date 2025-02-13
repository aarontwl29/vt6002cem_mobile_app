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
    
    // Loading + Sheets
    @State private var isLoading: Bool = false
    
    // Two booleans for two different sheets
    @State private var showResult: Bool = false
    @State private var showNoResults: Bool = false
    
    // Testing
    @StateObject private var findingLostViewModel = FindingLostViewModel()
    @EnvironmentObject var reportManager: ReportManager
    // Testing
    
    var body: some View {
        ZStack {
            NavigationView {
                ScrollView {
                    VStack(spacing: 20) {
                        
                        
                        // Testing
                        // Test AI Image Upload Button
                        Button("Find Matching Cases") {
                            if let image = capturedImage {
                                findingLostViewModel.findMatchingImages(image: image, reportManager: reportManager) { success in
                                    if success {
                                        print("✅ AI Matching completed! Check console for URLs.")
                                    } else {
                                        print("❌ AI Matching failed!")
                                    }
                                }
                            }
                        }
                        .disabled(capturedImage == nil)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.green)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                        
                        // 🔹 Display Matched Reports' Descriptions
                        if !findingLostViewModel.matchedReports.isEmpty {
                            Text("Matched Reports")
                                .font(.headline)
                                .padding(.top)
                            
                            ForEach(findingLostViewModel.matchedReports, id: \.id) { report in
                                VStack(alignment: .leading) {
                                    Text("📄 \(report.description)")
                                        .font(.body)
                                        .padding(5)
                                        .background(Color.gray.opacity(0.2))
                                        .cornerRadius(10)
                                }
                                .padding(.horizontal)
                            }
                        }
                        
                        // Testing
                        
                        
                        
                        
                        
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
                        
                        // Item Type Dropdown
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
                                            selectedArea = area
                                            districtOptions = areaDistrictMapping[area] ?? []
                                            selectedDistrict = "Select District"
                                        }
                                    }
                                } label: {
                                    HStack {
                                        Text(selectedArea).foregroundColor(.primary)
                                        Spacer()
                                        Image(systemName: "chevron.down").foregroundColor(.gray)
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
                                        Text(selectedDistrict).foregroundColor(.primary)
                                        Spacer()
                                        Image(systemName: "chevron.down").foregroundColor(.gray)
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
                                Text("Start Time").font(.headline)
                                DatePicker("", selection: $startTime, displayedComponents: .hourAndMinute)
                                    .labelsHidden()
                                    .padding()
                                    .background(Color.gray.opacity(0.1))
                                    .cornerRadius(10)
                            }
                            VStack(alignment: .leading) {
                                Text("End Time").font(.headline)
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
            

            if isLoading {
                Color.black.opacity(0.3).ignoresSafeArea()
                VStack(spacing: 20) {
                    ProgressView("Matching...")
                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.black.opacity(0.7))
                        .cornerRadius(12)
                }
            }
        }
        .sheet(isPresented: $showNoResults) {
            NoResultsView(onTryAgain: {
                resetForm()
                showNoResults = false
            })
            .presentationDetents([.fraction(0.5)])
        }
        .sheet(isPresented: $showResult) {
            FindingLostResultView(onClose: {
                resetForm()
                showResult = false
            })
            .presentationDetents([.large]) // or .fraction(0.9) or .height(500)
        }
    }
    
    private func startSearch() {
        print("Search pressed with details:")
        print("Species: \(species), Area: \(selectedArea), District: \(selectedDistrict)")
        print("Date: \(selectedDate)")
        print("Time range: \(startTime) to \(endTime)")
        
        isLoading = true
        
        Task {
            try? await Task.sleep(nanoseconds: 1_000_000_000) 
            isLoading = false
            
            if capturedImage == nil {
                showNoResults = true
            } else {
                showResult = true
            }
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
    
    private let speciesOptions = [
        "Wallets", "Keys", "Mobile phones", "Laptops",
        "Identification documents", "Credit cards",
        "Headphones or earbuds", "Bags", "Jewelry", "Eyewear"
    ]
    
    private let areaDistrictMapping: [String: [String]] = [
        "Hong Kong": ["Central and Western", "Wan Chai", "Eastern", "Southern"],
        "Kowloon": ["Yau Tsim Mong", "Sham Shui Po", "Kowloon City", "Wong Tai Sin", "Kwun Tong"],
        "New Territories": ["Kwai Tsing", "Tsuen Wan", "Tuen Mun", "Yuen Long", "North", "Tai Po",
                            "Sha Tin", "Sai Kung", "Islands"]
    ]
}

struct FindingLostView_Previews: PreviewProvider {
    static var previews: some View {
        FindingLostView()
    }
}

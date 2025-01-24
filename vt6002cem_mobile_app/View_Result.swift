import SwiftUI

struct FindingLostResultView: View {
    
    // HIGHLIGHT: A closure we call to dismiss & reset
    var onClose: () -> Void
    
    // Example repeating results (dummy data)
    let dummyResults = [
        "Found item near District A",
        "Found item near District B",
        "Found item near District C"
    ]
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                Text("Search Results")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                
                ScrollView {
                    VStack(spacing: 16) {
                        ForEach(dummyResults, id: \.self) { result in
                            HStack {
                                Image(systemName: "magnifyingglass")
                                    .foregroundColor(.blue)
                                Text(result)
                                    .font(.headline)
                            }
                            .padding()
                            .background(Color.gray.opacity(0.1))
                            .cornerRadius(8)
                        }
                    }
                    .padding(.horizontal)
                }
                
                Spacer()
                
                HStack {
                    Button(action: {
                        // "Try Again" => reset form & close sheet
                        onClose()
                    }) {
                        Text("Try Again")
                            .font(.headline)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.orange)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                    
                    Button(action: {
                        // "Save" => maybe save to server, then close
                        onClose()
                    }) {
                        Text("Save")
                            .font(.headline)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.green)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                }
                .padding(.horizontal)
                
                Spacer()
            }
            .padding()
            // Title at top
            .navigationTitle("Results")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

// Preview
struct FindingLostResultView_Previews: PreviewProvider {
    static var previews: some View {
        FindingLostResultView(onClose: {})
    }
}

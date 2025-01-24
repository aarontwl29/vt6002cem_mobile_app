import SwiftUI

struct FindingLostResultView: View {
    // Called when user taps "Try Again" or "Save"
    var onClose: () -> Void
    
    // Example results
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
                                Image(systemName: "doc.text.magnifyingglass")
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
                
                // Buttons row
                HStack {
                    
                    Button(action: {
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
            .navigationTitle("Results")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

struct FindingLostResultView_Previews: PreviewProvider {
    static var previews: some View {
        FindingLostResultView(onClose: {})
    }
}

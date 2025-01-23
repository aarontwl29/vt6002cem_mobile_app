import SwiftUI

struct ReportView: View {
    // Sample data for the records
    let records = [
        Record(id: 1, title: "Metal", subtitle: "Cleaning Recycling", description: "Remove non-metal parts. Empty and rinse metal containers.", imageName: "metal_icon"),
        Record(id: 2, title: "Paper", subtitle: "Cleaning Recycling", description: "Tear off plastic tape, remove non-paper materials and keep dry.", imageName: "paper_icon"),

    ]
    
    var body: some View {
        NavigationView {
            VStack {
                ScrollView {
                    VStack(spacing: 16) {
                        ForEach(records) { record in
                            ReportCard(record: record)
                        }
                    }
                    .padding()
                }
            }
            .navigationTitle("Recycling") // Title at the top
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        // Add action for the "Add" button here
                        print("Add new case tapped")
                    }) {
                        Image(systemName: "plus")
                            .font(.title2)
                    }
                }
            }
        }
    }
}

// Data model for the records
struct Record: Identifiable {
    let id: Int
    let title: String
    let subtitle: String
    let description: String
    let imageName: String
}

// View for an individual card
struct ReportCard: View {
    let record: Record
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Image(record.imageName)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 60, height: 60)
                    .cornerRadius(8)
                    .padding(.trailing, 12)
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(record.title)
                        .font(.headline)
                        .fontWeight(.bold)
                    Text(record.subtitle)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                Spacer()
            }
            Text(record.description)
                .font(.footnote)
                .foregroundColor(.gray)
                .padding(.top, 4)
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(10)
        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 5)
    }
}

struct ReportView_Previews: PreviewProvider {
    static var previews: some View {
        ReportView()
    }
}

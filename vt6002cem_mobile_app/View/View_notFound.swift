import SwiftUI

struct NoResultsView: View {
    var onTryAgain: () -> Void
    
    var body: some View {
        VStack(spacing: 20) {
            
            Spacer()
            
            Image(systemName: "magnifyingglass.circle.fill")
                .resizable()
                .scaledToFit()
                .frame(width: 100, height: 100)
                .foregroundColor(.gray)
            
            Text("No Results Found")
                .font(.title2)
                .fontWeight(.bold)
                .multilineTextAlignment(.center)
            
            Text("Maybe pick an image or try different search inputs.")
                .font(.body)
                .foregroundColor(.gray)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
            
            Button(action: onTryAgain) {
                HStack {
                    Image(systemName: "arrow.clockwise")
                        .font(.title)
                    Text("Try Again")
                        .font(.headline)
                }
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color.red.opacity(0.8))
                .foregroundColor(.white)
                .cornerRadius(10)
            }
            .padding(.horizontal)
            .frame(width: UIScreen.main.bounds.width * 0.6)
            
            Spacer()
        }
        .padding()
  
    }
}

struct NoResultsView_Previews: PreviewProvider {
    static var previews: some View {
        NoResultsView(onTryAgain: { })
    }
}

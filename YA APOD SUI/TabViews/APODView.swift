import SwiftUI

struct APODView: View {
    
    @State private var currAPOD: APODInstance = APODInstance.loading
    @State private var currImage: UIImage = UIImage(named: "nasa-logo.svg")!
    
    @State private var isFavorite: Bool = false
    @ViewBuilder
    var likeButton: some View {
        Button {
            isFavorite = !isFavorite
        } label: {
            Image(systemName: isFavorite ? "suit.heart.fill" : "suit.heart")
                .foregroundColor(.primary)
        }
    }
    
    var body: some View {
        NavigationStack {
            VStack {
                Text(currAPOD.title)
                    .font(.title2)
                    .bold()
                    .multilineTextAlignment(.center)
                
                ZoomableImage(zoomImage: currImage)
                    .zIndex(10)
                
                Text("\(currAPOD.date), \(currAPOD.copyright ?? "no copyright").")
                    .font(.caption)
                
                ScrollView {
                    Text(currAPOD.explanation)
                        .font(.body)
                        .padding()
                        .multilineTextAlignment(.center)
                }
                
                Spacer()
            }
            .navigationTitle("Astronomic Picture Of the Day")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    likeButton
                }
            }
            .onAppear {
                Task {
                    if currAPOD.date == "1900-01-01" {
                        (currAPOD, currImage) = try await fetchImageOfTheDay()
                    }
                }
            }
        }
    }
    
    func fetchImageOfTheDay() async throws -> (APODInstance, UIImage) {
        
        var currentAPODOfTheDay: APODInstance
        var currentImageOfTheDay: UIImage
        
        let (apodData, _) = try await URLSession.shared.data(from: URL(string: "\(AppConstants.NASA.defaultNASAUrl)?api_key=\(AppConstants.NASA.myAPIKEY)")!)
        
        currentAPODOfTheDay = try JSONDecoder().decode(APODInstance.self, from: apodData)
        print("Image of the day (APOD): ", currentAPODOfTheDay)
        
        let (imageData, _) = try await URLSession.shared.data(from: URL(string: currentAPODOfTheDay.url)!)
        currentImageOfTheDay = UIImage(data: imageData) ?? UIImage(systemName: "square.and.arrow.up.trianglebadge.exclamationmark")!
        print("Image of the day (DATA): ", imageData)
        
        return (currentAPODOfTheDay, currentImageOfTheDay)
    }
}

struct APODView_Previews: PreviewProvider {
    static var previews: some View {
        APODView()
    }
}

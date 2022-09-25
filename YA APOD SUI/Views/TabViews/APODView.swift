import SwiftUI

struct APODView: View {
    
    @State private var currAPOD: APODInstance = APODInstance.loading
    @State private var currImage: UIImage? = nil //UIImage(named: "nasa-logo.svg")!
    
    @Environment(\.managedObjectContext) private var viewContext
    
    @State private var isFavorite: Bool = false
    @ViewBuilder var likeButton: some View {
        Button {
            if !isFavorite {
                isFavorite = true
                let newItem = Item(context: viewContext)
                newItem.timestamp = Date()
                newItem.title = currAPOD.title
                newItem.image = currImage!.pngData()
                
                do {
                    try viewContext.save()
                    print("Image saved to CoreData: \(currAPOD.title).")
                } catch {
                    print(error.localizedDescription)
                }
            }
        } label: {
            Image(systemName: isFavorite ? "suit.heart.fill" : "suit.heart")
                .foregroundColor(.primary)
        }
    }
    
    var body: some View {
        NavigationStack {
            ScrollView {
                Text(currAPOD.title)
                    .font(.title2)
                    .bold()
                    .multilineTextAlignment(.center)
                
                if currImage == nil {
                    Spacer()
                    
                    Image(uiImage: UIImage(named: "nasa-logo.svg")!)
                        .resizable()
                        .scaledToFit()
                    
                    Spacer()
                    ProgressView()
                    Spacer()
                } else {
                    ZoomableImage(zoomImage: currImage!)
                        .zIndex(10)
                }
                Text("\(currAPOD.date), \(currAPOD.copyright ?? "no copyright").")
                    .font(.caption)
                
                Text(currAPOD.explanation)
                    .font(.body)
                    .padding()
                    .multilineTextAlignment(.center)
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
                    if currAPOD.date == "Houstone" {
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
        
        let (imageData, _) = try await URLSession.shared.data(from: URL(string: currentAPODOfTheDay.url)!)
        currentImageOfTheDay = UIImage(data: imageData) ?? UIImage(systemName: "square.and.arrow.up.trianglebadge.exclamationmark")!
        
        return (currentAPODOfTheDay, currentImageOfTheDay)
    }
}

struct APODView_Previews: PreviewProvider {
    static var previews: some View {
        APODView()
    }
}

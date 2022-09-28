import SwiftUI

struct APODView: View {
    
    @AppStorage("userAPIKey") var userAPIKey: String = "DEMO_KEY"
    @AppStorage("newLikedImages") var newLikedImages: Int = 0
    @EnvironmentObject var appPrefs: AppPrefs

    @State private var currAPOD: APODInstance = APODInstance.loading
    @State private var currImage: UIImage? = nil
    
    @Environment(\.managedObjectContext) private var viewContext
    
    @State private var isFavorite: Bool = false
    @ViewBuilder var likeButton: some View {
        Button {
            if !isFavorite {
                isFavorite = true
                let newItem = Item(context: viewContext)
                newItem.timestamp = Date()
                newItem.title = currAPOD.title
                newItem.copyright = currAPOD.copyright
                newItem.explanation = currAPOD.explanation
                newItem.media_type = currAPOD.media_type
                newItem.url = currAPOD.url
                newItem.hdurl = currAPOD.hdurl
                newItem.image = currImage!.pngData()
                
                do {
                    try viewContext.save()
                    print("Image saved to CoreData: \(currAPOD.title).")
                    newLikedImages += 1
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
                    .textSelection(.enabled)
                    .padding(.top)
                
                if currImage == nil {
                    Spacer()
                    
                    Image(uiImage: UIImage(named: AppConstants.NASA.defaultNASALogo)!)
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
                    .textSelection(.enabled)
            }
            .navigationTitle("Astronomic Picture Of the Day")
            .navigationBarTitleDisplayMode(.inline)
            .toolbarColorScheme(.dark, for: .navigationBar)
            .toolbarBackground(AppConstants.NASA.blueColor, for: .navigationBar)
            .toolbarBackground(.visible, for: .navigationBar)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    likeButton
                }
            }
            .onAppear {
                UITabBar.appearance().barTintColor = .red
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
        
        let (apodData, response) = try await URLSession.shared.data(from: URL(string: "\(AppConstants.NASA.defaultNASAUrl)?api_key=\(userAPIKey)")!)
        
        if let response = response as? HTTPURLResponse {
            if let limit = response.value(forHTTPHeaderField: "X-RateLimit-Limit") {
                appPrefs.requestLimit = limit
            }
            if let remaining = response.value(forHTTPHeaderField: "X-RateLimit-Remaining") {
                appPrefs.requestRemaining = remaining
            }
        }
        
        currentAPODOfTheDay = try JSONDecoder().decode(APODInstance.self, from: apodData)
        
        let (imageData, _) = try await URLSession.shared.data(from: URL(string: currentAPODOfTheDay.url)!)
        currentImageOfTheDay = UIImage(data: imageData) ?? UIImage(systemName: "square.and.arrow.up.trianglebadge.exclamationmark")!
        
        return (currentAPODOfTheDay, currentImageOfTheDay)
    }
}

struct APODView_Previews: PreviewProvider {
    static var previews: some View {
        APODView()
            .environmentObject(AppPrefs())
    }
}

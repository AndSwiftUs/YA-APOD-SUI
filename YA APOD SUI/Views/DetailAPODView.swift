import Foundation
import SwiftUI

struct DetailAPODView: View {
    
    @AppStorage("newLikedImages") var newLikedImages: Int = 0
    @AppStorage("isHapticFeedback") var isHapticFeedback: Bool = true
    @Environment(\.managedObjectContext) private var viewContext
    
    let apod: APODInstance
    let image: UIImage
    
    @State private var isFavorite: Bool = false
    @ViewBuilder
    var likeButton: some View {
        Button {
            if !isFavorite {
                isFavorite = true
                let newItem = Item(context: viewContext)
                newItem.timestamp = Date()
                newItem.title = apod.title
                newItem.copyright = apod.copyright
                newItem.explanation = apod.explanation
                newItem.media_type = apod.media_type
                newItem.url = apod.url
                newItem.hdurl = apod.hdurl
                newItem.image = image.pngData()
                
                do {
                    try viewContext.save()
                    print("Image saved to CoreData: \(apod.title).")
                    newLikedImages += 1
                    if isHapticFeedback { UIImpactFeedbackGenerator(style: .medium).impactOccurred() }
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
        
        Text("\(apod.title)")
            .font(.title2)
            .bold()
            .multilineTextAlignment(.center)
            .textSelection(.enabled)
            .padding(.top)
        
        if apod.media_type == "image" {
            ZoomableImage(zoomImage: image)
                .zIndex(10)
        } else {
            YoutubeVideoView(youtubeVideoID: apod.url)
        }
        
        Text("\(apod.date), \(apod.copyright ?? "no copyright").")
        
        ScrollView {
            
            Text(apod.explanation)
                .font(.body)
                .padding()
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbarColorScheme(.dark, for: .navigationBar)
        .toolbarBackground(AppConstants.NASA.blueColor, for: .navigationBar)
        .toolbarBackground(.visible, for: .navigationBar)
        .toolbar {
            if apod.media_type == "image" {
                ToolbarItem(placement: .navigationBarTrailing) {
                    likeButton
                }
            }
        }
    }
}

struct DetailAPODView_Previews: PreviewProvider {
    static var previews: some View {
        DetailAPODView(apod: APODInstance.dummy, image: UIImage(named: "nasa-logo.svg")!)
    }
}

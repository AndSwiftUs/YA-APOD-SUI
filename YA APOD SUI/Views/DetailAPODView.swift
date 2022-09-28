import Foundation
import SwiftUI

struct DetailAPODView: View {
    
    @AppStorage("newLikedImages") var newLikedImages: Int = 0
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
        
        ScrollView {
            
            Text("\(apod.title)")
            
            ZoomableImage(zoomImage: image)
                .zIndex(10)
            
            Text("\(apod.date), \(apod.copyright ?? "no copyright").")
            
            Text(apod.explanation)
                .font(.body)
                .padding()            
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbarColorScheme(.dark, for: .navigationBar)
        .toolbarBackground(AppConstants.NASA.blueColor, for: .navigationBar)
        .toolbarBackground(.visible, for: .navigationBar)        
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                likeButton
            }
        }
    }
}

struct DetailAPODView_Previews: PreviewProvider {
    static var previews: some View {
        DetailAPODView(apod: APODInstance.dummy, image: UIImage(named: "nasa-logo.svg")!)
    }
}

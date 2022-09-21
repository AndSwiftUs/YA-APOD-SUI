import Foundation
import SwiftUI

struct DetailAPODView: View {
    
    let apod: APODInstance
    let image: UIImage
    
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
        
        VStack {
                        
            Text("\(apod.title)")

            ZoomableImage(zoomImage: image)
                .zIndex(10)

            Text("\(apod.date), \(apod.copyright ?? "no copyright").")
            
            ScrollView {
                Text(apod.explanation)
                    .font(.body)
                    .padding()
            }
            
            Spacer()
        }
        .navigationBarTitleDisplayMode(.inline)
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

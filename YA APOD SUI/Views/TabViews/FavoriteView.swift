import SwiftUI

struct FavoriteView: View {
    
    @Environment(\.managedObjectContext) private var viewContext
    
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Item.timestamp, ascending: false)],
        animation: .default)
    
    var items: FetchedResults<Item>
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(items) { item in
                    ZoomableImage(zoomImage: UIImage(data: item.image!)!)
                        .overlay(ImageOverlay(title: item.title!), alignment: .bottomTrailing)
                        .swipeActions(edge: .leading) {
                            Button {
                                guard let inputImage = UIImage(data: item.image!) else { return }

                                let imageSaver = ImageToPhotoLibrarySaver()
                                imageSaver.writeToPhotoAlbum(image: inputImage)
                                
                            } label: {
                                Label("Save\nto gallery", systemImage: "photo")
                            }
                        }
                        .tint(.blue)
                }
                .onDelete { indexSet in
                    for index in indexSet {
                        viewContext.delete(items[index])
                    }
                    do {
                        try viewContext.save()
                    } catch {
                        print(error.localizedDescription)
                    }
                }
            }
            .listStyle(.inset)
            .navigationTitle("Faforite images")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    EditButton()
                }
            }
        }
    }
}

struct ImageOverlay: View {
    
    var title: String
    
    var body: some View {
        ZStack {
            Text(title)
                .font(.caption2)
                .padding(6)
                .foregroundColor(.white)
        }
        .background(Color.black)
        .opacity(0.8)
        .cornerRadius(10.0)
        .padding(6)
    }
}

//struct FavoriteView_Previews: PreviewProvider {
//    static var previews: some View {
//        FavoriteView()
//    }
//}

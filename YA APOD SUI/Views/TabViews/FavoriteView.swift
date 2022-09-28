import SwiftUI

struct FavoriteView: View {
    
    @AppStorage("newLikedImages") var newLikedImages: Int = 0

    @State private var isSaveOKAlertPresented = false
    @State private var seachText = ""
    
    @Environment(\.managedObjectContext) private var viewContext
    
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Item.timestamp, ascending: false)],
        animation: .default)
    
    var items: FetchedResults<Item>
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(items) { item in
                    if (seachText == "") || item.title!.contains(seachText) {
                        ZoomableImage(zoomImage: UIImage(data: item.image!)!)
                            .overlay(ImageOverlay(title: item.title!), alignment: .bottomTrailing)
                            .swipeActions(edge: .leading) {
                                Button {
                                    guard let inputImage = UIImage(data: item.image!) else { return }
                                    
                                    let imageSaver = ImageToPhotoLibrarySaver()
                                    imageSaver.writeToPhotoAlbum(image: inputImage)
                                    isSaveOKAlertPresented = true
                                    
                                } label: {
                                    Label("Save\nto gallery", systemImage: "photo")
                                }
                            }
                            .tint(.blue)
                            .alert(isPresented: $isSaveOKAlertPresented) {
                                Alert(title: Text("Image saved to gallery."),
                                      dismissButton: .default(Text("OK"))
                                )
                            }
                    }
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
            .navigationBarTitleDisplayMode(.inline)
            .toolbarColorScheme(.dark, for: .navigationBar)
            .toolbarBackground(AppConstants.NASA.greenColor, for: .navigationBar)
            .toolbarBackground(.visible, for: .navigationBar)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    EditButton()
                }
            }
            .searchable(text: $seachText, prompt: "Nebula Star Galaxy Hole Sun")
            .onAppear {
                newLikedImages = 0
            }
            .accentColor(.red)
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

struct FavoriteView_Previews: PreviewProvider {
    static var previews: some View {
        FavoriteView()
    }
}

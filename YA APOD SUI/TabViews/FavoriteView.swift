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
                    VStack {
                        ZoomableImage(zoomImage: UIImage(data: item.image!)!)
                        Text(item.title!)
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
            .navigationTitle("Faforite images")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    EditButton()
                }
            }
        }
    }
}

struct FavoriteView_Previews: PreviewProvider {
    static var previews: some View {
        FavoriteView()
    }
}

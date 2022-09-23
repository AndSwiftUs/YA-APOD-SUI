import SwiftUI

struct MainView: View {
    
    @Environment(\.managedObjectContext) private var viewContext
    
    var body: some View {
        TabView {
            APODView()
                .tabItem {
                    Image(systemName: "globe")
                    Text("APOD")
                }
            
            SearchView()
                .tabItem {
                    Image(systemName: "photo.on.rectangle.angled")
                    Text("Search")
                }
            
            FavoriteView()
                .tabItem {
                    Image(systemName: "suit.heart")
                    Text("Liked")
                }
            
            SettingsView()
                .tabItem {
                    Image(systemName: "person.circle")
                    Text("Settings")
                }
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}

import SwiftUI

struct MainView: View {
    
    @Environment(\.managedObjectContext) private var viewContext
    
    var appPrefs = AppPrefs()
    
    var body: some View {
        TabView {
            APODView()
                .tabItem {
                    Image(systemName: "globe")
                    Text("APOD")
                }
                .environmentObject(appPrefs)
            
            SearchView()
                .tabItem {
                    Image(systemName: "photo.on.rectangle.angled")
                    Text("Search")
                }
                .environmentObject(appPrefs)
            
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
                .environmentObject(appPrefs)
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}

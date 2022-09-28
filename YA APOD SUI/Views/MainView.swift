import SwiftUI

struct MainView: View {
    
    @Environment(\.managedObjectContext) private var viewContext
    @AppStorage("userAPIKey") var userAPIKey: String = "DEMO_KEY"
    @AppStorage("newLikedImages") var newLikedImages: Int = 0
    
    var appPrefs = AppPrefs()
    
    var body: some View {
        TabView {
            APODView()
                .tabItem {
                    Label("APOD", systemImage: "globe")
                }
                .environmentObject(appPrefs)
            
            SearchView()
                .tabItem {
                    Label("Search", systemImage: "photo.on.rectangle.angled")
                }
                .environmentObject(appPrefs)
            
            FavoriteView()
                .badge(newLikedImages != 0 ? "\(newLikedImages)" : nil)
                .tabItem {
                    Label("Liked", systemImage: "suit.heart")
                }
            
            SettingsView()
                .badge(userAPIKey == "DEMO_KEY" ? "!" : nil)
                .tabItem {
                    Label("Settings", systemImage: "gear")
                }
                .environmentObject(appPrefs)
        }
        .accentColor(AppConstants.NASA.blueColor)
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}

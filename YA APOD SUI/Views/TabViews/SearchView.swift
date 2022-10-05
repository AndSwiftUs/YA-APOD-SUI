import SwiftUI

struct SearchView: View {
    
    @AppStorage("countOfRandomAPODs") var countOfRandomAPODs: Int = 8
    @AppStorage("searchGridLayoutState") var searchGridLayoutState: Int = 1
    @AppStorage("userAPIKey") var userAPIKey: String = "DEMO_KEY"
    @AppStorage("isHapticFeedback") var isHapticFeedback: Bool = true
    @EnvironmentObject var appPrefs: AppPrefs
    
    @State private var apods: [APODInstance] = []
    @State private var apodsImages: [APODInstance : UIImage] = [ : ]
    
    @State private var gridLayout: [GridItem] = [GridItem()]
    
    @ViewBuilder
    var reloadButton: some View {
        Button {
            Task {
                try await fetchAPODS(count: countOfRandomAPODs)
                try await fetchAPODSImagesInCache()
            }
        } label: {
            Image(systemName: "repeat.circle")
                .foregroundColor(.primary)
        }
    }
    
    @ViewBuilder
    var gridButton: some View {
        Button {
            if searchGridLayoutState < 3 {
                searchGridLayoutState += 1 } else { searchGridLayoutState = 1 }
            self.gridLayout = Array(repeating: .init(.flexible()), count: searchGridLayoutState)
            if isHapticFeedback { UIImpactFeedbackGenerator(style: .medium).impactOccurred() }
        } label: {
            Image(systemName: "square.grid.2x2")
                .foregroundColor(.primary)
        }
    }
    
    @ViewBuilder
    var gridView: some View {
        LazyVGrid(columns: gridLayout) {
            ForEach(apods, id: \.self) { apod in
                NavigationLink(destination: DetailAPODView(apod: apod, image: apodsImages[apod] ?? UIImage(named: AppConstants.NASA.defaultNASALoading)!)) {
                    VStack {
                        Image(uiImage: apodsImages[apod] ?? UIImage(named: AppConstants.NASA.defaultNASALoading)!)
                            .resizable()
                            .scaledToFill()
                            .frame(minWidth: 0, maxWidth: .infinity)
                            .frame(height: searchGridLayoutState == 1 ? 200 : 100)
                            .cornerRadius(10)
                            .shadow(radius: 2)
                        Text(apod.title)
                            .font(.caption)
                    }
                }
            }
        }
        .padding(10)
        .animation(.easeInOut, value: searchGridLayoutState)
    }
    
    var body: some View {
        NavigationStack {
            ScrollView {
                Divider()
                gridView
                Divider()
            }
            .navigationTitle("\(countOfRandomAPODs) random images of the day")
            .navigationBarTitleDisplayMode(.inline)
            .toolbarColorScheme(.dark, for: .navigationBar)
            .toolbarBackground(AppConstants.NASA.blueColor, for: .navigationBar)
            .toolbarBackground(.visible, for: .navigationBar)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    reloadButton
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    gridButton
                }
            }
            .onAppear {
                Task {
                    self.gridLayout = Array(repeating: .init(.flexible()), count: searchGridLayoutState)
                    if apods == [] {
                        try await fetchAPODS(count: countOfRandomAPODs)
                        try await fetchAPODSImagesInCache()
                    }
                }
            }
        }
    }
    
    func fetchAPODS(count: Int) async throws {
        
        apods = [APODInstance.loading]
        
        let (data, response) = try await URLSession.shared.data(from: URL(string: "\(AppConstants.NASA.defaultNASAUrl)?api_key=\(userAPIKey)&count=\(count)")!)
        
        if let response = response as? HTTPURLResponse {
            if let limit = response.value(forHTTPHeaderField: "X-RateLimit-Limit") {
                appPrefs.requestLimit = limit
            }
            if let remaining = response.value(forHTTPHeaderField: "X-RateLimit-Remaining") {
                appPrefs.requestRemaining = remaining
            }
        }
        self.apods = try JSONDecoder().decode([APODInstance].self, from: data)
        
        if isHapticFeedback { UIImpactFeedbackGenerator(style: .light).impactOccurred() }
    }
    
    func fetchAPODSImagesInCache() async throws {
        
        apodsImages = [:]
        
        for fetchingAPOD in apods {
            let url = URL(string: fetchingAPOD.url)
            
            let (imageData, _) = try await URLSession.shared.data(from: url!)
            
            apodsImages[fetchingAPOD] = UIImage(data: imageData) ?? UIImage(named: "youtube")!
            if isHapticFeedback { UIImpactFeedbackGenerator(style: .medium).impactOccurred() }
        }
    }
}

struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        SearchView()
            .environmentObject(AppPrefs())
    }
}

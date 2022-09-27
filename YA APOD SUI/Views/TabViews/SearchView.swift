import SwiftUI

struct SearchView: View {
    
    @AppStorage("countOfRandomAPODs") var countOfRandomAPODs: Int = 12
    @AppStorage("userAPIKey") var userAPIKey: String = "DEMO_KEY"
    @AppStorage("requestLimit") var requestLimit: String = "40"
    @AppStorage("requestRemaining") var requestRemaining: String = "40"
    
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
            self.gridLayout = Array(repeating: .init(.flexible()), count: gridLayout.count % 3 + 1)
        } label: {
            Image(systemName: "square.grid.2x2")
                .foregroundColor(.primary)
        }
    }
    
    @ViewBuilder
    var gridView: some View {
        LazyVGrid(columns: gridLayout) {
            ForEach(apods, id: \.self) { apod in
                NavigationLink(destination: DetailAPODView(apod: apod, image: apodsImages[apod] ?? UIImage(named: AppConstants.NASA.defaultNASALogo)!)) {
                    VStack {
                        Image(uiImage: apodsImages[apod] ?? UIImage(named: AppConstants.NASA.defaultNASALogo)!)
                            .resizable()
                            .scaledToFill()
                            .frame(minWidth: 0, maxWidth: .infinity)
                            .frame(height: gridLayout.count == 1 ? 200 : 100)
                            .cornerRadius(10)
                            .shadow(radius: 2)
                        Text(apod.title)
                            .font(.caption)
                    }
                }
            }
        }
        .padding(10)
        .animation(.easeInOut, value: gridLayout.count)
    }
    
    var body: some View {
        NavigationStack {
            ScrollView {
                Divider()
                gridView
                Divider()
            }
            .navigationTitle("\(countOfRandomAPODs) images of the day. (\(requestRemaining))")
            .navigationBarTitleDisplayMode(.inline)
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
                requestLimit = limit
            }
            if let remaining = response.value(forHTTPHeaderField: "X-RateLimit-Remaining") {
                requestRemaining = remaining
            }
        }
        self.apods = try JSONDecoder().decode([APODInstance].self, from: data)
    }
    
    func fetchAPODSImagesInCache() async throws {
        
        apodsImages = [:]
        
        for fetchingAPOD in apods {
            let url = URL(string: fetchingAPOD.url)
            
            let (imageData, _) = try await URLSession.shared.data(from: url!)
            
            apodsImages[fetchingAPOD] = UIImage(data: imageData) ?? UIImage(named: AppConstants.NASA.defaultNASALogo)!
        }
    }
}

struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        SearchView()
    }
}

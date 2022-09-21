import SwiftUI

struct SearchView: View {
    
    @State private var apods: [APODInstance] = []
    @State private var apodsImages: [APODInstance : UIImage] = [ : ]
    
    @State private var gridLayout: [GridItem] = [GridItem()]
    
    @ViewBuilder
    var reloadButton: some View {
        Button {
            Task {
                try await fetchAPODS(count: AppConstants.defaultCountOfRandomAPODs)
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
                NavigationLink(destination: DetailAPODView(apod: apod, image: apodsImages[apod] ?? UIImage(systemName: "star")!)) {
                    VStack {
                        Image(uiImage: apodsImages[apod] ?? UIImage(systemName: "star")!)
                            .resizable()
                            .scaledToFill()
                            .frame(minWidth: 0, maxWidth: .infinity)
                            .frame(height: gridLayout.count == 1 ? 200 : 100)
                            .cornerRadius(10)
                            .shadow(radius: 2)
                        Text("\(apod.date), \(apod.title).")
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
                gridView
            }
            .navigationTitle("\(AppConstants.defaultCountOfRandomAPODs) Images of the day")
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
                        try await fetchAPODS(count: AppConstants.defaultCountOfRandomAPODs)
                        try await fetchAPODSImagesInCache()
                    }
                }
            }
        }
    }
    
    func fetchAPODS(count: Int) async throws {
        
        let (data, _) = try await URLSession.shared.data(from: URL(string: "\(AppConstants.NASA.defaultNASAUrl)?api_key=\(AppConstants.NASA.myAPIKEY)&count=\(count)")!)
        
        self.apods = try JSONDecoder().decode([APODInstance].self, from: data)
        
        print("Done:", data)
    }
    
    func fetchAPODSImagesInCache() async throws {
        for fetchingAPOD in apods {
            let url = URL(string: fetchingAPOD.url)
            
            let (imageData, _) = try await URLSession.shared.data(from: url!)
            
            apodsImages[fetchingAPOD] = UIImage(data: imageData) ?? UIImage(systemName: "square.and.arrow.up.trianglebadge.exclamationmark")!
        }
    }
}

struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        SearchView()
    }
}

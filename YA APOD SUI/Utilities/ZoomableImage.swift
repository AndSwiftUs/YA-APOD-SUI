import SwiftUI

struct ZoomableImage: View {
    
    var zoomImage: UIImage
    
    @State private var imageScale : CGFloat = 1
    @State private var imageOffset: CGSize = .zero
    
    // MARK: - Function
    func resetImageState() {
        return withAnimation(.spring()) {
            imageScale = 1
            imageOffset = .zero
        }
    }
    
    var body: some View {
        
        Image(uiImage: zoomImage)
            .resizable()
            .scaledToFit()
            .transition(.move(edge: .bottom))
            .cornerRadius(10)
            .shadow(color: .black.opacity(0.2), radius: 12, x: 2, y: 2)
            .offset(x: imageOffset.width, y: imageOffset.height)
            .scaleEffect(imageScale)
        
        // MARK: 1 - TAP GESTURE
            .onTapGesture(count: 2) {
                if imageScale == 1 {
                    withAnimation(.spring()) {
                        imageScale = 5
                    }
                } else {
                    resetImageState()
                }
            }
        
        // MARK: 2 - DRAG GESTURE
            .gesture(
                DragGesture()
                    .onChanged({ value in
                        withAnimation(.linear(duration: 1)) {
                            imageOffset = value.translation
                        }
                    })
                    .onEnded({ _ in
                        if imageScale <= 1 {
                            resetImageState()
                        }
                    })
            )
        
        // MARK: Magnification
            .gesture(
                MagnificationGesture()
                    .onChanged({ value in
                        withAnimation(.linear(duration: 1)) {
                            if imageScale >= 1 && imageScale <= 5 {
                                imageScale = value
                            }else if imageScale > 5 {
                                imageScale = 5
                            }
                        }
                    })
                
                    .onEnded({ _ in
                        if imageScale > 5 {
                            imageScale = 5
                        } else if imageScale <= 1 {
                            resetImageState()
                        }
                    })
            )
    }
}

struct ZoomableImage_Previews: PreviewProvider {
    static var previews: some View {
        ZoomableImage(zoomImage: UIImage(named: "nasa-logo.svg")!)
    }
}

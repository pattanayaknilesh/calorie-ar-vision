import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = CameraViewModel()
    
    var body: some View {
        ZStack {
            // Camera Layer
            CameraView(viewModel: viewModel)
                .edgesIgnoringSafeArea(.all)
            
            // UI Layer
            VStack {
                Spacer()
                
                if viewModel.isAnalyzing {
                    ProgressView("Analyzing Dish...")
                        .padding()
                        .background(Color.white.opacity(0.8))
                        .cornerRadius(10)
                        .padding(.bottom, 50)
                } else if let info = viewModel.nutritionInfo {
                    NutritionOverlayView(info: info)
                        .transition(.move(edge: .bottom).combined(with: .opacity))
                        .padding(.bottom, 50)
                }
            }
        }
        .animation(.spring(), value: viewModel.nutritionInfo != nil)
    }
}

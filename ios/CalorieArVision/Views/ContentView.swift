import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = CameraViewModel()
    
    var body: some View {
        ZStack {
            // MARK: - Camera Feed
            CameraPreviewView(session: viewModel.cameraManager.session)
                .ignoresSafeArea()
            
            // MARK: - Overlay UI
            VStack {
                // Top Bar: Status
                HStack {
                    if !viewModel.cameraManager.permissionGranted {
                        Label("Camera access denied", systemImage: "exclamationmark.triangle.fill")
                            .font(.caption)
                            .foregroundColor(.yellow)
                            .padding(8)
                            .background(.ultraThinMaterial, in: Capsule())
                    }
                    
                    Spacer()
                }
                .padding(.horizontal)
                .padding(.top, 8)
                
                Spacer()
                
                // MARK: - Analysis Results
                if viewModel.isAnalyzing {
                    analysisLoadingView
                } else if let info = viewModel.nutritionInfo {
                    NutritionOverlayView(info: info)
                        .transition(.move(edge: .bottom).combined(with: .opacity))
                }
                
                if let error = viewModel.errorMessage {
                    Text(error)
                        .font(.caption)
                        .foregroundColor(.red)
                        .padding(8)
                        .background(.ultraThinMaterial, in: Capsule())
                        .padding(.bottom, 4)
                }
                
                // MARK: - Controls
                controlBar
            }
        }
        .animation(.spring(response: 0.5), value: viewModel.isAnalyzing)
        .animation(.spring(response: 0.5), value: viewModel.nutritionInfo?.id)
        .onAppear {
            viewModel.startCamera()
        }
        .onDisappear {
            viewModel.stopCamera()
        }
    }
    
    // MARK: - Sub Views
    
    private var analysisLoadingView: some View {
        HStack(spacing: 12) {
            ProgressView()
                .tint(.white)
            Text("Analyzing dish...")
                .font(.system(size: 14, weight: .medium, design: .rounded))
                .foregroundColor(.white)
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 12)
        .background(.ultraThinMaterial, in: Capsule())
    }
    
    private var controlBar: some View {
        HStack(spacing: 24) {
            // Dismiss result
            if viewModel.nutritionInfo != nil {
                Button(action: { viewModel.dismissResult() }) {
                    Image(systemName: "xmark.circle.fill")
                        .font(.system(size: 24))
                        .foregroundColor(.white.opacity(0.8))
                }
            }
            
            // Analyze Button
            Button(action: { viewModel.analyzeCurrentFrame() }) {
                ZStack {
                    Circle()
                        .fill(.white)
                        .frame(width: 70, height: 70)
                    
                    Circle()
                        .stroke(Color.white.opacity(0.3), lineWidth: 4)
                        .frame(width: 80, height: 80)
                    
                    Image(systemName: "fork.knife.circle.fill")
                        .font(.system(size: 32))
                        .foregroundColor(.black)
                }
            }
            .disabled(viewModel.isAnalyzing)
            .opacity(viewModel.isAnalyzing ? 0.5 : 1.0)
            
            // Spacer to balance the dismiss button
            if viewModel.nutritionInfo != nil {
                Color.clear.frame(width: 24, height: 24)
            }
        }
        .padding(.bottom, 30)
    }
}

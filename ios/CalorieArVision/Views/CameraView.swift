import SwiftUI
import AVFoundation
import UIKit

struct CameraView: UIViewRepresentable {
    @ObservedObject var viewModel: CameraViewModel
    
    func makeUIView(context: Context) -> UIView {
        #if targetEnvironment(simulator)
        // SIMULATOR MODE: Create a mock camera interface
        let view = UIView()
        view.backgroundColor = .black
        
        let statusLabel = UILabel()
        statusLabel.text = "SIMULATOR MODE\nLive Camera Unavailable"
        statusLabel.textColor = .white
        statusLabel.textAlignment = .center
        statusLabel.numberOfLines = 0
        statusLabel.font = .systemFont(ofSize: 16, weight: .bold)
        statusLabel.frame = view.bounds
        statusLabel.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.addSubview(statusLabel)
        
        // Simulate a "capture" every 7 seconds to test the overlay
        Timer.scheduledTimer(withTimeInterval: 7.0, repeats: true) { _ in
            let mockImage = UIImage(systemName: "fork.knife") ?? UIImage()
            viewModel.analyzeCurrentFrame(image: mockImage)
        }
        
        return view
        #else
        // PHYSICAL DEVICE MODE: Use real camera
        let view = UIView()
        let session = AVCaptureSession()
        
        guard let device = AVCaptureDevice.default(for: .video),
              let input = try? AVCaptureDeviceInput(device: device) else {
            return view
        }
        
        if session.canAddInput(input) {
            session.addInput(input)
        }
        
        let previewLayer = AVCaptureVideoPreviewLayer(session: session)
        previewLayer.videoGravity = .resizeAspectFill
        view.layer.addSublayer(previewLayer)
        
        context.coordinator.session = session
        context.coordinator.previewLayer = previewLayer
        
        Timer.scheduledTimer(withTimeInterval: 5.0, repeats: true) { _ in
            context.coordinator.capturePhoto(session: session)
        }
        
        DispatchQueue.global(qos: .userInitiated).async {
            session.startRunning()
        }
        
        return view
        #endif
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {
        #if !targetEnvironment(simulator)
        context.coordinator.previewLayer?.frame = uiView.bounds
        #endif
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(viewModel: viewModel)
    }
    
    class Coordinator: NSObject, AVCapturePhotoCaptureDelegate {
        var session: AVCaptureSession?
        var previewLayer: AVCaptureVideoPreviewLayer?
        let viewModel: CameraViewModel
        
        init(viewModel: CameraViewModel) {
            self.viewModel = viewModel
        }
        
        func capturePhoto(session: AVCaptureSession) {
            let photoOutput = AVCapturePhotoOutput()
            if session.canAddOutput(photoOutput) {
                session.addOutput(photoOutput)
                let settings = AVCapturePhotoSettings()
                photoOutput.capturePhoto(with: settings, delegate: self)
            }
        }
        
        func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
            guard let data = photo.fileDataRepresentation(),
                  let image = UIImage(data: data) else { return }
            viewModel.analyzeCurrentFrame(image: image)
        }
    }
}

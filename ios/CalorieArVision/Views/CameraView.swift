import SwiftUI
import AVFoundation
import UIKit

struct CameraView: UIViewRepresentable {
    @ObservedObject var viewModel: CameraViewModel
    
    func makeUIView(context: Context) -> UIView {
        let view = UIView()
        
        let session = AVCaptureSession()
        
        // Attempt to get the default video device (this works in simulator if Mac camera is enabled)
        guard let device = AVCaptureDevice.default(for: .video),
              let input = try? AVCaptureDeviceInput(device: device) else {
            
            // Fallback: Show instructions to the user if camera is not available
            let errorLabel = UILabel()
            errorLabel.text = "Camera not found.\nIn Simulator: Go to 'Settings' -> 'Camera' -> select 'Mac Camera'."
            errorLabel.textAlignment = .center
            errorLabel.numberOfLines = 0
            errorLabel.textColor = .white
            errorLabel.frame = view.bounds
            errorLabel.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            view.backgroundColor = .black
            view.addSubview(errorLabel)
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
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {
        context.coordinator.previewLayer?.frame = uiView.bounds
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

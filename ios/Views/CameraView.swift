import SwiftUI
import AVFoundation

struct CameraView: UIViewRepresentable {
    @ObservedObject var viewModel: CameraViewModel
    
    func makeUIView(context: Context) -> UIView {
        let view = UIView(frame: UIScreen.main.bounds)
        
        let session = AVCaptureSession()
        guard let device = AVCaptureDevice.default(for: .video),
              let input = try? AVCaptureDeviceInput(device: device) else {
            return view
        }
        
        if session.canAddInput(input) {
            session.addInput(input)
        }
        
        let previewLayer = AVCaptureVideoPreviewLayer(session: session)
        previewLayer.frame = view.bounds
        previewLayer.videoGravity = .resizeAspectFill
        view.layer.addSublayer(previewLayer)
        
        // Add a timer to simulate frame capture every 5 seconds
        Timer.scheduledTimer(withTimeInterval: 5.0, repeats: true) { _ in
            capturePhoto(session: session)
        }
        
        DispatchQueue.global(qos: .userInitiated).async {
            session.startRunning()
        }
        
        return view
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {}
    
    private func capturePhoto(session: AVCaptureSession) {
        let photoOutput = AVCapturePhotoOutput()
        if session.canAddOutput(photoOutput) {
            session.addOutput(photoOutput)
            let settings = AVCapturePhotoSettings()
            let delegate = PhotoCaptureDelegate { image in
                self.viewModel.analyzeCurrentFrame(image: image)
            }
            // Note: In a real app, we'd keep a reference to the delegate
            photoOutput.capturePhoto(with: settings, delegate: delegate)
        }
    }
}

class PhotoCaptureDelegate: NSObject, AVCapturePhotoCaptureDelegate {
    let completion: (UIImage) -> Void
    
    init(completion: @escaping (UIImage) -> Void) {
        self.completion = completion
    }
    
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        guard let data = photo.fileDataRepresentation(),
              let image = UIImage(data: data) else { return }
        completion(image)
    }
}

import Foundation
import UIKit

@MainActor
class CameraViewModel: ObservableObject {
    
    @Published var nutritionInfo: NutritionInfo?
    @Published var isAnalyzing: Bool = false
    @Published var errorMessage: String?
    
    let cameraManager = CameraManager()
    
    private let nutritionService: any NutritionServiceProtocol
    private var analysisTask: Task<Void, Never>?
    private var lastAnalysisTime: Date = .distantPast
    private let analysisCooldown: TimeInterval = 5.0
    
    init(nutritionService: any NutritionServiceProtocol = MockNutritionService()) {
        self.nutritionService = nutritionService
    }
    
    // MARK: - Manual Analysis Trigger
    
    func analyzeCurrentFrame() {
        guard !isAnalyzing else { return }
        
        // Throttle: prevent rapid repeated calls
        let now = Date()
        guard now.timeIntervalSince(lastAnalysisTime) >= analysisCooldown else { return }
        lastAnalysisTime = now
        
        guard let frame = cameraManager.captureCurrentFrame(),
              let imageData = frame.jpegData(compressionQuality: 0.7) else {
            errorMessage = "Unable to capture frame"
            return
        }
        
        isAnalyzing = true
        errorMessage = nil
        
        analysisTask = Task {
            do {
                let result = try await nutritionService.analyzeDish(image: imageData)
                self.nutritionInfo = result
            } catch {
                self.errorMessage = "Analysis failed: \(error.localizedDescription)"
            }
            self.isAnalyzing = false
        }
    }
    
    // MARK: - Lifecycle
    
    func startCamera() {
        cameraManager.startSession()
    }
    
    func stopCamera() {
        cameraManager.stopSession()
        analysisTask?.cancel()
    }
    
    func dismissResult() {
        nutritionInfo = nil
        errorMessage = nil
    }
}

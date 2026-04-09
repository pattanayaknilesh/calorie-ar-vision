import Foundation
import Combine
import UIKit

class CameraViewModel: ObservableObject {
    @Published var nutritionInfo: NutritionInfo?
    @Published var isAnalyzing: Bool = false
    
    private let nutritionService: NutritionServiceProtocol
    private var cancellables = Set<AnyCancellable>()
    
    init(nutritionService: NutritionServiceProtocol = MockNutritionService()) {
        self.nutritionService = nutritionService
    }
    
    func analyzeCurrentFrame(image: UIImage) {
        guard let imageData = image.jpegData(compressionQuality: 0.8) else { return }
        
        isAnalyzing = true
        
        nutritionService.analyzeDish(image: imageData)
            .sink(receiveCompletion: { [weak self] completion in
                self?.isAnalyzing = false
                if case .failure(let error) = completion {
                    print("Error analyzing dish: \(error)")
                }
            }, receiveValue: { [weak self] info in
                self?.nutritionInfo = info
            })
            .store(in: &cancellables)
    }
}

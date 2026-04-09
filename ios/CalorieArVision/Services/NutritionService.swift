import Foundation
import Combine

protocol NutritionServiceProtocol {
    func analyzeDish(image: Data) -> AnyPublisher<NutritionInfo, Error>
}

class MockNutritionService: NutritionServiceProtocol {
    func analyzeDish(image: Data) -> AnyPublisher<NutritionInfo, Error> {
        // Simulating network delay
        let mockData = NutritionInfo(
            dishName: "Avocado Toast with Egg",
            calories: 350,
            protein: 15.0,
            carbs: 25.0,
            fats: 20.0
        )
        
        return Just(mockData)
            .setFailureType(to: Error.self)
            .delay(for: .seconds(1), scheduler: RunLoop.main)
            .eraseToAnyPublisher()
    }
}

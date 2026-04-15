import Foundation

protocol NutritionServiceProtocol: Sendable {
    func analyzeDish(image: Data) async throws -> NutritionInfo
}

import Foundation
import UIKit

protocol NutritionServiceProtocol {
    func analyzeDish(image: Data) async throws -> NutritionInfo
}

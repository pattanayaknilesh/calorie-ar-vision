import Foundation

struct NutritionInfo: Codable, Identifiable {
    let id: UUID
    let dishName: String
    let calories: Int
    let protein: Double
    let carbs: Double
    let fats: Double
    
    init(id: UUID = UUID(), dishName: String, calories: Int, protein: Double, carbs: Double, fats: Double) {
        self.id = id
        self.dishName = dishName
        self.calories = calories
        self.protein = protein
        self.carbs = carbs
        self.fats = fats
    }
}

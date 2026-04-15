import Foundation

struct Ingredient: Codable, Identifiable, Sendable {
    let id: UUID
    let name: String
    let calories: Int
    let protein: Double
    let carbs: Double
    let fats: Double
    
    init(id: UUID = UUID(), name: String, calories: Int, protein: Double, carbs: Double, fats: Double) {
        self.id = id
        self.name = name
        self.calories = calories
        self.protein = protein
        self.carbs = carbs
        self.fats = fats
    }
}

struct NutritionInfo: Codable, Identifiable, Sendable {
    let id: UUID
    let dishName: String
    let totalCalories: Int
    let totalProtein: Double
    let totalCarbs: Double
    let totalFats: Double
    let ingredients: [Ingredient]
    let confidence: Double // 0.0 to 1.0
    
    init(
        id: UUID = UUID(),
        dishName: String,
        totalCalories: Int,
        totalProtein: Double,
        totalCarbs: Double,
        totalFats: Double,
        ingredients: [Ingredient],
        confidence: Double
    ) {
        self.id = id
        self.dishName = dishName
        self.totalCalories = totalCalories
        self.totalProtein = totalProtein
        self.totalCarbs = totalCarbs
        self.totalFats = totalFats
        self.ingredients = ingredients
        self.confidence = confidence
    }
}

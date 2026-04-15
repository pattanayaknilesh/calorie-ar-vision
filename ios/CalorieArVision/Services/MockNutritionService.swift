import Foundation

class MockNutritionService: NutritionServiceProtocol {
    
    private let mockDishes: [NutritionInfo] = [
        NutritionInfo(
            dishName: "Avocado Toast with Egg",
            totalCalories: 350,
            totalProtein: 15.0,
            totalCarbs: 28.0,
            totalFats: 20.0,
            ingredients: [
                Ingredient(name: "Whole Wheat Bread", calories: 130, protein: 4.0, carbs: 22.0, fats: 2.0),
                Ingredient(name: "Avocado", calories: 120, protein: 1.5, carbs: 4.0, fats: 11.0),
                Ingredient(name: "Fried Egg", calories: 90, protein: 6.0, carbs: 1.0, fats: 7.0),
                Ingredient(name: "Olive Oil", calories: 10, protein: 0.0, carbs: 0.0, fats: 1.0)
            ],
            confidence: 0.92
        ),
        NutritionInfo(
            dishName: "Chicken Caesar Salad",
            totalCalories: 470,
            totalProtein: 35.0,
            totalCarbs: 18.0,
            totalFats: 28.0,
            ingredients: [
                Ingredient(name: "Grilled Chicken", calories: 165, protein: 31.0, carbs: 0.0, fats: 3.5),
                Ingredient(name: "Romaine Lettuce", calories: 15, protein: 1.0, carbs: 3.0, fats: 0.0),
                Ingredient(name: "Parmesan Cheese", calories: 110, protein: 7.0, carbs: 1.0, fats: 7.0),
                Ingredient(name: "Caesar Dressing", calories: 130, protein: 0.5, carbs: 2.0, fats: 13.0),
                Ingredient(name: "Croutons", calories: 50, protein: 1.0, carbs: 9.0, fats: 1.5)
            ],
            confidence: 0.88
        ),
        NutritionInfo(
            dishName: "Margherita Pizza (1 slice)",
            totalCalories: 285,
            totalProtein: 12.0,
            totalCarbs: 36.0,
            totalFats: 10.0,
            ingredients: [
                Ingredient(name: "Pizza Dough", calories: 150, protein: 4.0, carbs: 28.0, fats: 2.0),
                Ingredient(name: "Mozzarella", calories: 85, protein: 6.0, carbs: 1.0, fats: 6.0),
                Ingredient(name: "Tomato Sauce", calories: 30, protein: 1.0, carbs: 6.0, fats: 0.5),
                Ingredient(name: "Fresh Basil", calories: 1, protein: 0.1, carbs: 0.1, fats: 0.0),
                Ingredient(name: "Olive Oil", calories: 19, protein: 0.0, carbs: 0.0, fats: 2.0)
            ],
            confidence: 0.95
        ),
        NutritionInfo(
            dishName: "Spaghetti Bolognese",
            totalCalories: 520,
            totalProtein: 28.0,
            totalCarbs: 55.0,
            totalFats: 18.0,
            ingredients: [
                Ingredient(name: "Spaghetti Pasta", calories: 220, protein: 8.0, carbs: 43.0, fats: 1.5),
                Ingredient(name: "Ground Beef", calories: 180, protein: 17.0, carbs: 0.0, fats: 12.0),
                Ingredient(name: "Tomato Sauce", calories: 50, protein: 1.5, carbs: 9.0, fats: 1.0),
                Ingredient(name: "Onion & Garlic", calories: 20, protein: 0.5, carbs: 4.0, fats: 0.0),
                Ingredient(name: "Parmesan", calories: 50, protein: 3.5, carbs: 0.5, fats: 3.5)
            ],
            confidence: 0.90
        ),
        NutritionInfo(
            dishName: "Grilled Salmon with Vegetables",
            totalCalories: 410,
            totalProtein: 38.0,
            totalCarbs: 12.0,
            totalFats: 22.0,
            ingredients: [
                Ingredient(name: "Atlantic Salmon", calories: 280, protein: 34.0, carbs: 0.0, fats: 16.0),
                Ingredient(name: "Broccoli", calories: 35, protein: 2.5, carbs: 7.0, fats: 0.5),
                Ingredient(name: "Asparagus", calories: 25, protein: 2.0, carbs: 4.0, fats: 0.0),
                Ingredient(name: "Lemon & Herbs", calories: 5, protein: 0.0, carbs: 1.0, fats: 0.0),
                Ingredient(name: "Olive Oil", calories: 65, protein: 0.0, carbs: 0.0, fats: 7.0)
            ],
            confidence: 0.87
        )
    ]
    
    func analyzeDish(image: Data) async throws -> NutritionInfo {
        // Simulate network latency (1.5 - 3 seconds)
        let delay = UInt64.random(in: 1_500_000_000...3_000_000_000)
        try await Task.sleep(nanoseconds: delay)
        
        // Return a random dish
        return mockDishes.randomElement()!
    }
}

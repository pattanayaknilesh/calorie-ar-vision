import SwiftUI

struct NutritionOverlayView: View {
    let info: NutritionInfo
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(info.dishName)
                .font(.headline)
                .foregroundColor(.white)
            
            HStack {
                NutritionMetricView(label: "Calories", value: "\(info.calories)", color: .yellow)
                NutritionMetricView(label: "Protein", value: "\(Int(info.protein))g", color: .red)
                NutritionMetricView(label: "Carbs", value: "\(Int(info.carbs))g", color: .green)
                NutritionMetricView(label: "Fats", value: "\(Int(info.fats))g", color: .blue)
            }
        }
        .padding()
        .background(Color.black.opacity(0.6))
        .cornerRadius(15)
        .overlay(
            RoundedRectangle(cornerRadius: 15)
                .stroke(Color.white, lineWidth: 1)
        )
        .padding()
    }
}

struct NutritionMetricView: View {
    let label: String
    let value: String
    let color: Color
    
    var body: some View {
        VStack {
            Text(label)
                .font(.caption2)
                .foregroundColor(.gray)
            Text(value)
                .font(.system(size: 14, weight: .bold))
                .foregroundColor(color)
        }
        .frame(maxWidth: .infinity)
    }
}

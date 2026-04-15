import SwiftUI

struct MacroRingView: View {
    let label: String
    let value: Double
    let maxValue: Double
    let color: Color
    let unit: String
    
    private var progress: Double {
        min(value / maxValue, 1.0)
    }
    
    var body: some View {
        VStack(spacing: 4) {
            ZStack {
                Circle()
                    .stroke(color.opacity(0.2), lineWidth: 4)
                    .frame(width: 50, height: 50)
                
                Circle()
                    .trim(from: 0, to: progress)
                    .stroke(color, style: StrokeStyle(lineWidth: 4, lineCap: .round))
                    .frame(width: 50, height: 50)
                    .rotationEffect(.degrees(-90))
                
                Text("\(Int(value))")
                    .font(.system(size: 12, weight: .bold, design: .rounded))
                    .foregroundColor(.white)
            }
            
            Text(label)
                .font(.system(size: 10, weight: .medium))
                .foregroundColor(.white.opacity(0.7))
            
            Text(unit)
                .font(.system(size: 9))
                .foregroundColor(.white.opacity(0.5))
        }
    }
}

struct NutritionOverlayView: View {
    let info: NutritionInfo
    @State private var isExpanded: Bool = false
    @State private var animateIn: Bool = false
    
    var body: some View {
        VStack(spacing: 0) {
            // Header
            Button(action: { withAnimation(.spring(response: 0.4)) { isExpanded.toggle() } }) {
                HStack {
                    VStack(alignment: .leading, spacing: 2) {
                        Text(info.dishName)
                            .font(.system(size: 16, weight: .bold, design: .rounded))
                            .foregroundColor(.white)
                        
                        HStack(spacing: 4) {
                            Text("\(info.totalCalories) kcal")
                                .font(.system(size: 13, weight: .semibold, design: .rounded))
                                .foregroundColor(.yellow)
                            
                            Text("Confidence: \(Int(info.confidence * 100))%")
                                .font(.system(size: 10))
                                .foregroundColor(.white.opacity(0.5))
                        }
                    }
                    
                    Spacer()
                    
                    Image(systemName: isExpanded ? "chevron.down" : "chevron.up")
                        .foregroundColor(.white.opacity(0.6))
                        .font(.caption)
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 12)
            }
            .buttonStyle(.plain)
            
            // Macro Rings
            HStack(spacing: 16) {
                MacroRingView(label: "Protein", value: info.totalProtein, maxValue: 50, color: .red, unit: "g")
                MacroRingView(label: "Carbs", value: info.totalCarbs, maxValue: 80, color: .green, unit: "g")
                MacroRingView(label: "Fats", value: info.totalFats, maxValue: 40, color: .blue, unit: "g")
            }
            .padding(.horizontal, 16)
            .padding(.bottom, 12)
            
            // Ingredients (expandable)
            if isExpanded {
                Divider()
                    .background(Color.white.opacity(0.2))
                
                VStack(alignment: .leading, spacing: 6) {
                    Text("Ingredients")
                        .font(.system(size: 12, weight: .semibold))
                        .foregroundColor(.white.opacity(0.7))
                        .padding(.top, 8)
                    
                    ForEach(info.ingredients) { ingredient in
                        HStack {
                            Text(ingredient.name)
                                .font(.system(size: 12))
                                .foregroundColor(.white)
                            
                            Spacer()
                            
                            Text("\(ingredient.calories) kcal")
                                .font(.system(size: 11, weight: .medium, design: .monospaced))
                                .foregroundColor(.yellow.opacity(0.8))
                        }
                    }
                }
                .padding(.horizontal, 16)
                .padding(.bottom, 12)
                .transition(.opacity.combined(with: .move(edge: .top)))
            }
        }
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(.ultraThinMaterial)
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(Color.white.opacity(0.15), lineWidth: 1)
                )
        )
        .padding(.horizontal, 16)
        .scaleEffect(animateIn ? 1.0 : 0.9)
        .opacity(animateIn ? 1.0 : 0.0)
        .onAppear {
            withAnimation(.spring(response: 0.5, dampingFraction: 0.7)) {
                animateIn = true
            }
        }
    }
}

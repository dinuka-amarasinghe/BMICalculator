import Foundation
struct BMIRecord: Identifiable, Codable {
    var id = UUID()
    var date: Date
    var bmiValue: Double
    var changePercentage: Double? = nil
}

//Explain this struct and the attributes? How does it work? Explain value nil.

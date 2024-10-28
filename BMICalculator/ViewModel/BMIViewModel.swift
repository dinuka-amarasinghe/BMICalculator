import Foundation
class BMIViewModel: ObservableObject {
    
    // Explain @Published. Explain what bmiRecords is and its purpose.
    @Published var height: String = ""
    @Published var weight: String = ""
    @Published var selectedDate: Date = Date()
    @Published var bmiRecords: [BMIRecord] = []
    private let userDefaults = UserDefaults.standard
    private let bmiRecordsKey = "BMIRecordsKey"
    @Published var showAlert:Bool = false
    
    init(){
        loadStoredBMIRecords()
    }
    
    func updateStoredBMIRecords() {
        print("bmiRecords... before encoding....\(bmiRecords)")
        let encoder = JSONEncoder()
        
        if let encoded = try? encoder.encode(bmiRecords) {
            // Convert the encoded data to a JSON string for debugging
            if let jsonString = String(data: encoded, encoding: .utf8) {
                print("JSON String representation of encoded data: \(jsonString)")
            }
            userDefaults.set(encoded, forKey: bmiRecordsKey)
        }
    }
    
    func loadStoredBMIRecords() {
        if let data = userDefaults.data(forKey: bmiRecordsKey) {
            print("bmiRecords... before decoding....\(data)")
            let decoder = JSONDecoder()
            if let decoded = try? decoder.decode([BMIRecord].self, from: data) {
                bmiRecords = decoded.sorted(by: { $0.date < $1.date })
                //bmiRecords = decoded
                print("decoded data ...\(decoded)")
            }
        }
    }
    
    func calculateBMI() {
        if let heightValue = Double(height), let weightValue = Double(weight), heightValue > 0, weightValue > 0 {
            let bmi = weightValue / (heightValue * heightValue)
            let record = BMIRecord(date: selectedDate, bmiValue: bmi)
            
            bmiRecords.append(record)
            bmiRecords.sort(by: { $0.date < $1.date }) // Sort the records by date
            
            // what happens the first time a calculation is performed?
            for index in 1..<bmiRecords.count {
                let previousRecord = bmiRecords[index - 1]
                let changePercentage = ((bmiRecords[index].bmiValue - previousRecord.bmiValue) / previousRecord.bmiValue) * 100
                bmiRecords[index].changePercentage = changePercentage
            }
            updateStoredBMIRecords()
        }
        // Reset fields
        height = ""
        weight = ""
    }
    
    func classifyBMI(_ bmi: Double) -> String {
        if bmi < 18.5 {
            return "Underweight"
        } else if bmi < 24.9 {
            return "Normal Weight"
        } else if bmi < 29.9 {
            return "Overweight"
        } else {
            return "Obese"
        }
    }
}

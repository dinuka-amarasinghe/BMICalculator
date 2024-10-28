import SwiftUI

// Main view for the BMI Calculator app
struct ContentView: View {
    // Observed object for managing BMI calculation and data storage
    @ObservedObject var viewModel = BMIViewModel()
    // Focus state to control keyboard focus on TextField inputs
    @FocusState private var fieldIsFocused: Bool

    var body: some View {
        
        ZStack { // Background layer
            VStack(spacing: 20) { // Main vertical stack for arranging elements with spacing
                // Header Text
                Text("BMI Calculator")
                    .font(.title)
                    .fontWeight(.bold)
                
                // Height Input
                HStack { // Horizontal stack for the height label and input field
                    Label("Height (m):", systemImage: "ruler")
                        .fontWeight(.semibold)
                        .foregroundColor(.black)
                        .padding(.leading, 8) // Adds padding between the label and HStack border

                    // TextField to accept user input for height
                    TextField("Enter height", text: $viewModel.height)
                        .keyboardType(.decimalPad)
                        .padding()
                        .border(Color.black, width: 3)
                        .focused($fieldIsFocused)
                }
                .frame(width: 400, height: 50)
                .border(Color.black, width: 3)
                .cornerRadius(2.0) // Rounds corners of the frame
                
                // Weight Input
                HStack { // Horizontal stack for the weight label and input field
                    Label("Weight (kg):", systemImage: "scalemass")
                         .fontWeight(.semibold)
                         .foregroundColor(.black)
                         .padding(.leading, 8) // Adds padding between the label and HStack border
                    
                    // TextField to accept user input for weight
                    TextField("Enter weight", text: $viewModel.weight)
                        .keyboardType(.decimalPad)
                        .padding()
                        .border(Color.black, width: 3)
                        .focused($fieldIsFocused)
                }
                .frame(width: 400, height: 50)
                .border(Color.black, width: 3)
                .cornerRadius(2.0)
                
                // DatePicker for selecting the date
                DatePicker("Select Date", selection: $viewModel.selectedDate, in: ...Date(), displayedComponents: .date)
                
                // Calculate BMI Button
                Button(action: {
                    // Calls the calculateBMI() function in the viewModel
                    viewModel.calculateBMI()
                }) {
                    Text("Calculate")
                        .padding()
                        .background((viewModel.height.isEmpty || viewModel.weight.isEmpty) ? Color.gray : Color.yellow) // Disables if fields are empty
                        .fontWeight(.semibold)
                        .foregroundColor(Color.black)
                        .cornerRadius(10)
                }
                .disabled(viewModel.height.isEmpty || viewModel.weight.isEmpty) // Button disabled if fields are empty
                
                // Alert for handling invalid data input
                .alert(isPresented: $viewModel.showAlert) {
                    Alert(title: Text("Invalid Data"), message: Text("Non-numeric data"), dismissButton: .default(Text("Try Again")))
                }
                
                // Display of the most recent BMI record if available
                if let lastRecord = viewModel.bmiRecords.last {
                    HStack(spacing: 10) {
                        Text("BMI: \(String(format: "%.2f", lastRecord.bmiValue))")
                            .font(.headline)
                            .padding()
                        
                        Text("Date: \(lastRecord.date, formatter: DateFormatter.shortDate)")
                            .font(.subheadline)
                            .padding()
                        
                        // Displays BMI change percentage if available
                        if let changePercentage = lastRecord.changePercentage {
                            Text("Change: \(String(format: "%.2f", changePercentage))%")
                                .foregroundColor(changePercentage >= 0 ? .white : .black)
                                .font(.subheadline)
                                .padding()
                        }
                    }
                }
                
                // Section for BMI Records View
                Text("BMI Records:")
                    .font(.headline)
                    .fontWeight(.bold)
                
                // Scrollable view of BMI records
                ScrollView {
                    List(viewModel.bmiRecords) { record in
                        VStack(alignment: .leading) { // Display each record in a vertical stack
                            Text(record.date, format: Date.FormatStyle().day().month().year())
                            Text("BMI: \(String(format: "%.2f", record.bmiValue))")
                            if let changePercentage = record.changePercentage {
                                Text("Changed: \(String(format: "%.2f", changePercentage))%")
                            }
                            Text(viewModel.classifyBMI(record.bmiValue)) // Classification of BMI
                                .font(.subheadline)
                                .foregroundColor(Color.blue)
                        }
                    }
                    .background(Color.white)
                    .cornerRadius(10.0)
                    .scrollContentBackground(.hidden) // Hides scroll content background
                    .frame(height: 400) // Sets the scrollable frame height
                }
            }
            .padding()
            .onTapGesture { // Hides the keyboard when tapping outside input fields
                fieldIsFocused = false
            }
        }
        .background(Color.mint) // Sets background color
    }
}

// DateFormatter extension to define a custom short date format
extension DateFormatter {
    static var shortDate: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        return formatter
    }
}

// Preview for ContentView in the Xcode canvas
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

import SwiftUI

struct ContentView: View {
    // Creates an instance (object) of type BMIViewModel
    @ObservedObject var viewModel = BMIViewModel()
    @FocusState private var fieldIsFocused: Bool

    var body: some View {
        
        ZStack{
            VStack(spacing: 20) {
                // Header Text
                Text("BMI Calculator")
                    .font(.title)
                    .fontWeight(.bold)
                
                // Height Input
                HStack {
                    Label("Height (m):", systemImage: "ruler")
                        .fontWeight(.semibold)
                        .foregroundColor(.black)
                        .padding(.leading, 8)

                    TextField("Enter height", text: $viewModel.height)
                        .keyboardType(.decimalPad)
                        .padding()
                        .border(/*@START_MENU_TOKEN@*/Color.black/*@END_MENU_TOKEN@*/, width: 3)
                        .focused($fieldIsFocused)
                }
                .frame(width: 400, height: 50)
                .border(/*@START_MENU_TOKEN@*/Color.black/*@END_MENU_TOKEN@*/, width: 3)
                .cornerRadius(2.0)
                
                // Weight Input
                HStack {
                    Label("Weight (kg):", systemImage: "scalemass")
                         .fontWeight(.semibold)
                         .foregroundColor(.black)
                         .padding(.leading, 8)
                    
                    TextField("Enter weight", text: $viewModel.weight)
                        .keyboardType(.decimalPad)
                        .padding()
                        .border(/*@START_MENU_TOKEN@*/Color.black/*@END_MENU_TOKEN@*/, width: 3)
                        .focused($fieldIsFocused)
                }
                .frame(width: 400, height: 50)
                .border(/*@START_MENU_TOKEN@*/Color.black/*@END_MENU_TOKEN@*/, width: 3)
                .cornerRadius(2.0)
                
                // DatePicker
                DatePicker(("Select Date"), selection: $viewModel.selectedDate,in: ...Date(), displayedComponents: .date)
                
                // Calculate BMI Button
                Button(action: {
                    viewModel.calculateBMI()
                }) {
                    Text("Calculate")
                        .padding()
                        .background((viewModel.height.isEmpty || viewModel.weight.isEmpty) ? Color.gray : Color.yellow)
                        .fontWeight(.semibold)
                        .foregroundColor(Color.black)
                        .cornerRadius(10)
                }
                .disabled(viewModel.height.isEmpty || viewModel.weight.isEmpty)
                
                // Alert For Invalid Data
                .alert( isPresented: $viewModel.showAlert){
                    Alert(title: Text("Invalid Data"), message: Text("Non-numeric data"), dismissButton: .default(Text("Try Again")))
                }
                
                if let lastRecord = viewModel.bmiRecords.last {
                    HStack(spacing: 10){
                        Text("BMI: \(String(format: "%.2f", lastRecord.bmiValue))")
                            .font(.headline)
                            .padding()
                        
                        Text("Date: \(lastRecord.date, formatter: DateFormatter.shortDate)")
                            .font(.subheadline)
                            .padding()
                        
                        if let changePercentage = lastRecord.changePercentage {
                            Text("Change: \(String(format: "%.2f", changePercentage))%")
                                .foregroundColor(changePercentage >= 0 ? .white : .black)
                                .font(.subheadline)
                                .padding()
                        }
                    }
                }
                
                // BMI Records View
                Text("BMI Records:")
                    .font(.headline)
                    .fontWeight(.bold)
                
                ScrollView {
                    List(viewModel.bmiRecords) { record in
                        VStack(alignment: .leading) {
                            Text(record.date, format: Date.FormatStyle().day().month().year())
                            Text("BMI: \(String(format: "%.2f", record.bmiValue))")
                            if let changePercentage = record.changePercentage {
                                Text("Changed: \(String(format: "%.2f", changePercentage))%")
                            }
                            Text(viewModel.classifyBMI(record.bmiValue))
                                .font(.subheadline)
                                .foregroundColor(Color.blue)
                        }
                    }
                    .background(Color.white)
                    .cornerRadius(10.0)
                    .scrollContentBackground(.hidden)
                    .frame(height: 400)
                }
            }
            .padding()
            .onTapGesture {
                fieldIsFocused = false
            }
        }
        .background(Color.mint)
    }
}

extension DateFormatter {
    static var shortDate: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        return formatter
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

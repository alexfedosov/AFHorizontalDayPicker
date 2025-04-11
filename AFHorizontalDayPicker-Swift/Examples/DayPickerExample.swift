// 
// DayPickerExample.swift
// AFHorizontalDayPicker
//
// Created in 2025
// Swift 6 version of the original Objective-C component
//

import SwiftUI
import AFHorizontalDayPicker

/// Example SwiftUI app that demonstrates the AFHorizontalDayPicker
struct DayPickerExampleApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}

/// Main content view for the example app
struct ContentView: View {
    @State private var selectedDate: Date? = Date()
    @State private var showCustomization = false
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                // Display the selected date
                if let selectedDate = selectedDate {
                    Text("Selected Date: \(selectedDate.formatted(date: .long, time: .omitted))")
                        .font(.headline)
                } else {
                    Text("No date selected")
                        .font(.headline)
                }
                
                // SwiftUI wrapper for the day picker
                AFHorizontalDayPickerView(
                    startDate: Date(),
                    endDate: Date().addingDays(60),
                    firstActiveDate: Date(),
                    lastActiveDate: Date().addingDays(30),
                    selectedDate: $selectedDate,
                    cellWidth: 70,
                    animateScrolling: true,
                    onDateSelected: { date in
                        print("Selected date: \(date)")
                    }
                )
                .frame(height: 80)
                .background(Color(.systemBackground))
                .cornerRadius(8)
                .shadow(radius: 2)
                .padding(.horizontal)
                
                // Action buttons
                HStack(spacing: 20) {
                    Button("Today") {
                        selectedDate = Date()
                    }
                    .buttonStyle(.bordered)
                    
                    Button("Next Week") {
                        selectedDate = Date().addingDays(7)
                    }
                    .buttonStyle(.bordered)
                    
                    Button("Clear") {
                        selectedDate = nil
                    }
                    .buttonStyle(.bordered)
                }
                
                Divider()
                    .padding(.vertical)
                
                // Toggle for showing the UIKit implementation
                Toggle("Show UIKit Implementation", isOn: $showCustomization)
                    .padding(.horizontal)
                
                if showCustomization {
                    UIKitDayPickerView(selectedDate: $selectedDate)
                        .frame(height: 200)
                        .padding()
                }
                
                Spacer()
            }
            .padding()
            .navigationTitle("Day Picker")
        }
    }
}

/// UIKit implementation using UIViewRepresentable
struct UIKitDayPickerView: UIViewRepresentable {
    @Binding var selectedDate: Date?
    
    func makeUIView(context: Context) -> UIView {
        let containerView = UIView()
        containerView.backgroundColor = .systemBackground
        
        // Create the day picker using the result builder
        let dayPicker = DayPicker {
            DateRange(from: Date(), to: Date().addingDays(30))
            ActiveRange(from: Date(), to: Date().addingDays(14))
            Appearance(
                dayNumberActiveColor: .black,
                dayNumberSelectedColor: .white,
                backgroundSelectedColor: .systemBlue
            )
        }
        
        dayPicker.frame = CGRect(x: 0, y: 0, width: 320, height: 80)
        dayPicker.delegate = context.coordinator
        
        if let date = selectedDate {
            dayPicker.selectDate(date, animated: false)
        }
        
        // Add a label
        let label = UILabel()
        label.text = "UIKit Implementation"
        label.textAlignment = .center
        label.frame = CGRect(x: 0, y: 100, width: 320, height: 30)
        
        containerView.addSubview(dayPicker)
        containerView.addSubview(label)
        
        return containerView
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {
        // Find the day picker in the container view
        if let dayPicker = uiView.subviews.first(where: { $0 is AFHorizontalDayPicker }) as? AFHorizontalDayPicker,
           let date = selectedDate, dayPicker.selectedDate != date {
            dayPicker.selectDate(date, animated: true)
        }
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, AFHorizontalDayPickerDelegate {
        var parent: UIKitDayPickerView
        
        init(_ parent: UIKitDayPickerView) {
            self.parent = parent
        }
        
        func horizontalDayPicker(_ picker: AFHorizontalDayPicker, widthForItemWith date: Date) -> CGFloat {
            return 70.0
        }
        
        func horizontalDayPicker(_ picker: AFHorizontalDayPicker, didSelectDate date: Date) {
            parent.selectedDate = date
        }
    }
}

#Preview {
    ContentView()
}
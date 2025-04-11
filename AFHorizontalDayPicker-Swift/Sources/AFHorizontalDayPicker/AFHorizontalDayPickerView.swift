// 
// AFHorizontalDayPickerView.swift
// AFHorizontalDayPicker
//
// Created in 2025
// Swift 6 version of the original Objective-C component
//

import SwiftUI

/// A SwiftUI wrapper for the AFHorizontalDayPicker
public struct AFHorizontalDayPickerView: UIViewRepresentable {
    // MARK: - Properties
    
    /// The start date of the range to display
    public var startDate: Date
    
    /// The end date of the range to display
    public var endDate: Date
    
    /// The first date in the active range
    public var firstActiveDate: Date
    
    /// The last date in the active range
    public var lastActiveDate: Date
    
    /// The currently selected date
    @Binding public var selectedDate: Date?
    
    /// The width for each day cell
    public var cellWidth: CGFloat
    
    /// Whether to animate scrolling with physics
    public var animateScrolling: Bool
    
    /// Callback when a date is selected
    public var onDateSelected: ((Date) -> Void)?
    
    // MARK: - Appearance Properties
    
    /// Color for day numbers in active state
    public var dayNumberActiveColor: UIColor?
    
    /// Color for day numbers in inactive state
    public var dayNumberInactiveColor: UIColor?
    
    /// Color for day numbers in selected state
    public var dayNumberSelectedColor: UIColor?
    
    /// Background color for cells in active state
    public var backgroundActiveColor: UIColor?
    
    /// Background color for cells in inactive state
    public var backgroundInactiveColor: UIColor?
    
    /// Background color for cells in selected state
    public var backgroundSelectedColor: UIColor?
    
    // MARK: - Initialization
    
    /// Initialize the day picker view
    /// - Parameters:
    ///   - startDate: The start date of the range
    ///   - endDate: The end date of the range
    ///   - firstActiveDate: The first date in the active range
    ///   - lastActiveDate: The last date in the active range
    ///   - selectedDate: Binding to the selected date
    ///   - cellWidth: Width for each day cell
    ///   - animateScrolling: Whether to animate scrolling with physics
    ///   - onDateSelected: Callback when a date is selected
    public init(
        startDate: Date = Date(),
        endDate: Date? = nil,
        firstActiveDate: Date? = nil,
        lastActiveDate: Date? = nil,
        selectedDate: Binding<Date?>,
        cellWidth: CGFloat = 60.0,
        animateScrolling: Bool = true,
        onDateSelected: ((Date) -> Void)? = nil
    ) {
        self.startDate = startDate
        self.endDate = endDate ?? startDate.addingDays(30)
        self.firstActiveDate = firstActiveDate ?? startDate
        self.lastActiveDate = lastActiveDate ?? (endDate ?? startDate.addingDays(30))
        self._selectedDate = selectedDate
        self.cellWidth = cellWidth
        self.animateScrolling = animateScrolling
        self.onDateSelected = onDateSelected
    }
    
    // MARK: - UIViewRepresentable
    
    public func makeUIView(context: Context) -> AFHorizontalDayPicker {
        let dayPicker = AFHorizontalDayPicker()
        dayPicker.delegate = context.coordinator
        
        // Configure date ranges
        dayPicker.startDate = startDate
        dayPicker.endDate = endDate
        dayPicker.firstActiveDate = firstActiveDate
        dayPicker.lastActiveDate = lastActiveDate
        
        // Configure appearance
        if let color = dayNumberActiveColor {
            dayPicker.dayNumberActiveColor = color
        }
        
        if let color = dayNumberInactiveColor {
            dayPicker.dayNumberInactiveColor = color
        }
        
        if let color = dayNumberSelectedColor {
            dayPicker.dayNumberSelectedColor = color
        }
        
        if let color = backgroundActiveColor {
            dayPicker.backgroundActiveColor = color
        }
        
        if let color = backgroundInactiveColor {
            dayPicker.backgroundInactiveColor = color
        }
        
        if let color = backgroundSelectedColor {
            dayPicker.backgroundSelectedColor = color
        }
        
        dayPicker.animateScrolling = animateScrolling
        
        // Select initial date if provided
        if let date = selectedDate {
            dayPicker.selectDate(date, animated: false)
        }
        
        return dayPicker
    }
    
    public func updateUIView(_ dayPicker: AFHorizontalDayPicker, context: Context) {
        // Update date ranges if they changed
        if dayPicker.startDate != startDate {
            dayPicker.startDate = startDate
        }
        
        if dayPicker.endDate != endDate {
            dayPicker.endDate = endDate
        }
        
        if dayPicker.firstActiveDate != firstActiveDate {
            dayPicker.firstActiveDate = firstActiveDate
        }
        
        if dayPicker.lastActiveDate != lastActiveDate {
            dayPicker.lastActiveDate = lastActiveDate
        }
        
        // Update selected date if it changed
        if let date = selectedDate, dayPicker.selectedDate != date {
            dayPicker.selectDate(date, animated: true)
        }
        
        // Update appearance properties
        if let color = dayNumberActiveColor {
            dayPicker.dayNumberActiveColor = color
        }
        
        if let color = dayNumberInactiveColor {
            dayPicker.dayNumberInactiveColor = color
        }
        
        if let color = dayNumberSelectedColor {
            dayPicker.dayNumberSelectedColor = color
        }
        
        if let color = backgroundActiveColor {
            dayPicker.backgroundActiveColor = color
        }
        
        if let color = backgroundInactiveColor {
            dayPicker.backgroundInactiveColor = color
        }
        
        if let color = backgroundSelectedColor {
            dayPicker.backgroundSelectedColor = color
        }
        
        dayPicker.animateScrolling = animateScrolling
    }
    
    public func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    // MARK: - Coordinator
    
    public class Coordinator: NSObject, AFHorizontalDayPickerDelegate {
        private var parent: AFHorizontalDayPickerView
        
        init(_ parent: AFHorizontalDayPickerView) {
            self.parent = parent
        }
        
        public func horizontalDayPicker(_ picker: AFHorizontalDayPicker, widthForItemWith date: Date) -> CGFloat {
            return parent.cellWidth
        }
        
        public func horizontalDayPicker(_ picker: AFHorizontalDayPicker, didSelectDate date: Date) {
            parent.selectedDate = date
            parent.onDateSelected?(date)
        }
    }
}

// MARK: - Preview

#Preview {
    struct DayPickerPreview: View {
        @State private var selectedDate: Date? = Date()
        
        var body: some View {
            VStack {
                Text("Selected Date: \(selectedDate?.formatted(date: .long, time: .omitted) ?? "None")")
                    .padding()
                
                AFHorizontalDayPickerView(
                    selectedDate: $selectedDate,
                    cellWidth: 70,
                    animateScrolling: true,
                    onDateSelected: { date in
                        print("Selected date: \(date)")
                    }
                )
                .frame(height: 80)
                .padding()
                
                Button("Select Today") {
                    selectedDate = Date()
                }
                .padding()
            }
        }
    }
    
    return DayPickerPreview()
}
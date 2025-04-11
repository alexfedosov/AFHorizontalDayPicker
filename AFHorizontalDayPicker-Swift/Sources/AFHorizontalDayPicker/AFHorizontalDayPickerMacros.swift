// 
// AFHorizontalDayPickerMacros.swift
// AFHorizontalDayPicker
//
// Created in 2025
// Swift 6 version of the original Objective-C component
//

import SwiftUI

/// A macro that creates a day picker with a standard configuration
@freestanding(declaration)
public macro DayPicker(
    startDate: Date = Date(),
    days: Int = 30,
    activeRange: ClosedRange<Int> = 0...14
) -> AFHorizontalDayPicker = #externalMacro(module: "AFHorizontalDayPickerMacros", type: "DayPickerMacro")

/// Example usage of the macro (this would be expanded by the compiler)
/// 
/// ```swift
/// @DayPicker(startDate: Date(), days: 30, activeRange: 0...14)
/// var myDayPicker
/// 
/// // Expands to:
/// var myDayPicker: AFHorizontalDayPicker = {
///     let picker = AFHorizontalDayPicker(frame: .zero)
///     picker.startDate = Date()
///     picker.endDate = Date().addingDays(30)
///     picker.firstActiveDate = Date().addingDays(0)
///     picker.lastActiveDate = Date().addingDays(14)
///     return picker
/// }()
/// ```

/// A result builder for configuring day pickers
@resultBuilder
public struct DayPickerBuilder {
    public static func buildBlock(_ components: DayPickerComponent...) -> [DayPickerComponent] {
        return components
    }
    
    public static func buildExpression(_ expression: DayPickerComponent) -> DayPickerComponent {
        return expression
    }
    
    public static func buildFinalResult(_ components: [DayPickerComponent]) -> AFHorizontalDayPicker {
        let picker = AFHorizontalDayPicker(frame: .zero)
        
        for component in components {
            component.apply(to: picker)
        }
        
        return picker
    }
}

/// A component for the day picker builder
public protocol DayPickerComponent {
    func apply(to picker: AFHorizontalDayPicker)
}

/// Date range component
public struct DateRange: DayPickerComponent {
    let start: Date
    let end: Date
    
    public init(from start: Date, to end: Date) {
        self.start = start
        self.end = end
    }
    
    public func apply(to picker: AFHorizontalDayPicker) {
        picker.startDate = start
        picker.endDate = end
    }
}

/// Active range component
public struct ActiveRange: DayPickerComponent {
    let first: Date
    let last: Date
    
    public init(from first: Date, to last: Date) {
        self.first = first
        self.last = last
    }
    
    public func apply(to picker: AFHorizontalDayPicker) {
        picker.firstActiveDate = first
        picker.lastActiveDate = last
    }
}

/// Appearance component
public struct Appearance: DayPickerComponent {
    let dayNumberActiveColor: UIColor?
    let dayNumberSelectedColor: UIColor?
    let backgroundSelectedColor: UIColor?
    
    public init(
        dayNumberActiveColor: UIColor? = nil,
        dayNumberSelectedColor: UIColor? = nil,
        backgroundSelectedColor: UIColor? = nil
    ) {
        self.dayNumberActiveColor = dayNumberActiveColor
        self.dayNumberSelectedColor = dayNumberSelectedColor
        self.backgroundSelectedColor = backgroundSelectedColor
    }
    
    public func apply(to picker: AFHorizontalDayPicker) {
        if let color = dayNumberActiveColor {
            picker.dayNumberActiveColor = color
        }
        
        if let color = dayNumberSelectedColor {
            picker.dayNumberSelectedColor = color
        }
        
        if let color = backgroundSelectedColor {
            picker.backgroundSelectedColor = color
        }
    }
}

/// Example usage of the result builder:
/// 
/// ```swift
/// let picker = DayPicker {
///     DateRange(from: Date(), to: Date().addingDays(30))
///     ActiveRange(from: Date(), to: Date().addingDays(14))
///     Appearance(
///         dayNumberActiveColor: .black,
///         dayNumberSelectedColor: .white,
///         backgroundSelectedColor: .blue
///     )
/// }
/// ```

/// Function to create a day picker using the result builder
public func DayPicker(@DayPickerBuilder _ content: () -> AFHorizontalDayPicker) -> AFHorizontalDayPicker {
    return content()
}
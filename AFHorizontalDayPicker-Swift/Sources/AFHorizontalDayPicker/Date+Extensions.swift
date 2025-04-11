// 
// Date+Extensions.swift
// AFHorizontalDayPicker
//
// Created in 2025
// Swift 6 version of the original Objective-C component
//

import Foundation

/// Extensions to Date to replace the MTDates functionality
public extension Date {
    /// Returns a new date by adding the specified number of days
    /// - Parameter days: Number of days to add (can be negative)
    /// - Returns: A new date with the days added
    func addingDays(_ days: Int) -> Date {
        Calendar.current.date(byAdding: .day, value: days, to: self) ?? self
    }
    
    /// Returns the number of days between this date and another date
    /// - Parameter date: The date to calculate days from
    /// - Returns: Number of days between the dates
    func daysSince(_ date: Date) -> Int {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.day], from: date, to: self)
        return components.day ?? 0
    }
    
    /// Returns whether this date is between two other dates (inclusive)
    /// - Parameters:
    ///   - startDate: The start date
    ///   - endDate: The end date
    /// - Returns: True if this date is between or equal to the start and end dates
    func isBetween(_ startDate: Date, and endDate: Date) -> Bool {
        return (self >= startDate) && (self <= endDate)
    }
    
    /// Returns the day of the month component of this date
    /// - Returns: Day of month (1-31)
    var dayOfMonth: Int {
        return Calendar.current.component(.day, from: self)
    }
    
    /// Formats the date using the specified format string
    /// - Parameters:
    ///   - format: Format string (e.g., "EEE" for weekday abbreviation)
    ///   - localized: Whether to use the current locale
    /// - Returns: Formatted date string
    func string(withFormat format: String, localized: Bool = true) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        
        if localized {
            dateFormatter.locale = Locale.current
        } else {
            dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        }
        
        return dateFormatter.string(from: self)
    }
}
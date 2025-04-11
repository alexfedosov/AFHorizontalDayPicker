// 
// AFHorizontalDayPickerDelegate.swift
// AFHorizontalDayPicker
//
// Created in 2025
// Swift 6 version of the original Objective-C component
//

import UIKit

/// Delegate protocol for the horizontal day picker
public protocol AFHorizontalDayPickerDelegate: AnyObject {
    /// Called to determine the width for a cell representing a specific date
    /// - Parameters:
    ///   - picker: The day picker requesting the width
    ///   - date: The date for which to provide a width
    /// - Returns: The width for the cell
    func horizontalDayPicker(_ picker: AFHorizontalDayPicker, widthForItemWith date: Date) -> CGFloat
    
    /// Called when a date is selected in the day picker
    /// - Parameters:
    ///   - picker: The day picker where the selection occurred
    ///   - date: The selected date
    func horizontalDayPicker(_ picker: AFHorizontalDayPicker, didSelectDate date: Date)
    
    /// Optional method to customize the cell appearance
    /// - Parameters:
    ///   - picker: The day picker requesting customization
    ///   - cell: The cell to customize
    /// - Returns: The customized cell
    func horizontalDayPicker(_ picker: AFHorizontalDayPicker, requestCustomizedCellFrom cell: AFDayCell) -> AFDayCell
}
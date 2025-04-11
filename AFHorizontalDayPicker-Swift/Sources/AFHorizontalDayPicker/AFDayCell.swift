// 
// AFDayCell.swift
// AFHorizontalDayPicker
//
// Created in 2025
// Swift 6 version of the original Objective-C component
//

import UIKit

/// A collection view cell that represents a single day in the horizontal day picker
public final class AFDayCell: UICollectionViewCell {
    
    // MARK: - Public Properties
    
    /// The label displaying the day number (e.g., "23")
    public var dayNumber: UILabel!
    
    /// The label displaying the day name (e.g., "Mon")
    public var dayName: UILabel!
    
    /// The separator view on the left side of the cell
    public var leftSeparatorView: UIView!
    
    /// The separator view on the right side of the cell
    public var rightSeparatorView: UIView!
    
    /// The date represented by this cell
    public var date: Date?
    
    /// Whether this cell was selected
    public var wasSelected: Bool = false
    
    /// Whether this cell is active (within the active date range)
    public var active: Bool = false
    
    // MARK: - Initialization
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required public init?(coder: NSCoder) {
        super.init(coder: coder)
        setupViews()
    }
    
    // MARK: - Private Methods
    
    private func setupViews() {
        // Initial setup if needed
        // The actual content will be configured by the day picker
    }
    
    // MARK: - Layout
    
    override public func prepareForReuse() {
        super.prepareForReuse()
        dayNumber?.text = nil
        dayName?.text = nil
        date = nil
        wasSelected = false
        active = false
    }
}
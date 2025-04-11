// 
// AFHorizontalDayPicker.swift
// AFHorizontalDayPicker
//
// Created in 2025
// Swift 6 version of the original Objective-C component
//

import UIKit

/// A horizontal day picker that displays days in a scrollable collection view
public final class AFHorizontalDayPicker: UIView {
    
    // MARK: - Public Properties
    
    /// The delegate that will receive day picker events
    public weak var delegate: AFHorizontalDayPickerDelegate?
    
    /// The start date of the range to display
    public var startDate: Date {
        didSet {
            daysCollectionView.reloadData()
        }
    }
    
    /// The end date of the range to display
    public var endDate: Date {
        didSet {
            daysCollectionView.reloadData()
        }
    }
    
    /// The currently selected date
    public var selectedDate: Date? {
        didSet {
            guard let selectedDate = selectedDate,
                  let indexPath = indexPath(for: selectedDate) else { return }
            
            daysCollectionView.scrollToItem(
                at: indexPath,
                at: .centeredHorizontally,
                animated: true
            )
        }
    }
    
    /// The first date in the active range
    public var firstActiveDate: Date
    
    /// The last date in the active range
    public var lastActiveDate: Date
    
    // MARK: - Appearance Properties
    
    /// Color for day numbers in active state
    public var dayNumberActiveColor: UIColor?
    
    /// Color for day numbers in inactive state
    public var dayNumberInactiveColor: UIColor?
    
    /// Color for day numbers in selected state
    public var dayNumberSelectedColor: UIColor?
    
    /// Font for day numbers in active state
    public var dayNumberActiveFont: UIFont?
    
    /// Font for day numbers in inactive state
    public var dayNumberInactiveFont: UIFont?
    
    /// Font for day numbers in selected state
    public var dayNumberSelectedFont: UIFont?
    
    /// Color for day names in active state
    public var dayNameActiveColor: UIColor?
    
    /// Color for day names in inactive state
    public var dayNameInactiveColor: UIColor?
    
    /// Color for day names in selected state
    public var dayNameSelectedColor: UIColor?
    
    /// Font for day names in active state
    public var dayNameActiveFont: UIFont?
    
    /// Font for day names in inactive state
    public var dayNameInactiveFont: UIFont?
    
    /// Font for day names in selected state
    public var dayNameSelectedFont: UIFont?
    
    /// Background color for cells in active state
    public var backgroundActiveColor: UIColor?
    
    /// Background color for cells in inactive state
    public var backgroundInactiveColor: UIColor?
    
    /// Background color for cells in selected state
    public var backgroundSelectedColor: UIColor?
    
    /// Whether to show separators between cells
    public var showSeparatorsBetweenCells: Bool = false
    
    /// Whether to show the top separator
    public var showTopSeparator: Bool = false {
        didSet {
            topSeparator.isHidden = !showTopSeparator
            topSeparator.setNeedsDisplay()
        }
    }
    
    /// Whether to show the bottom separator
    public var showBottomSeparator: Bool = false {
        didSet {
            bottomSeparator.isHidden = !showBottomSeparator
            bottomSeparator.setNeedsDisplay()
        }
    }
    
    /// Color for separators in active state
    public var separatorActiveColor: UIColor?
    
    /// Color for separators in inactive state
    public var separatorInactiveColor: UIColor?
    
    /// Color for separators in selected state
    public var separatorSelectedColor: UIColor?
    
    /// Color for top and bottom separators
    public var topAndBottomSeparatorsColor: UIColor {
        didSet {
            topSeparator.backgroundColor = topAndBottomSeparatorsColor
            bottomSeparator.backgroundColor = topAndBottomSeparatorsColor
        }
    }
    
    /// Whether to animate scrolling with physics
    public var animateScrolling: Bool = false {
        didSet {
            let layout = AFDaysCollectionViewFlowLayout()
            layout.needAnimate = animateScrolling
            daysCollectionView.setCollectionViewLayout(layout, animated: false)
        }
    }
    
    // MARK: - Private Properties
    
    /// The collection view displaying the days
    private lazy var daysCollectionView: UICollectionView = {
        let layout = AFDaysCollectionViewFlowLayout()
        layout.needAnimate = animateScrolling
        
        let collectionView = UICollectionView(
            frame: CGRect(x: 0, y: 0.5, width: frame.width, height: frame.height - 1.0),
            collectionViewLayout: layout
        )
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(AFDayCell.self, forCellWithReuseIdentifier: "AFDayCell")
        collectionView.backgroundColor = .clear
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.clipsToBounds = true
        return collectionView
    }()
    
    /// The top separator view
    private lazy var topSeparator: UIView = {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: bounds.width, height: 0.5))
        view.backgroundColor = topAndBottomSeparatorsColor
        view.isHidden = !showTopSeparator
        return view
    }()
    
    /// The bottom separator view
    private lazy var bottomSeparator: UIView = {
        let view = UIView(frame: CGRect(x: 0, y: bounds.height - 0.5, width: bounds.width, height: 0.5))
        view.backgroundColor = topAndBottomSeparatorsColor
        view.isHidden = !showBottomSeparator
        return view
    }()
    
    // MARK: - Initialization
    
    /// Initialize with a frame
    /// - Parameter frame: The frame for the view
    public override init(frame: CGRect) {
        // Set default values
        self.startDate = Date()
        self.endDate = Date().addingDays(7)
        self.firstActiveDate = Date()
        self.lastActiveDate = Date().addingDays(7)
        self.topAndBottomSeparatorsColor = AFDefaultColorScheme.separatorActiveColor
        
        super.init(frame: frame)
        configure()
    }
    
    /// Initialize from a storyboard or nib
    /// - Parameter coder: The decoder
    required public init?(coder: NSCoder) {
        // Set default values
        self.startDate = Date()
        self.endDate = Date().addingDays(7)
        self.firstActiveDate = Date()
        self.lastActiveDate = Date().addingDays(7)
        self.topAndBottomSeparatorsColor = AFDefaultColorScheme.separatorActiveColor
        
        super.init(coder: coder)
        configure()
    }
    
    // MARK: - Configuration
    
    private func configure() {
        addSubview(daysCollectionView)
        addSubview(topSeparator)
        addSubview(bottomSeparator)
    }
    
    // MARK: - Layout
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        
        daysCollectionView.frame = CGRect(x: 0, y: 0.5, width: frame.width, height: frame.height - 1.0)
        topSeparator.frame = CGRect(x: 0, y: 0, width: bounds.width, height: 0.5)
        bottomSeparator.frame = CGRect(x: 0, y: bounds.height - 0.5, width: bounds.width, height: 0.5)
    }
    
    // MARK: - Helper Methods
    
    /// Get the date for a specific index path
    /// - Parameter indexPath: The index path
    /// - Returns: The date at that index path
    private func date(for indexPath: IndexPath) -> Date {
        return startDate.addingDays(indexPath.row)
    }
    
    /// Get the index path for a specific date
    /// - Parameter date: The date to find
    /// - Returns: The index path for that date, or nil if not in range
    private func indexPath(for date: Date) -> IndexPath? {
        let row = date.daysSince(startDate)
        
        if row < 0 {
            return nil
        }
        
        return IndexPath(row: row, section: 0)
    }
    
    /// Check if a date at an index path is active
    /// - Parameter indexPath: The index path to check
    /// - Returns: True if the date is in the active range
    private func isActiveDate(at indexPath: IndexPath) -> Bool {
        let date = self.date(for: indexPath)
        return date.isBetween(firstActiveDate.addingDays(-1), and: lastActiveDate.addingDays(1))
    }
    
    // MARK: - Cell Appearance
    
    /// Set active appearance for a cell
    /// - Parameter cell: The cell to style
    private func setActiveAppearance(for cell: AFDayCell) {
        cell.dayNumber.font = dayNumberActiveFont ?? AFDefaultColorScheme.dayNumberActiveFont
        cell.dayNumber.textColor = dayNumberActiveColor ?? AFDefaultColorScheme.dayNumberActiveColor
        
        cell.dayName.font = dayNameActiveFont ?? AFDefaultColorScheme.dayNameActiveFont
        cell.dayName.textColor = dayNameActiveColor ?? AFDefaultColorScheme.dayNameActiveColor
        
        cell.leftSeparatorView.backgroundColor = separatorActiveColor ?? AFDefaultColorScheme.separatorActiveColor
        cell.rightSeparatorView.backgroundColor = separatorActiveColor ?? AFDefaultColorScheme.separatorActiveColor
        
        cell.contentView.backgroundColor = backgroundActiveColor ?? AFDefaultColorScheme.backgroundActiveColor
    }
    
    /// Set inactive appearance for a cell
    /// - Parameter cell: The cell to style
    private func setInactiveAppearance(for cell: AFDayCell) {
        cell.dayNumber.font = dayNumberInactiveFont ?? AFDefaultColorScheme.dayNumberInactiveFont
        cell.dayNumber.textColor = dayNumberInactiveColor ?? AFDefaultColorScheme.dayNumberInactiveColor
        
        cell.dayName.font = dayNameInactiveFont ?? AFDefaultColorScheme.dayNameInactiveFont
        cell.dayName.textColor = dayNameInactiveColor ?? AFDefaultColorScheme.dayNameInactiveColor
        
        cell.leftSeparatorView.backgroundColor = separatorInactiveColor ?? AFDefaultColorScheme.separatorInactiveColor
        cell.rightSeparatorView.backgroundColor = separatorInactiveColor ?? AFDefaultColorScheme.separatorInactiveColor
        
        cell.contentView.backgroundColor = backgroundInactiveColor ?? AFDefaultColorScheme.backgroundInactiveColor
    }
    
    /// Set selected appearance for a cell
    /// - Parameter cell: The cell to style
    private func setSelectedAppearance(for cell: AFDayCell) {
        cell.dayNumber.font = dayNumberSelectedFont ?? AFDefaultColorScheme.dayNumberSelectedFont
        cell.dayNumber.textColor = dayNumberSelectedColor ?? AFDefaultColorScheme.dayNumberSelectedColor
        
        cell.dayName.font = dayNameSelectedFont ?? AFDefaultColorScheme.dayNameSelectedFont
        cell.dayName.textColor = dayNameSelectedColor ?? AFDefaultColorScheme.dayNameSelectedColor
        
        cell.leftSeparatorView.backgroundColor = separatorSelectedColor ?? AFDefaultColorScheme.separatorSelectedColor
        cell.rightSeparatorView.backgroundColor = separatorSelectedColor ?? AFDefaultColorScheme.separatorSelectedColor
        
        cell.contentView.backgroundColor = backgroundSelectedColor ?? AFDefaultColorScheme.backgroundSelectedColor
    }
    
    /// Default implementation of cell customization
    /// - Parameter cell: The cell to customize
    /// - Returns: The customized cell
    @objc func customizeCell(_ cell: AFDayCell) -> AFDayCell {
        // Remove any existing subviews
        cell.contentView.subviews.forEach { $0.removeFromSuperview() }
        
        // Configure day number (example: 23 or 1 or 45)
        let dayNumber = UILabel(frame: CGRect(
            x: 0,
            y: 0,
            width: cell.contentView.frame.width,
            height: cell.contentView.frame.height * 2/3
        ))
        dayNumber.textAlignment = .center
        dayNumber.text = "\(cell.date?.dayOfMonth ?? 0)"
        cell.dayNumber = dayNumber
        cell.contentView.addSubview(dayNumber)
        
        // Configure day name (example: Thu, Чт)
        let dayName = UILabel(frame: CGRect(
            x: 0,
            y: cell.contentView.frame.height * 2/3 - cell.contentView.frame.height/6,
            width: cell.contentView.frame.width,
            height: cell.contentView.frame.height/3
        ))
        dayName.textAlignment = .center
        dayName.text = cell.date?.string(withFormat: "EEE", localized: true)
        cell.dayName = dayName
        cell.contentView.addSubview(dayName)
        
        // Configure separators
        let leftSeparator = UIView(frame: CGRect(
            x: 0,
            y: 0,
            width: 0.5,
            height: cell.contentView.frame.height
        ))
        cell.leftSeparatorView = leftSeparator
        cell.contentView.addSubview(leftSeparator)
        
        let rightSeparator = UIView(frame: CGRect(
            x: cell.contentView.frame.width - 0.5,
            y: 0,
            width: 0.5,
            height: cell.contentView.frame.height
        ))
        cell.rightSeparatorView = rightSeparator
        cell.contentView.addSubview(rightSeparator)
        
        // Configure separator visibility
        if let date = cell.date, let indexPath = indexPath(for: date) {
            if showSeparatorsBetweenCells {
                cell.leftSeparatorView.isHidden = !(indexPath.row == 0)
                cell.rightSeparatorView.isHidden = false
            } else {
                cell.leftSeparatorView.isHidden = true
                cell.rightSeparatorView.isHidden = true
            }
        }
        
        // Apply appropriate appearance
        if !cell.active {
            setInactiveAppearance(for: cell)
        } else if cell.wasSelected {
            setSelectedAppearance(for: cell)
        } else {
            setActiveAppearance(for: cell)
        }
        
        return cell
    }
    
    // MARK: - Public Methods
    
    /// Select a specific date
    /// - Parameters:
    ///   - date: The date to select
    ///   - animated: Whether to animate the selection
    public func selectDate(_ date: Date, animated: Bool) {
        guard let indexPath = indexPath(for: date) else { return }
        
        daysCollectionView.selectItem(
            at: indexPath,
            animated: animated,
            scrollPosition: .centeredHorizontally
        )
        
        daysCollectionView.scrollToItem(
            at: indexPath,
            at: .centeredHorizontally,
            animated: animated
        )
        
        if let cell = daysCollectionView.cellForItem(at: indexPath) as? AFDayCell {
            setSelectedAppearance(for: cell)
        }
        
        selectedDate = date
        delegate?.horizontalDayPicker(self, didSelectDate: date)
    }
    
    /// Select today's date
    /// - Parameter animated: Whether to animate the selection
    public func selectToday(animated: Bool) {
        selectDate(Date(), animated: animated)
    }
}

// MARK: - UICollectionViewDataSource

extension AFHorizontalDayPicker: UICollectionViewDataSource {
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return endDate.daysSince(startDate)
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: "AFDayCell",
            for: indexPath
        ) as? AFDayCell else {
            fatalError("Failed to dequeue AFDayCell")
        }
        
        cell.date = date(for: indexPath)
        
        if let selectedIndexPath = collectionView.indexPathsForSelectedItems?.first {
            cell.wasSelected = indexPath.row == selectedIndexPath.row
        } else {
            cell.wasSelected = false
        }
        
        cell.active = isActiveDate(at: indexPath)
        
        // Customize the cell
        if let delegate = delegate, delegate.responds(to: #selector(AFHorizontalDayPickerDelegate.horizontalDayPicker(_:requestCustomizedCellFrom:))) {
            return delegate.horizontalDayPicker(self, requestCustomizedCellFrom: cell)
        } else {
            return customizeCell(cell)
        }
    }
}

// MARK: - UICollectionViewDelegate

extension AFHorizontalDayPicker: UICollectionViewDelegate {
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if !isActiveDate(at: indexPath) {
            return
        }
        
        guard let cell = collectionView.cellForItem(at: indexPath) as? AFDayCell else { return }
        setSelectedAppearance(for: cell)
        
        let selectedDate = date(for: indexPath)
        self.selectedDate = selectedDate
        
        delegate?.horizontalDayPicker(self, didSelectDate: selectedDate)
    }
    
    public func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? AFDayCell else { return }
        
        if isActiveDate(at: indexPath) {
            setActiveAppearance(for: cell)
        } else {
            setInactiveAppearance(for: cell)
        }
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension AFHorizontalDayPicker: UICollectionViewDelegateFlowLayout {
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width: CGFloat
        
        if let delegate = delegate {
            width = delegate.horizontalDayPicker(self, widthForItemWith: date(for: indexPath))
        } else {
            width = collectionView.frame.height
        }
        
        return CGSize(width: width, height: collectionView.frame.height)
    }
}
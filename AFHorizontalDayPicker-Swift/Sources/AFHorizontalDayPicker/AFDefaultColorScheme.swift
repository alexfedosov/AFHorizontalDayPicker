// 
// AFDefaultColorScheme.swift
// AFHorizontalDayPicker
//
// Created in 2025
// Swift 6 version of the original Objective-C component
//

import UIKit

/// Default color and font scheme for the day picker
public enum AFDefaultColorScheme {
    // MARK: - Day Number Colors
    
    /// Default color for day numbers in active state
    public static let dayNumberActiveColor: UIColor = .black
    
    /// Default color for day numbers in inactive state
    public static let dayNumberInactiveColor: UIColor = .gray
    
    /// Default color for day numbers in selected state
    public static let dayNumberSelectedColor: UIColor = .white
    
    // MARK: - Day Number Fonts
    
    /// Default font for day numbers in active state
    public static let dayNumberActiveFont: UIFont = .init(name: "HelveticaNeue-Thin", size: 25.0) ?? .systemFont(ofSize: 25.0, weight: .thin)
    
    /// Default font for day numbers in inactive state
    public static let dayNumberInactiveFont: UIFont = .init(name: "HelveticaNeue-Thin", size: 25.0) ?? .systemFont(ofSize: 25.0, weight: .thin)
    
    /// Default font for day numbers in selected state
    public static let dayNumberSelectedFont: UIFont = .init(name: "HelveticaNeue-Thin", size: 25.0) ?? .systemFont(ofSize: 25.0, weight: .thin)
    
    // MARK: - Day Name Colors
    
    /// Default color for day names in active state
    public static let dayNameActiveColor: UIColor = .black
    
    /// Default color for day names in inactive state
    public static let dayNameInactiveColor: UIColor = .gray
    
    /// Default color for day names in selected state
    public static let dayNameSelectedColor: UIColor = .white
    
    // MARK: - Day Name Fonts
    
    /// Default font for day names in active state
    public static let dayNameActiveFont: UIFont = .init(name: "HelveticaNeue", size: 12.0) ?? .systemFont(ofSize: 12.0)
    
    /// Default font for day names in inactive state
    public static let dayNameInactiveFont: UIFont = .init(name: "HelveticaNeue", size: 12.0) ?? .systemFont(ofSize: 12.0)
    
    /// Default font for day names in selected state
    public static let dayNameSelectedFont: UIFont = .init(name: "HelveticaNeue", size: 12.0) ?? .systemFont(ofSize: 12.0)
    
    // MARK: - Background Colors
    
    /// Default background color for cells in active state
    public static let backgroundActiveColor: UIColor = .white
    
    /// Default background color for cells in inactive state
    public static let backgroundInactiveColor: UIColor = .white
    
    /// Default background color for cells in selected state
    public static let backgroundSelectedColor: UIColor = UIColor(red: 20.0/255.0, green: 128.0/255.0, blue: 255.0/255.0, alpha: 1.0)
    
    // MARK: - Separator Colors
    
    /// Default separator color for cells in active state
    public static let separatorActiveColor: UIColor = .lightGray
    
    /// Default separator color for cells in inactive state
    public static let separatorInactiveColor: UIColor = .lightGray
    
    /// Default separator color for cells in selected state
    public static let separatorSelectedColor: UIColor = .lightGray
}
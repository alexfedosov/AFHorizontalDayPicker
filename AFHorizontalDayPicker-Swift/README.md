# AFHorizontalDayPicker

A Swift 6 implementation of a horizontal day picker for iOS applications.

## Features

- Horizontal scrolling day picker with customizable appearance
- Support for active and inactive date ranges
- Physics-based scrolling animations
- Fully customizable cell appearance
- Swift Package Manager support

## Requirements

- iOS 15.0+
- Swift 6.0+

## Installation

### Swift Package Manager

Add the following to your `Package.swift` file:

```swift
dependencies: [
    .package(url: "https://github.com/yourusername/AFHorizontalDayPicker.git", from: "1.0.0")
]
```

Or add it directly in Xcode using File > Add Packages...

## Usage

```swift
import AFHorizontalDayPicker

class ViewController: UIViewController, AFHorizontalDayPickerDelegate {
    
    private var dayPicker: AFHorizontalDayPicker!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Initialize the day picker
        dayPicker = AFHorizontalDayPicker(frame: CGRect(x: 0, y: 100, width: view.bounds.width, height: 80))
        dayPicker.delegate = self
        
        // Configure date range
        dayPicker.startDate = Date()
        dayPicker.endDate = Date().addingDays(30)
        
        // Configure active date range
        dayPicker.firstActiveDate = Date()
        dayPicker.lastActiveDate = Date().addingDays(14)
        
        // Customize appearance (optional)
        dayPicker.dayNumberSelectedColor = .white
        dayPicker.dayNameSelectedColor = .white
        dayPicker.backgroundSelectedColor = .systemBlue
        
        // Add to view
        view.addSubview(dayPicker)
        
        // Select today
        dayPicker.selectToday(animated: true)
    }
    
    // MARK: - AFHorizontalDayPickerDelegate
    
    func horizontalDayPicker(_ picker: AFHorizontalDayPicker, widthForItemWith date: Date) -> CGFloat {
        return 60.0
    }
    
    func horizontalDayPicker(_ picker: AFHorizontalDayPicker, didSelectDate date: Date) {
        print("Selected date: \(date)")
    }
}
```

## Customization

The day picker provides extensive customization options:

- Colors for day numbers, day names, backgrounds, and separators
- Fonts for day numbers and day names
- Separator visibility
- Physics-based scrolling animations

## License

This project is available under the MIT license. See the LICENSE file for more info.
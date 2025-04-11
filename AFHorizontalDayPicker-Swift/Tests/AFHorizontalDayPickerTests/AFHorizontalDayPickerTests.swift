import XCTest
@testable import AFHorizontalDayPicker

final class AFHorizontalDayPickerTests: XCTestCase {
    func testDayPickerInitialization() {
        let dayPicker = AFHorizontalDayPicker(frame: CGRect(x: 0, y: 0, width: 320, height: 80))
        XCTAssertNotNil(dayPicker)
        XCTAssertNotNil(dayPicker.startDate)
        XCTAssertNotNil(dayPicker.endDate)
    }
    
    func testDateExtensions() {
        let today = Date()
        let tomorrow = today.addingDays(1)
        
        XCTAssertEqual(tomorrow.daysSince(today), 1)
        XCTAssertTrue(today.isBetween(today.addingDays(-1), and: today.addingDays(1)))
    }
}
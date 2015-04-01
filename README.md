# AFHorizontalDayPicker

[![CI Status](http://img.shields.io/travis/Alexander Fedosov/AFHorizontalDayPicker.svg?style=flat)](https://travis-ci.org/Alexander Fedosov/AFHorizontalDayPicker)
[![Version](https://img.shields.io/cocoapods/v/AFHorizontalDayPicker.svg?style=flat)](http://cocoapods.org/pods/AFHorizontalDayPicker)
[![License](https://img.shields.io/cocoapods/l/AFHorizontalDayPicker.svg?style=flat)](http://cocoapods.org/pods/AFHorizontalDayPicker)
[![Platform](https://img.shields.io/cocoapods/p/AFHorizontalDayPicker.svg?style=flat)](http://cocoapods.org/pods/AFHorizontalDayPicker)

[![](https://raw.github.com/alexfedosov/AFHorizontalDayPicker/master/Screens/2.png)](https://raw.github.com/alexfedosov/AFHorizontalDayPicker/master/Screens/2.png)
[![](https://raw.github.com/alexfedosov/AFHorizontalDayPicker/master/Screens/3.png)](https://raw.github.com/alexfedosov/AFHorizontalDayPicker/master/Screens/3.png)
[![](https://raw.github.com/alexfedosov/AFHorizontalDayPicker/master/Screens/4.png)](https://raw.github.com/alexfedosov/AFHorizontalDayPicker/master/Screens/4.png)
[![](https://raw.github.com/alexfedosov/AFHorizontalDayPicker/master/Screens/5.png)](https://raw.github.com/alexfedosov/AFHorizontalDayPicker/master/Screens/5.png)

## Installation

AFHorizontalDayPicker is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod "AFHorizontalDayPicker"
```

## Usage

Install library via cocoapods as it describe above, then add property

``` objective-c
@property (strong, nonatomic) AFHorizontalDayPicker *picker;
```

Init then setup picker using start and end dates:

``` objective-c
- (void)viewDidLoad
{
    [super viewDidLoad];

    AFHorizontalDayPicker *picker = [[AFHorizontalDayPicker alloc] initWithFrame:CGRectMake(0, 40, self.view.frame.size.width, 60.0f)];
    picker.delegate = self;
    picker.startDate = [[NSDate date] mt_dateDaysBefore:7];
    picker.endDate = [[NSDate date] mt_dateDaysAfter:14];
    [picker selectTodayAnimated:NO];

    [self.view addSubview:picker];
}
```

Implement the required delegate method to be notified when a new day item is selected and configure picker cell width (cell height will be same as the controll height)

``` objective-c

- (CGFloat)horizontalDayPicker:(AFHorizontalDayPicker *)picker widthForItemWithDate:(NSDate *)date{
    return 60.0f;
}

- (void)horizontalDayPicker:(AFHorizontalDayPicker *)picker didSelectDate:(NSDate *)date{
    NSLog(@"selected date %@", date);
}

```

## Appearance configuration (Optional: all colors and fonts)

First way:

``` objective-c

@property (nonatomic, strong) UIColor *dayNumberActiveColor;
@property (nonatomic, strong) UIColor *dayNumberInactiveColor;
@property (nonatomic, strong) UIColor *dayNumberSelectedColor;

@property (nonatomic, strong) UIFont *dayNumberActiveFont;
@property (nonatomic, strong) UIFont *dayNumberInactiveFont;
@property (nonatomic, strong) UIFont *dayNumberSelectedFont;

@property (nonatomic, strong) UIColor *dayNameActiveColor;
@property (nonatomic, strong) UIColor *dayNameInactiveColor;
@property (nonatomic, strong) UIColor *dayNameSelectedColor;

@property (nonatomic, strong) UIFont *dayNameActiveFont;
@property (nonatomic, strong) UIFont *dayNameInactiveFont;
@property (nonatomic, strong) UIFont *dayNameSelectedFont;

@property (nonatomic, strong) UIColor *backgroundActiveColor;
@property (nonatomic, strong) UIColor *backgroundInactiveColor;
@property (nonatomic, strong) UIColor *backgroundSelectedColor;

```

Second way - use optional delegate to configure custom cell:

``` objective-c
- (AFDayCell *)horizontalDayPicker:(AFHorizontalDayPicker *)picker requestCustomizedCellFromCell:(AFDayCell*)cell;
```

##Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Author

Alexander Fedosov, alexander.a.fedosov@gmail.com

## License

AFHorizontalDayPicker is available under the MIT license. See the LICENSE file for more info.

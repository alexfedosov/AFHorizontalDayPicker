//
//  AFHorizontalDayPicker.h
//  AFHorizontalDayPickerExample
//
//  Created by Alexander Fedosov on 31.03.15.
//  Copyright (c) 2015 alexfedosov. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AFDayCell.h"

@class AFHorizontalDayPicker;

@protocol AFHorizontalDayPickerDelegate <NSObject>
@required
- (CGFloat)horizontalDayPicker:(AFHorizontalDayPicker *)picker widthForItemWithDate:(NSDate *)date;
- (void)horizontalDayPicker:(AFHorizontalDayPicker *)picker didSelectDate:(NSDate *)date;

@optional
- (AFDayCell *)horizontalDayPicker:(AFHorizontalDayPicker *)picker requestCustomizedCellFromCell:(AFDayCell*)cell;

@end

@interface AFHorizontalDayPicker : UIView

@property (nonatomic, weak) id<AFHorizontalDayPickerDelegate> delegate;

@property (nonatomic, strong) NSDate *startDate;
@property (nonatomic, strong) NSDate *endDate;
@property (nonatomic, strong) NSDate *selectedDate;

@property (nonatomic, strong) NSDate *firstActiveDate;
@property (nonatomic, strong) NSDate *lastActiveDate;

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

@property (nonatomic, assign) BOOL showSeparatorsBetweenCells;
@property (nonatomic, strong) UIColor *separatorActiveColor;
@property (nonatomic, strong) UIColor *separatorInactiveColor;
@property (nonatomic, strong) UIColor *separatorSelectedColor;

- (void)selectDate:(NSDate *)date animated:(BOOL)animated;
- (void)selectTodayAnimated:(BOOL)animated;

@end

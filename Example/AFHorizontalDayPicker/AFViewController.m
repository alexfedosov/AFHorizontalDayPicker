//
//  AFViewController.m
//  AFHorizontalDayPicker
//
//  Created by Alexander Fedosov on 03/31/2015.
//  Copyright (c) 2014 Alexander Fedosov. All rights reserved.
//

#import "AFViewController.h"
#import "AFHorizontalDayPicker.h"
#import "NSDate+MTDates.h"

@interface AFViewController () <AFHorizontalDayPickerDelegate>

@end

@implementation AFViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    
    AFHorizontalDayPicker *picker = [[AFHorizontalDayPicker alloc] initWithFrame:CGRectMake(0, 40, self.view.frame.size.width, 50.0f)];
    picker.delegate = self;
    picker.startDate = [[NSDate date] mt_dateDaysBefore:14];
    picker.endDate = [[NSDate date] mt_dateDaysAfter:14];
    [picker selectTodayAnimated:NO];
    
    [self.view addSubview:picker];
}

- (CGFloat)horizontalDayPicker:(AFHorizontalDayPicker *)picker widthForItemWithDate:(NSDate *)date{
    return 90.0f;
}

- (void)horizontalDayPicker:(AFHorizontalDayPicker *)picker didSelectDate:(NSDate *)date{
    NSLog(@"selected date %@", date);
}

@end

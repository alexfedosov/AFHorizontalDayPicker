//
//  AFHorizontalDayPicker.m
//  AFHorizontalDayPickerExample
//
//  Created by Alexander Fedosov on 31.03.15.
//  Copyright (c) 2015 alexfedosov. All rights reserved.
//

#import "AFHorizontalDayPicker.h"
#import "AFDaysCollectionViewFlowLayout.h"
#import "NSDate+MTDates.h"

@interface AFHorizontalDayPicker()<UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) UICollectionView *daysCollectionView;

@end

@implementation AFHorizontalDayPicker

@synthesize startDate = _startDate;
@synthesize endDate = _endDate;

- (instancetype)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    [self configure];
    
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder{
    
    self = [super initWithCoder:aDecoder];
    [self configure];

    return self;
}

- (NSDate *)startDate{
    
    if (!_startDate) {
        _startDate = [NSDate date];
    }
    
    return _startDate;
}

- (NSDate *)endDate{
    
    if (!_endDate) {
        _endDate = [[NSDate date] mt_dateDaysAfter:7];
    }
    
    return _endDate;
}

- (NSDate *)firstActiveDate{
    if (!_firstActiveDate) {
        _firstActiveDate = [NSDate date];
    }
    
    return _firstActiveDate;
}

- (NSDate *)lastActiveDate{
    if (!_lastActiveDate) {
        _lastActiveDate = self.endDate;
    }
    
    return _lastActiveDate;
}

- (void)configure{
    
    AFDaysCollectionViewFlowLayout *layout=[[AFDaysCollectionViewFlowLayout alloc] init];
    [layout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
    [layout setMinimumInteritemSpacing:.0f];
    [layout setMinimumLineSpacing:.0f];
    
    self.daysCollectionView = [[UICollectionView alloc] initWithFrame:self.bounds
                                                 collectionViewLayout:layout];
    [self.daysCollectionView setDataSource:self];
    [self.daysCollectionView setDelegate:self];
    
    [self.daysCollectionView registerClass:[AFDayCell class] forCellWithReuseIdentifier:NSStringFromClass([AFDayCell class])];
    [self.daysCollectionView setBackgroundColor:[UIColor clearColor]];
    [self.daysCollectionView setShowsHorizontalScrollIndicator:NO];
    
    [self addSubview:self.daysCollectionView];
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    self.daysCollectionView.frame = self.bounds;
    
}

- (void)setStartDate:(NSDate *)startDate{
    _startDate = startDate;
    [self.daysCollectionView reloadData];
}

- (void)setEndDate:(NSDate *)endDate{
    _endDate = endDate;
    [self.daysCollectionView reloadData];
}

- (void)setSelectedDate:(NSDate *)selectedDate{
    
    [self.daysCollectionView scrollToItemAtIndexPath:[self indexPathForDate:selectedDate] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
    
    _selectedDate = selectedDate;
}

- (NSDate *)dateForIndexPath:(NSIndexPath *)indexPath{
    return [self.startDate mt_dateDaysAfter:indexPath.row];
}

- (NSIndexPath *)indexPathForDate:(NSDate *)date{
    
    NSInteger row = [date mt_daysSinceDate:self.startDate];
    
    if (row < 0) {
        return nil;
    }
    
    return [NSIndexPath indexPathForRow:row inSection:0];
}


- (BOOL)isActiveDateAtIndexPath:(NSIndexPath *)indexPath{
    NSDate *selectedDate = [self dateForIndexPath:indexPath];
    return [selectedDate mt_isBetweenDate:[self.firstActiveDate mt_dateDaysBefore:1] andDate:[self.lastActiveDate mt_dateDaysAfter:1]];
}

#pragma mark - collectionView dataSource -

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return [self.endDate mt_daysSinceDate:self.startDate];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    AFDayCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([AFDayCell class])
                                                                forIndexPath:indexPath];
    
    cell.date = [self dateForIndexPath:indexPath];
    
    if (self.delegate && [self.delegate conformsToProtocol:@protocol(AFHorizontalDayPickerDelegate)] && [self.delegate respondsToSelector:@selector(horizontalDayPicker:requestCustomizedCellFromCell:)]) {
        [self.delegate horizontalDayPicker:self requestCustomizedCellFromCell:cell];
    }else{
        [cell.contentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
        
        UILabel *dayNumber = [[UILabel alloc] initWithFrame:cell.contentView.bounds];
        
        dayNumber.textAlignment = NSTextAlignmentCenter;
        dayNumber.text = [NSString stringWithFormat:@"%@", @([[self dateForIndexPath:indexPath] mt_dayOfMonth])];
        cell.dayNumber = dayNumber;
        [cell.contentView addSubview:dayNumber];
        
        UILabel *dayName = [[UILabel alloc] initWithFrame:CGRectMake(.0f, cell.contentView.frame.size.height - 20.0f, cell.contentView.frame.size.width, 20.0f)];
        dayName.textAlignment = NSTextAlignmentCenter;
        dayName.text = [NSString stringWithFormat:@"%@", [[self dateForIndexPath:indexPath] mt_stringFromDateWithFormat:@"EEE" localized:YES]];
        cell.dayName = dayName;
        [cell.contentView addSubview:dayName];
        
        if (![self isActiveDateAtIndexPath:indexPath]) {
            dayNumber.font = (_dayNumberInactiveFont)?:[UIFont fontWithName:@"HelveticaNeue-Thin" size:25.0f];
            dayNumber.textColor = (_dayNumberInactiveColor)?:[UIColor grayColor];
            
            dayName.font = (_dayNameInactiveFont)?:[UIFont fontWithName:@"HelveticaNeue" size:12.0f];
            dayName.textColor = (_dayNameInactiveColor)?:[UIColor grayColor];
            
            cell.contentView.backgroundColor = (_backgroundInactiveColor)?:[UIColor whiteColor];
        }else{
            dayNumber.font = (_dayNumberActiveFont)?:[UIFont fontWithName:@"HelveticaNeue-Thin" size:25.0f];
            dayNumber.textColor = (_dayNumberActiveColor)?:[UIColor blackColor];
            
            dayName.font = (_dayNameActiveFont)?:[UIFont fontWithName:@"HelveticaNeue" size:12.0f];
            dayName.textColor = (_dayNameActiveColor)?:[UIColor blackColor];
            
            cell.contentView.backgroundColor = (_backgroundActiveColor)?:[UIColor whiteColor];
        }
        
    }
    
    return cell;
}

#pragma mark - collectionView delegate -

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{

    if (![self isActiveDateAtIndexPath:indexPath]) {
        return;
    }
    
    AFDayCell *cell = (AFDayCell *)[collectionView cellForItemAtIndexPath:indexPath];
    cell.contentView.backgroundColor = (_backgroundSelectedColor)?:[UIColor colorWithRed:20.0f/255.0f green:128.0f/255.0f blue:255.0f/255.0f alpha:1.0f];
    cell.dayNumber.textColor = (_dayNumberSelectedColor)?:[UIColor whiteColor];
    cell.dayName.textColor = (_dayNumberSelectedColor)?:[UIColor whiteColor];
    
    self.selectedDate = [self dateForIndexPath:indexPath];
    
    if (self.delegate && [self.delegate conformsToProtocol:@protocol(AFHorizontalDayPickerDelegate)]) {
        [self.delegate horizontalDayPicker:self didSelectDate:[self dateForIndexPath:indexPath]];
    }
}

- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    AFDayCell *cell = (AFDayCell *)[collectionView cellForItemAtIndexPath:indexPath];
    cell.contentView.backgroundColor = (_backgroundActiveColor)?:[UIColor whiteColor];
    cell.dayNumber.textColor = (_dayNumberSelectedColor)?:[UIColor blackColor];
    cell.dayName.textColor = (_dayNumberSelectedColor)?:[UIColor blackColor];
}

#pragma mark - collectionView flow layout -

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    CGFloat width = self.frame.size.height;
    
    if (self.delegate && [self.delegate conformsToProtocol:@protocol(AFHorizontalDayPickerDelegate)]) {
        width = [self.delegate horizontalDayPicker:self widthForItemWithDate:[self dateForIndexPath:indexPath]];
    }
    
    return CGSizeMake(width, self.frame.size.height);
}

#pragma mark - Public control methods-

- (void)selectDate:(NSDate *)date animated:(BOOL)animated{
    NSIndexPath *indexPath = [self indexPathForDate:date];
    
    if (indexPath) {
        [self.daysCollectionView selectItemAtIndexPath:indexPath animated:animated scrollPosition:UICollectionViewScrollPositionCenteredHorizontally];
    }
}

- (void)selectTodayAnimated:(BOOL)animated{
    [self selectDate:[NSDate date] animated:animated];
}

@end

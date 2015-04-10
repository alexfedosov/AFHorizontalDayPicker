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
#import "AFDefaultColorScheme.h"

@interface AFHorizontalDayPicker()<UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) UICollectionView *daysCollectionView;
@property (nonatomic, strong) UIView *topSeparator;
@property (nonatomic, strong) UIView *bottomSeparator;

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
    
    AFDaysCollectionViewFlowLayout *layout = [AFDaysCollectionViewFlowLayout new];
    layout.needAnimate = self.animateScrolling;
    
    self.daysCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(.0f, .5f, self.frame.size.width, self.frame.size.height - 1.0f)
                                                 collectionViewLayout:layout];
    [self.daysCollectionView setDataSource:self];
    [self.daysCollectionView setDelegate:self];
    
    [self.daysCollectionView registerClass:[AFDayCell class] forCellWithReuseIdentifier:NSStringFromClass([AFDayCell class])];
    [self.daysCollectionView setBackgroundColor:[UIColor clearColor]];
    [self.daysCollectionView setShowsHorizontalScrollIndicator:NO];
    self.daysCollectionView.clipsToBounds = YES;
    [self addSubview:self.daysCollectionView];
    
    self.topSeparator = [[UIView alloc] initWithFrame:CGRectMake(.0f, .0f, self.bounds.size.width, .5f)];
    self.bottomSeparator = [[UIView alloc] initWithFrame:CGRectMake(.0f, self.bounds.size.height - 1.f, self.bounds.size.width, .5f)];
    
    if (!_topAndBottomSeparatorsColor) {
        _topAndBottomSeparatorsColor = default_separatorActiveColor;
    }
    
    self.topSeparator.backgroundColor = _topAndBottomSeparatorsColor;
    self.bottomSeparator.backgroundColor = _topAndBottomSeparatorsColor;
    
    self.topSeparator.hidden = !_showTopSeparator;
    self.bottomSeparator.hidden = !_bottomSeparator;
    
    [self addSubview:self.topSeparator];
    [self addSubview:self.bottomSeparator];
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    self.daysCollectionView.frame = CGRectMake(.0f, .5f, self.frame.size.width, self.frame.size.height - 1.0f);
    self.topSeparator.frame = CGRectMake(.0f, .0f, self.bounds.size.width, .5f);
    self.bottomSeparator.frame = CGRectMake(.0f, self.bounds.size.height - 1.f, self.bounds.size.width, .5f);
}

- (void)setAnimateScrolling:(BOOL)animateScrolling{
    _animateScrolling = animateScrolling;
    
    AFDaysCollectionViewFlowLayout *layout = [AFDaysCollectionViewFlowLayout new];
    layout.needAnimate = self.animateScrolling;
    
    [self.daysCollectionView setCollectionViewLayout:layout];
}

- (void)setTopAndBottomSeparatorsColor:(UIColor *)topAndBottomSeparatorsColor{
    _topAndBottomSeparatorsColor = topAndBottomSeparatorsColor;
    self.topSeparator.backgroundColor = _topAndBottomSeparatorsColor;
    self.bottomSeparator.backgroundColor = _topAndBottomSeparatorsColor;
}

- (void)setShowBottomSeparator:(BOOL)showBottomSeparator{
    _showBottomSeparator = showBottomSeparator;
    self.bottomSeparator.hidden = !_bottomSeparator;
    [self.bottomSeparator setNeedsDisplay];
}

- (void)setShowTopSeparator:(BOOL)showTopSeparator{
    _showTopSeparator = showTopSeparator;
    self.topSeparator.hidden = !_showTopSeparator;
    [self.topSeparator setNeedsDisplay];
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
    
    NSIndexPath *selectedIndexPath = [collectionView.indexPathsForSelectedItems firstObject];
    cell.wasSelected = (selectedIndexPath && indexPath.row == selectedIndexPath.row);
    
    cell.active = [self isActiveDateAtIndexPath:indexPath];
    
    id responder = nil;
    
    if (self.delegate
        && [self.delegate conformsToProtocol:@protocol(AFHorizontalDayPickerDelegate)]
        && [self.delegate respondsToSelector:@selector(horizontalDayPicker:requestCustomizedCellFromCell:)]) {
        
        responder = self.delegate;
        
    }else{

        responder = self;
    }
    
    [responder horizontalDayPicker:self requestCustomizedCellFromCell:cell];
    
    return cell;
}

- (void)setActiveAppearanceWithCell:(AFDayCell *)cell{
    
    cell.dayNumber.font = (_dayNumberActiveFont)?:default_dayNumberActiveFont;
    cell.dayNumber.textColor = (_dayNumberActiveColor)?:default_dayNumberActiveColor;
    
    cell.dayName.font = (_dayNameActiveFont)?:default_dayNameActiveFont;
    cell.dayName.textColor = (_dayNameActiveColor)?:default_dayNameActiveColor;
    
    cell.leftSeparatorView.backgroundColor = (_separatorActiveColor)?:default_separatorActiveColor;
    cell.rightSeparatorView.backgroundColor = (_separatorActiveColor)?:default_separatorActiveColor;
    
    cell.contentView.backgroundColor = (_backgroundActiveColor)?:default_backgroundActiveColor;
    
}

- (void)setInactiveAppearanceWithCell:(AFDayCell *)cell{
    
    cell.dayNumber.font = (_dayNumberInactiveFont)?:default_dayNumberInactiveFont;
    cell.dayNumber.textColor = (_dayNumberInactiveColor)?:default_dayNameInactiveColor;
    
    cell.dayName.font = (_dayNameInactiveFont)?:default_dayNameInactiveFont;
    cell.dayName.textColor = (_dayNameInactiveColor)?:default_dayNameInactiveColor;
    
    cell.leftSeparatorView.backgroundColor = (_separatorInactiveColor)?:default_separatorInactiveColor;
    cell.rightSeparatorView.backgroundColor = (_separatorInactiveColor)?:default_separatorInactiveColor;
    
    cell.contentView.backgroundColor = (_backgroundInactiveColor)?:default_backgroundInactiveColor;
}

- (void)setSelectedAppearanceWithCell:(AFDayCell *)cell{
    
    cell.dayNumber.font = (_dayNumberSelectedFont)?:default_dayNumberSelectedFont;
    cell.dayNumber.textColor = (_dayNumberSelectedColor)?:default_dayNumberSelectedColor;
    
    cell.dayName.font = (_dayNameSelectedFont)?:default_dayNameSelectedFont;
    cell.dayName.textColor = (_dayNameSelectedColor)?:default_dayNameSelectedColor;
    
    cell.leftSeparatorView.backgroundColor = (_separatorSelectedColor)?:default_separatorSelectedColor;
    cell.rightSeparatorView.backgroundColor = (_separatorSelectedColor)?:default_separatorSelectedColor;
    
    cell.contentView.backgroundColor = (_backgroundSelectedColor)?:default_backgroundSelectedColor;
}

- (AFDayCell *)horizontalDayPicker:(AFHorizontalDayPicker *)picker requestCustomizedCellFromCell:(AFDayCell*)cell{
    
    [cell.contentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    // configure day number (example: 23 or 1 or 45)
    UILabel *dayNumber = [[UILabel alloc] initWithFrame:CGRectMake(.0f, .0f, cell.contentView.frame.size.width, cell.contentView.frame.size.height/3*2)];
    dayNumber.textAlignment = NSTextAlignmentCenter;
    dayNumber.text = [NSString stringWithFormat:@"%@", @([cell.date mt_dayOfMonth])];
    cell.dayNumber = dayNumber;
    [cell.contentView addSubview:dayNumber];
    
    // configure day name (example: Thu, Чт)
    UILabel *dayName = [[UILabel alloc] initWithFrame:CGRectMake(.0f, cell.contentView.frame.size.height/3*2 - cell.contentView.frame.size.height/6, cell.contentView.frame.size.width, cell.contentView.frame.size.height/3)];
    dayName.textAlignment = NSTextAlignmentCenter;
    dayName.text = [cell.date mt_stringFromDateWithFormat:@"EEE" localized:YES];
    cell.dayName = dayName;
    [cell.contentView addSubview:dayName];
    
    // configure separators
    UIView *leftSeparator = [[UIView alloc] initWithFrame:CGRectMake(.0f, .0f, .5f, cell.contentView.frame.size.height)];
    cell.leftSeparatorView = leftSeparator;
    [cell.contentView addSubview:cell.leftSeparatorView];
    
    UIView *rightSeparator = [[UIView alloc] initWithFrame:CGRectMake(cell.contentView.frame.size.width - .5f, .0f, .5f, cell.contentView.frame.size.height)];
    cell.rightSeparatorView = rightSeparator;
    [cell.contentView addSubview:cell.rightSeparatorView];
    
    NSIndexPath *indexPath = [self indexPathForDate:cell.date];
    
    if (self.showSeparatorsBetweenCells) {
        cell.leftSeparatorView.hidden = !(indexPath.row == 0);
        cell.rightSeparatorView.hidden = NO;
    }else{
        cell.leftSeparatorView.hidden = YES;
        cell.rightSeparatorView.hidden = YES;
    }
    
    if (!cell.active) {
        [self setInactiveAppearanceWithCell:cell];
    }else{
        if (cell.wasSelected) {
            [self setSelectedAppearanceWithCell:cell];
        }else{
            [self setActiveAppearanceWithCell:cell];
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
    [self setSelectedAppearanceWithCell:cell];
    
    self.selectedDate = [self dateForIndexPath:indexPath];
    
    if (self.delegate && [self.delegate conformsToProtocol:@protocol(AFHorizontalDayPickerDelegate)]) {
        [self.delegate horizontalDayPicker:self didSelectDate:[self dateForIndexPath:indexPath]];
    }
}

- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    AFDayCell *cell = (AFDayCell *)[collectionView cellForItemAtIndexPath:indexPath];
    
    if ([self isActiveDateAtIndexPath:indexPath]) {
        [self setActiveAppearanceWithCell:cell];
    }else{
        [self setInactiveAppearanceWithCell:cell];
    }
    
}

#pragma mark - collectionView flow layout -

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    CGFloat width = collectionView.frame.size.height;
    
    if (self.delegate && [self.delegate conformsToProtocol:@protocol(AFHorizontalDayPickerDelegate)]) {
        width = [self.delegate horizontalDayPicker:self widthForItemWithDate:[self dateForIndexPath:indexPath]];
    }
    
    return CGSizeMake(width, collectionView.frame.size.height);
}

#pragma mark - Public control methods-

- (void)selectDate:(NSDate *)date animated:(BOOL)animated{
    NSIndexPath *indexPath = [self indexPathForDate:date];
    
    if (indexPath) {
        [self.daysCollectionView selectItemAtIndexPath:indexPath
                                              animated:animated
                                        scrollPosition:UICollectionViewScrollPositionCenteredHorizontally];
        [self.daysCollectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally
                                                animated:animated];
        [self collectionView:self.daysCollectionView didSelectItemAtIndexPath:indexPath];
    }
}

- (void)selectTodayAnimated:(BOOL)animated{
    [self selectDate:[NSDate date] animated:animated];
}

@end

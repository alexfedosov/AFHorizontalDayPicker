//
//  AFDayCell.h
//  Pods
//
//  Created by Alexander Fedosov on 31.03.15.
//
//

#import <UIKit/UIKit.h>

@interface AFDayCell : UICollectionViewCell

@property (nonatomic, strong) UILabel *dayNumber;
@property (nonatomic, strong) UILabel *dayName;
@property (nonatomic, strong) UIView *leftSeparatorView;
@property (nonatomic, strong) UIView *rightSeparatorView;

@property (nonatomic, strong) NSDate *date;
@property (nonatomic, assign) BOOL wasSelected;
@property (nonatomic, assign) BOOL active;

@end

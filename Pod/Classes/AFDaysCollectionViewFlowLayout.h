//
//  AFDaysCollectionViewFlowLayout.h
//  AFHorizontalDayPickerExample
//
//  Created by Alexander Fedosov on 31.03.15.
//  Copyright (c) 2015 alexfedosov. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AFDaysCollectionViewFlowLayout : UICollectionViewFlowLayout

/// The default resistance factor that determines the bounce of the collection. Default is 900.0f.
#define kScrollResistanceFactorDefault 900.0f;

/// The scrolling resistance factor determines how much bounce / resistance the collection has. A higher number is less bouncy, a lower number is more bouncy. The default is 900.0f.
@property (nonatomic, assign) CGFloat scrollResistanceFactor;

/// The dynamic animator used to animate the collection's bounce
@property (nonatomic, strong, readonly) UIDynamicAnimator *dynamicAnimator;
@property (nonatomic, assign) BOOL needAnimate;

@end

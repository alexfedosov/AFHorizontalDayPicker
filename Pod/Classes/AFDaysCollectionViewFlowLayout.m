//
//  AFDaysCollectionViewFlowLayout.m
//  AFHorizontalDayPickerExample
//
//  Created by Alexander Fedosov on 31.03.15.
//  Copyright (c) 2015 alexfedosov. All rights reserved.
//

#import "AFDaysCollectionViewFlowLayout.h"

@interface AFDaysCollectionViewFlowLayout()

/// The dynamic animator used to animate the collection's bounce
@property (nonatomic, strong, readwrite) UIDynamicAnimator *dynamicAnimator;

// Needed for tiling
@property (nonatomic, strong) NSMutableSet *visibleIndexPathsSet;
@property (nonatomic, strong) NSMutableSet *visibleHeaderAndFooterSet;
@property (nonatomic, assign) CGFloat latestDelta;
@property (nonatomic, assign) UIInterfaceOrientation interfaceOrientation;

@end

@implementation AFDaysCollectionViewFlowLayout

- (instancetype)init {
    
    if (!(self = [super init])) return nil;
    
    [self setScrollDirection:UICollectionViewScrollDirectionHorizontal];
    [self setMinimumInteritemSpacing:.0f];
    [self setMinimumLineSpacing:.0f];
    
    [self setup];
    
    return self;
}


- (void)setup {
    _dynamicAnimator = [[UIDynamicAnimator alloc] initWithCollectionViewLayout:self];
    _visibleIndexPathsSet = [NSMutableSet set];
    _visibleHeaderAndFooterSet = [[NSMutableSet alloc] init];
}

- (void)setNeedAnimate:(BOOL)needAnimate{
    _needAnimate = needAnimate;
    
    if (!_needAnimate) {
        _dynamicAnimator = nil;
    }else{
        _dynamicAnimator = [[UIDynamicAnimator alloc] initWithCollectionViewLayout:self];
    }
}

- (void)prepareLayout {
    [super prepareLayout];
    
    if (!_needAnimate) {
        return;
    }
    
    if ([[UIApplication sharedApplication] statusBarOrientation] != self.interfaceOrientation) {
        [self.dynamicAnimator removeAllBehaviors];
        self.visibleIndexPathsSet = [NSMutableSet set];
    }
    
    self.interfaceOrientation = [[UIApplication sharedApplication] statusBarOrientation];
    
    CGRect visibleRect = CGRectInset((CGRect){.origin = self.collectionView.bounds.origin, .size = self.collectionView.frame.size}, -100, -100);
    
    NSArray *itemsInVisibleRectArray = [super layoutAttributesForElementsInRect:visibleRect];
    
    NSSet *itemsIndexPathsInVisibleRectSet = [NSSet setWithArray:[itemsInVisibleRectArray valueForKey:@"indexPath"]];
    
    NSArray *noLongerVisibleBehaviours = [self.dynamicAnimator.behaviors filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(UIAttachmentBehavior *behaviour, NSDictionary *bindings) {
        return [itemsIndexPathsInVisibleRectSet containsObject:[(UICollectionViewLayoutAttributes *)[[behaviour items] firstObject] indexPath]] == NO;
    }]];
    
    [noLongerVisibleBehaviours enumerateObjectsUsingBlock:^(id obj, NSUInteger index, BOOL *stop) {
        [self.dynamicAnimator removeBehavior:obj];
        [self.visibleIndexPathsSet removeObject:[(UICollectionViewLayoutAttributes *)[[obj items] firstObject] indexPath]];
        [self.visibleHeaderAndFooterSet removeObject:[(UICollectionViewLayoutAttributes *)[[obj items] firstObject] indexPath]];
    }];
    
    NSArray *newlyVisibleItems = [itemsInVisibleRectArray filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(UICollectionViewLayoutAttributes *item, NSDictionary *bindings) {
        return (item.representedElementCategory == UICollectionElementCategoryCell ?
                [self.visibleIndexPathsSet containsObject:item.indexPath] : [self.visibleHeaderAndFooterSet containsObject:item.indexPath]) == NO;
    }]];
    
    CGPoint touchLocation = [self.collectionView.panGestureRecognizer locationInView:self.collectionView];
    
    [newlyVisibleItems enumerateObjectsUsingBlock:^(UICollectionViewLayoutAttributes *item, NSUInteger idx, BOOL *stop) {
        CGPoint center = item.center;
        UIAttachmentBehavior *springBehaviour = [[UIAttachmentBehavior alloc] initWithItem:item attachedToAnchor:center];
        
        springBehaviour.length = 1.0f;
        springBehaviour.damping = 0.8f;
        springBehaviour.frequency = 1.0f;
        
        // If our touchLocation is not (0,0), we'll need to adjust our item's center "in flight"
        if (!CGPointEqualToPoint(CGPointZero, touchLocation)) {
            if (self.scrollDirection == UICollectionViewScrollDirectionVertical) {
                CGFloat distanceFromTouch = fabsf(touchLocation.y - springBehaviour.anchorPoint.y);
                
                CGFloat scrollResistance;
                if (self.scrollResistanceFactor) scrollResistance = distanceFromTouch / self.scrollResistanceFactor;
                else scrollResistance = distanceFromTouch / kScrollResistanceFactorDefault;
                
                if (self.latestDelta < 0) center.y += MAX(self.latestDelta, self.latestDelta*scrollResistance);
                else center.y += MIN(self.latestDelta, self.latestDelta*scrollResistance);
                
                item.center = center;
                
            } else {
                CGFloat distanceFromTouch = fabsf(touchLocation.x - springBehaviour.anchorPoint.x);
                
                CGFloat scrollResistance;
                if (self.scrollResistanceFactor) scrollResistance = distanceFromTouch / self.scrollResistanceFactor;
                else scrollResistance = distanceFromTouch / kScrollResistanceFactorDefault;
                
                if (self.latestDelta < 0) center.x += MAX(self.latestDelta, self.latestDelta*scrollResistance);
                else center.x += MIN(self.latestDelta, self.latestDelta*scrollResistance);
                
                item.center = center;
            }
        }
        
        [self.dynamicAnimator addBehavior:springBehaviour];
        if(item.representedElementCategory == UICollectionElementCategoryCell)
        {
            [self.visibleIndexPathsSet addObject:item.indexPath];
        }
        else
        {
            [self.visibleHeaderAndFooterSet addObject:item.indexPath];
        }
    }];
}

- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect {
    
    if (!_needAnimate) {
        return [super layoutAttributesForElementsInRect:rect];
    }
    
    return [self.dynamicAnimator itemsInRect:rect];
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if (!_needAnimate) {
        return [super layoutAttributesForItemAtIndexPath:indexPath];
    }
    
    UICollectionViewLayoutAttributes *dynamicLayoutAttributes = [self.dynamicAnimator layoutAttributesForCellAtIndexPath:indexPath];
    return (dynamicLayoutAttributes)?dynamicLayoutAttributes:[super layoutAttributesForItemAtIndexPath:indexPath];
}

- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds {
    
    if (!_needAnimate) {
        return [super shouldInvalidateLayoutForBoundsChange:newBounds];
    }
    
    UIScrollView *scrollView = self.collectionView;
    
    CGFloat delta;
    if (self.scrollDirection == UICollectionViewScrollDirectionVertical) delta = newBounds.origin.y - scrollView.bounds.origin.y;
    else delta = newBounds.origin.x - scrollView.bounds.origin.x;
    
    self.latestDelta = delta;
    
    CGPoint touchLocation = [self.collectionView.panGestureRecognizer locationInView:self.collectionView];
    
    [self.dynamicAnimator.behaviors enumerateObjectsUsingBlock:^(UIAttachmentBehavior *springBehaviour, NSUInteger idx, BOOL *stop) {
        if (self.scrollDirection == UICollectionViewScrollDirectionVertical) {
            CGFloat distanceFromTouch = fabsf(touchLocation.y - springBehaviour.anchorPoint.y);
            
            CGFloat scrollResistance;
            if (self.scrollResistanceFactor) scrollResistance = distanceFromTouch / self.scrollResistanceFactor;
            else scrollResistance = distanceFromTouch / kScrollResistanceFactorDefault;
            
            UICollectionViewLayoutAttributes *item = [springBehaviour.items firstObject];
            CGPoint center = item.center;
            if (delta < 0) center.y += MAX(delta, delta*scrollResistance);
            else center.y += MIN(delta, delta*scrollResistance);
            
            item.center = center;
            
            [self.dynamicAnimator updateItemUsingCurrentState:item];
        } else {
            CGFloat distanceFromTouch = fabsf(touchLocation.x - springBehaviour.anchorPoint.x);
            
            CGFloat scrollResistance;
            if (self.scrollResistanceFactor) scrollResistance = distanceFromTouch / self.scrollResistanceFactor;
            else scrollResistance = distanceFromTouch / kScrollResistanceFactorDefault;
            
            UICollectionViewLayoutAttributes *item = [springBehaviour.items firstObject];
            CGPoint center = item.center;
            if (delta < 0) center.x += MAX(delta, delta*scrollResistance);
            else center.x += MIN(delta, delta*scrollResistance);
            
            item.center = center;
            
            [self.dynamicAnimator updateItemUsingCurrentState:item];
        }
    }];
    
    return NO;
}

- (void)prepareForCollectionViewUpdates:(NSArray *)updateItems {
    [super prepareForCollectionViewUpdates:updateItems];
    
    if (!_needAnimate) {
        return;
    }
    
    [updateItems enumerateObjectsUsingBlock:^(UICollectionViewUpdateItem *updateItem, NSUInteger idx, BOOL *stop) {
        if (updateItem.updateAction == UICollectionUpdateActionInsert) {
            if([self.dynamicAnimator layoutAttributesForCellAtIndexPath:updateItem.indexPathAfterUpdate])
            {
                return;
            }
            
            UICollectionViewLayoutAttributes *attributes = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:updateItem.indexPathAfterUpdate];

            
            UIAttachmentBehavior *springBehaviour = [[UIAttachmentBehavior alloc] initWithItem:attributes attachedToAnchor:attributes.center];
            
            springBehaviour.length = 10.0f;
            springBehaviour.damping = 0.8f;
            springBehaviour.frequency = 1.0f;
            [self.dynamicAnimator addBehavior:springBehaviour];
        }
    }];
}

@end

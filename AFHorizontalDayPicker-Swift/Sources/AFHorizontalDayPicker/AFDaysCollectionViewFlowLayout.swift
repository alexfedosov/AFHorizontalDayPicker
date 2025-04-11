// 
// AFDaysCollectionViewFlowLayout.swift
// AFHorizontalDayPicker
//
// Created in 2025
// Swift 6 version of the original Objective-C component
//

import UIKit

/// A custom collection view flow layout that provides bouncy/elastic scrolling for the day picker
public final class AFDaysCollectionViewFlowLayout: UICollectionViewFlowLayout {
    
    // MARK: - Constants
    
    /// The default resistance factor that determines the bounce of the collection
    private static let defaultScrollResistanceFactor: CGFloat = 900.0
    
    // MARK: - Public Properties
    
    /// The scrolling resistance factor determines how much bounce/resistance the collection has.
    /// A higher number is less bouncy, a lower number is more bouncy. The default is 900.0.
    public var scrollResistanceFactor: CGFloat = defaultScrollResistanceFactor
    
    /// Whether the layout should animate with physics-based behaviors
    public var needAnimate: Bool = true {
        didSet {
            if needAnimate != oldValue {
                if needAnimate {
                    dynamicAnimator = UIDynamicAnimator(collectionViewLayout: self)
                } else {
                    dynamicAnimator = nil
                }
            }
        }
    }
    
    // MARK: - Private Properties
    
    /// The dynamic animator used to animate the collection's bounce
    private var dynamicAnimator: UIDynamicAnimator?
    
    /// Visible index paths for efficient updates
    private var visibleIndexPathsSet = Set<IndexPath>()
    
    /// Visible headers and footers for efficient updates
    private var visibleHeaderAndFooterSet = Set<IndexPath>()
    
    /// The latest scroll delta for physics calculations
    private var latestDelta: CGFloat = 0
    
    /// Current interface orientation to detect orientation changes
    private var interfaceOrientation: UIInterfaceOrientation = .unknown
    
    // MARK: - Initialization
    
    public override init() {
        super.init()
        
        scrollDirection = .horizontal
        minimumInteritemSpacing = 0
        minimumLineSpacing = 0
        
        setup()
    }
    
    required public init?(coder: NSCoder) {
        super.init(coder: coder)
        
        scrollDirection = .horizontal
        minimumInteritemSpacing = 0
        minimumLineSpacing = 0
        
        setup()
    }
    
    private func setup() {
        dynamicAnimator = UIDynamicAnimator(collectionViewLayout: self)
        visibleIndexPathsSet = []
        visibleHeaderAndFooterSet = []
    }
    
    // MARK: - Layout Methods
    
    public override func prepare() {
        super.prepare()
        
        guard needAnimate, let dynamicAnimator = dynamicAnimator else { return }
        
        let currentOrientation = UIApplication.shared.statusBarOrientation
        if interfaceOrientation != currentOrientation {
            dynamicAnimator.removeAllBehaviors()
            visibleIndexPathsSet.removeAll()
        }
        
        interfaceOrientation = currentOrientation
        
        guard let collectionView = collectionView else { return }
        
        // Create a slightly larger rect to include items just outside the visible area
        let visibleRect = CGRect(
            origin: collectionView.bounds.origin,
            size: collectionView.frame.size
        ).insetBy(dx: -100, dy: -100)
        
        guard let itemsInVisibleRectArray = super.layoutAttributesForElements(in: visibleRect) else { return }
        
        // Get index paths for all visible items
        let itemsIndexPathsInVisibleRectSet = Set(itemsInVisibleRectArray.compactMap { $0.indexPath })
        
        // Remove behaviors for items that are no longer visible
        let noLongerVisibleBehaviors = dynamicAnimator.behaviors.compactMap { behavior -> UIAttachmentBehavior? in
            guard let behavior = behavior as? UIAttachmentBehavior,
                  let item = behavior.items.first as? UICollectionViewLayoutAttributes,
                  let indexPath = item.indexPath,
                  !itemsIndexPathsInVisibleRectSet.contains(indexPath) else {
                return nil
            }
            return behavior
        }
        
        for behavior in noLongerVisibleBehaviors {
            dynamicAnimator.removeBehavior(behavior)
            if let item = behavior.items.first as? UICollectionViewLayoutAttributes,
               let indexPath = item.indexPath {
                visibleIndexPathsSet.remove(indexPath)
                visibleHeaderAndFooterSet.remove(indexPath)
            }
        }
        
        // Add behaviors for newly visible items
        let newlyVisibleItems = itemsInVisibleRectArray.filter { item in
            if item.representedElementCategory == .cell {
                return !visibleIndexPathsSet.contains(item.indexPath)
            } else {
                return !visibleHeaderAndFooterSet.contains(item.indexPath)
            }
        }
        
        let touchLocation = collectionView.panGestureRecognizer.location(in: collectionView)
        
        for item in newlyVisibleItems {
            let center = item.center
            let springBehavior = UIAttachmentBehavior(item: item, attachedToAnchor: center)
            
            springBehavior.length = 1.0
            springBehavior.damping = 0.8
            springBehavior.frequency = 1.0
            
            // Adjust item's center "in flight" if we have a touch location
            if touchLocation != .zero {
                var newCenter = center
                
                if scrollDirection == .vertical {
                    let distanceFromTouch = abs(touchLocation.y - springBehavior.anchorPoint.y)
                    let scrollResistance = distanceFromTouch / scrollResistanceFactor
                    
                    if latestDelta < 0 {
                        newCenter.y += max(latestDelta, latestDelta * scrollResistance)
                    } else {
                        newCenter.y += min(latestDelta, latestDelta * scrollResistance)
                    }
                } else {
                    let distanceFromTouch = abs(touchLocation.x - springBehavior.anchorPoint.x)
                    let scrollResistance = distanceFromTouch / scrollResistanceFactor
                    
                    if latestDelta < 0 {
                        newCenter.x += max(latestDelta, latestDelta * scrollResistance)
                    } else {
                        newCenter.x += min(latestDelta, latestDelta * scrollResistance)
                    }
                }
                
                item.center = newCenter
            }
            
            dynamicAnimator.addBehavior(springBehavior)
            
            if item.representedElementCategory == .cell {
                visibleIndexPathsSet.insert(item.indexPath)
            } else {
                visibleHeaderAndFooterSet.insert(item.indexPath)
            }
        }
    }
    
    public override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        if !needAnimate {
            return super.layoutAttributesForElements(in: rect)
        }
        
        return dynamicAnimator?.items(in: rect) as? [UICollectionViewLayoutAttributes]
    }
    
    public override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        if !needAnimate {
            return super.layoutAttributesForItem(at: indexPath)
        }
        
        if let dynamicLayoutAttributes = dynamicAnimator?.layoutAttributesForCell(at: indexPath) {
            return dynamicLayoutAttributes
        }
        
        return super.layoutAttributesForItem(at: indexPath)
    }
    
    public override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        if !needAnimate {
            return super.shouldInvalidateLayout(forBoundsChange: newBounds)
        }
        
        guard let collectionView = collectionView,
              let dynamicAnimator = dynamicAnimator else {
            return super.shouldInvalidateLayout(forBoundsChange: newBounds)
        }
        
        let delta: CGFloat
        if scrollDirection == .vertical {
            delta = newBounds.origin.y - collectionView.bounds.origin.y
        } else {
            delta = newBounds.origin.x - collectionView.bounds.origin.x
        }
        
        latestDelta = delta
        
        let touchLocation = collectionView.panGestureRecognizer.location(in: collectionView)
        
        for case let springBehavior as UIAttachmentBehavior in dynamicAnimator.behaviors {
            guard let item = springBehavior.items.first as? UICollectionViewLayoutAttributes else { continue }
            
            var center = item.center
            
            if scrollDirection == .vertical {
                let distanceFromTouch = abs(touchLocation.y - springBehavior.anchorPoint.y)
                let scrollResistance = distanceFromTouch / scrollResistanceFactor
                
                if delta < 0 {
                    center.y += max(delta, delta * scrollResistance)
                } else {
                    center.y += min(delta, delta * scrollResistance)
                }
            } else {
                let distanceFromTouch = abs(touchLocation.x - springBehavior.anchorPoint.x)
                let scrollResistance = distanceFromTouch / scrollResistanceFactor
                
                if delta < 0 {
                    center.x += max(delta, delta * scrollResistance)
                } else {
                    center.x += min(delta, delta * scrollResistance)
                }
            }
            
            item.center = center
            dynamicAnimator.updateItem(usingCurrentState: item)
        }
        
        return false
    }
    
    public override func prepare(forCollectionViewUpdates updateItems: [UICollectionViewUpdateItem]) {
        super.prepare(forCollectionViewUpdates: updateItems)
        
        guard needAnimate, let dynamicAnimator = dynamicAnimator else { return }
        
        for updateItem in updateItems {
            if updateItem.updateAction == .insert {
                guard let indexPathAfterUpdate = updateItem.indexPathAfterUpdate,
                      dynamicAnimator.layoutAttributesForCell(at: indexPathAfterUpdate) == nil else {
                    continue
                }
                
                let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPathAfterUpdate)
                let springBehavior = UIAttachmentBehavior(item: attributes, attachedToAnchor: attributes.center)
                
                springBehavior.length = 10.0
                springBehavior.damping = 0.8
                springBehavior.frequency = 1.0
                
                dynamicAnimator.addBehavior(springBehavior)
            }
        }
    }
}
//
//  SelfSizingFlowLayout.swift
//  ModernRolodex
//
//  Created by Ryan Fox on 5/5/18.
//  Copyright © 2018 Wailord. All rights reserved.
//

import UIKit

protocol SelfSizingFlowLayoutDelegate: class {
    func heightForItem(at indexPath: IndexPath, withWidth width: CGFloat) -> CGFloat
}

class SelfSizingFlowLayout: UICollectionViewFlowLayout {
    
    // MARK: - Configurable/public properties
    public var itemsPerRow = 2 {
        didSet {
            // lazy way out, but outside the scope of this project (for now)
            self.collectionView?.reloadData()
        }
    }
    
    public var distanceBetweenRows: CGFloat = 5 {
        didSet {
            // lazy way out, but outside the scope of this project (for now)
            self.collectionView?.reloadData()
        }
    }
    
    fileprivate var calculatedContentWidth: CGFloat {
        guard let collectionView = collectionView else {
            return 0
        }
        let insets = collectionView.contentInset
        return collectionView.bounds.width - insets.left - insets.right
    }
    
    override var collectionViewContentSize: CGSize {
        return CGSize(width: self.calculatedContentWidth, height: self.calculatedContentHeight)
    }
    
    // MARK: - General required stuff
    
    public weak var delegate: SelfSizingFlowLayoutDelegate?
    
    override init() {
        super.init()
        self.estimatedItemSize = CGSize(width: 300, height: 100)
        self.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        self.itemSize = UICollectionViewFlowLayoutAutomaticSize
        self.minimumInteritemSpacing = 15
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Private helpers
    
    private var calculatedAttributes: [UICollectionViewLayoutAttributes] = []
    private var calculatedContentHeight: CGFloat = 0
    
    private var usableWidthPerItem: CGFloat {
        get {
            // how much width can we use in total right now?
            let contentInsets = self.collectionView!.contentInset.left + self.collectionView!.contentInset.right
            let sectionInsets = self.sectionInset.left + self.sectionInset.right
            
            let usableWidth = self.collectionView!.frame.width - contentInsets - sectionInsets - 2
            let intercardSpacingPerRow = (CGFloat(self.itemsPerRow) - 1) * self.minimumInteritemSpacing
            let usableWidthPerCard = (usableWidth - intercardSpacingPerRow) / CGFloat(self.itemsPerRow)
            return usableWidthPerCard
        }
    }
    
    // used as to avoid calculating heights more than necessary
    private var itemHeights: [CGFloat?] = []
    
    // used for animations
    private var insertingPaths: [IndexPath] = []
    private var deletingPaths: [IndexPath] = []
}

extension SelfSizingFlowLayout {
    // whenever our layout is deemed invalid, we need to relayout our collection and store the information
    // later collection view lifecycle methods will query for different things, but they'll pull from the
    // calculations we do here
    override func prepare() {
        // don't recalculate everything if we haven't cleared our cache
        guard self.calculatedAttributes.isEmpty, let collectionView = collectionView else {
            return
        }
        
        let itemWidth = self.usableWidthPerItem
        
        // we already know where all of our items lie on the x-axis based on their column number alone,
        // so we can make this a let
        let xCoordinates: [CGFloat] = (0 ..< self.itemsPerRow).map { CGFloat($0) * (itemWidth + self.minimumInteritemSpacing) + self.sectionInset.left }
        
        // our y-coordinates vary depending on previous height calculations, so this array needs to be
        // mutable. this array will keep track of our last-used height for each column, which we'll
        // need to know when setting the y-coordinates for the next row
        var lastUsedYCoordinateForSections: [CGFloat] = Array(repeating: 0, count: self.itemsPerRow)
        
        var currentColumn = 0
        for item in 0 ..< collectionView.numberOfItems(inSection: 0) {
            let path = IndexPath(item: item, section: 0)
            
            let itemHeight = self.height(for: path)
            let heightWithSpacing = 2 * self.distanceBetweenRows + itemHeight
            
            // we want our frame to account for extra vertical spacing, but the inset frame is what's actually used for our cell
            let frameWithSpacing = CGRect(x: xCoordinates[currentColumn], y: lastUsedYCoordinateForSections[currentColumn], width: itemWidth, height: heightWithSpacing)
            let insetFrame = frameWithSpacing.insetBy(dx: 0, dy: self.distanceBetweenRows)
            
            // build our attributes that actually store the salient info
            let attributes = UICollectionViewLayoutAttributes(forCellWith: path)
            attributes.frame = insetFrame
            self.calculatedAttributes.append(attributes)
            
            // did our latest cell make our collection bigger? update if so
            self.calculatedContentHeight = max(self.calculatedContentHeight, frameWithSpacing.maxY)
            lastUsedYCoordinateForSections[currentColumn] = lastUsedYCoordinateForSections[currentColumn] + heightWithSpacing
            
            currentColumn = currentColumn < (self.itemsPerRow - 1) ? (currentColumn + 1) : 0
        }
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        // once we're here, we've already been through the prepare() step, so we can just loop over our
        // calculations and return the relevant ones
        return self.calculatedAttributes.compactMap { return $0.frame.intersects(rect) ? $0 : nil }
    }
    
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        return self.calculatedAttributes[indexPath.item]
    }
}

// MARK: - Height/reordering methods
extension SelfSizingFlowLayout {
    private func height(for path: IndexPath) -> CGFloat {
        // if our height cache is out of sync, refill it with blank data
        if self.itemHeights.count < self.collectionView!.numberOfItems(inSection: 0) {
            self.resetHeightCache()
        }
        
        // if we don't have a height for a particular item, calculate it and populate the cache
        if self.itemHeights[path.item] == nil {
            let height = self.delegate!.heightForItem(at: path, withWidth: self.usableWidthPerItem)
            self.itemHeights[path.item] = height
        }
        return self.itemHeights[path.item]!
    }
    
    private func resetHeightCache() {
        self.itemHeights = Array(repeating: nil, count: self.collectionView!.numberOfItems(inSection: 0))
    }
    
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return newBounds.width != self.collectionView!.bounds.width
    }
    
    override func invalidateLayout(with context: UICollectionViewLayoutInvalidationContext) {
        // for whatever reason, we can get called with an uninitialized context and crash
        // avoid that, because it's bad
        let nillableContext: UICollectionViewLayoutInvalidationContext? = context
        guard nillableContext != nil else {
            return
        }
        
        // regardless of anything else, if we're invalidating our entire layout, the attributes or height may change.
        // as a result, we shouldn't cache this. item heights should remain static most of the time, though, so keep that
        // cache and selectively clear it out depending on what behavior we observe
        self.calculatedAttributes = []
        self.calculatedContentHeight = 0
        
        // custom invalidation context allows us to know inside of prepare if we're being triggered by a reload
        if let reloadingContext = context as? FlowLayoutReloadingInvalidationContext {
            reloadingContext.reloadingPaths.forEach { self.itemHeights[$0.item] = nil }
        }
        
        // if we're throwing out everything, make sure the heights go with ti
        if context.invalidateEverything {
            self.itemHeights = []
        }
        
        super.invalidateLayout(with: context)
    }
    
    // if we're invalidated due to changing bounds, our heights aren't valid anymore
    override func invalidationContext(forBoundsChange newBounds: CGRect) -> UICollectionViewLayoutInvalidationContext {
        self.resetHeightCache()
        return super.invalidationContext(forBoundsChange: newBounds)
    }
}

// MARK: - Insertion/deletion/update handling
extension SelfSizingFlowLayout {
    override func prepare(forCollectionViewUpdates updateItems: [UICollectionViewUpdateItem]) {
        super.prepare(forCollectionViewUpdates: updateItems)
        let inserts = updateItems.filter { $0.updateAction == .insert }
        let deletes = updateItems.filter { $0.updateAction == .delete }
        let moves = updateItems.filter { $0.updateAction == .move }
        
        inserts.forEach {
            self.insertingPaths.append($0.indexPathAfterUpdate!)
            self.itemHeights.insert(nil, at: $0.indexPathAfterUpdate!.item)
        }
        
        deletes.forEach {
            self.deletingPaths.append($0.indexPathBeforeUpdate!)
            self.itemHeights.remove(at: $0.indexPathBeforeUpdate!.item)
        }
        
        moves.forEach {
            // we're moving index paths, so swap the sizes
            let old = self.itemHeights[$0.indexPathBeforeUpdate!.item]
            self.itemHeights.remove(at: $0.indexPathBeforeUpdate!.item)
            self.itemHeights.insert(old, at: $0.indexPathAfterUpdate!.item)
        }
    }
    
    override func finalizeCollectionViewUpdates() {
        super.finalizeCollectionViewUpdates()
        
        // done animating, so these paths are no longer relevant
        self.insertingPaths = []
        self.deletingPaths = []
    }
    
    override func initialLayoutAttributesForAppearingItem(at itemIndexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        let attr = super.initialLayoutAttributesForAppearingItem(at: itemIndexPath)
        if self.insertingPaths.contains(itemIndexPath) {
            attr?.alpha = 0.0
            attr?.transform = .init(scaleX: 0.2, y: 0.2)
        }
        return attr
    }
    
    override func finalLayoutAttributesForDisappearingItem(at itemIndexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        let attr = super.finalLayoutAttributesForDisappearingItem(at: itemIndexPath)
        if self.deletingPaths.contains(itemIndexPath) {
            attr?.alpha = 0.0
            attr?.transform = attr!.transform.translatedBy(x: 0, y: 800).rotated(by: 3 / 4 * .pi ).scaledBy(x: 0.1, y: 0.1)
        }
        return attr
    }
    
    override func layoutAttributesForInteractivelyMovingItem(at indexPath: IndexPath, withTargetPosition position: CGPoint) -> UICollectionViewLayoutAttributes {
        let attr = super.layoutAttributesForInteractivelyMovingItem(at: indexPath, withTargetPosition: position)
        attr.alpha = 0.2
        return attr
    }
}

class FlowLayoutReloadingInvalidationContext: UICollectionViewFlowLayoutInvalidationContext {
    public var reloadingPaths: [IndexPath] = []
}

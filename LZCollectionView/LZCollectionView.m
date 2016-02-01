//
//  LZCollectionView.m
//  CustomControl
//
//  Created by liww on 14-9-30.
//  Copyright (c) 2014年 liww. All rights reserved.
//

#import "LZCollectionView.h"
#import "LZCollectionViewCell.h"
#import "LZCollectionViewLayoutAttributes.h"
#import "LZCollectionViewFlowLayout.h"
#import "LZCollectionViewGridLayout.h"

#define KeyCollectionViewSection  @"Section"
#define KeyCollectionViewItem     @"Item"


#pragma mark LZCollectionViewLayout
@interface LZCollectionViewLayout ()
@property(nonatomic, readwrite) LZCollectionView *collectionView;
@property(nonatomic, assign) id< LZCollectionViewFlowLayoutDelegate> delegate;
@end

#pragma mark LZCollectionReusableView
@interface LZCollectionReusableView ()
@property (nonatomic, readwrite, copy) NSString *reuseIdentifier;
@end

#pragma mark LZCollectionView
@interface LZCollectionView (){
    
    NSMutableDictionary *_classIdentifiers;
    NSMutableDictionary *_keyedVisibleItems;
    NSMutableDictionary *_keyedVisibleItemAttributes;
    NSMutableDictionary *_reuseableItems;
    
    NSInteger           _numberOfSections;
    BOOL                _isInitialCall;
}

@end

@implementation LZCollectionView

- (id)init
{
    self = [super init];
    if (self) {
        [self setupDefaults];
        _delegate = nil;
        _dataSource = nil;
    }
    return self;
}

- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupDefaults];
    }
    
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setupDefaults];
    }
    return self;
}
- (instancetype)initWithFrame:(CGRect)frame
         collectionViewLayout:(LZCollectionViewLayout *)layout
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupDefaults];
        [self setCollectionViewLayout:layout];
    }
    return self;
}

- (void)setupDefaults
{
    _keyedVisibleItems                  = [[NSMutableDictionary alloc] init];
    _keyedVisibleItemAttributes         = [[NSMutableDictionary alloc] init];
    _reuseableItems                     = [[NSMutableDictionary alloc] init];
    _selectedItems                      = [[NSMutableDictionary alloc] init];
    _selectedItemsBySelectionFrame      = [[NSMutableDictionary alloc] init];
    _classIdentifiers                   = [[NSMutableDictionary alloc] init];
    
    _allowsSelection                    = YES;
    _allowsMultipleSelection            = NO;
    _allowsMultipleSelectionWithDrag    = NO;
    _allowsHighlight                    = YES;
    
    _delegate                           = nil;
    _dataSource                         = nil;
    
    _numberOfSections                   = 0;
    _isInitialCall                      = YES;
    _abortSelection                     = NO;
    _mouseHasDragged                    = NO;
    
    _collectionViewLayout               = [[LZCollectionViewFlowLayout alloc] init];
    _collectionViewLayout.collectionView = self;
    
    [[self enclosingScrollView] setDrawsBackground:YES];
	NSClipView *clipView = [[self enclosingScrollView] contentView];
	[clipView setPostsBoundsChangedNotifications:YES];
    [[NSNotificationCenter defaultCenter] addObserver:self
	                                         selector:@selector(_scrollViewDidScroll)
	                                             name:NSViewBoundsDidChangeNotification
	                                           object:clipView];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(_viewDidResize)
                                                 name:NSViewFrameDidChangeNotification
                                               object:self];
}

- (void)awakeFromNib
{
    
}

- (void)drawRect:(NSRect)dirtyRect
{
    [super drawRect:dirtyRect];
    
    // Background color
    [(self.backgroundColor ? self.backgroundColor:[NSColor controlColor]) set];
    NSRectFill(dirtyRect);
    
    // Selected color
    
    // Highlight color
    
    
}

- (BOOL)isFlipped
{
    return YES;
}

- (void)setDelegate:(id<LZCollectionViewDelegate>)delegate
{
    _delegate = delegate;
}

#pragma mark Configuration
- (void)setCollectionViewLayout:(LZCollectionViewLayout *)collectionViewLayout
{
    _collectionViewLayout = collectionViewLayout;
    _collectionViewLayout.collectionView = self;
    if ([_collectionViewLayout isKindOfClass:[LZCollectionViewFlowLayout class]]) {
        _collectionViewLayout.delegate = (id< LZCollectionViewFlowLayoutDelegate>)self.delegate;
    }
}

- (void)registerClass:(Class)cellClass forCellWithReuseIdentifier:(NSString *)identifier
{
    _classIdentifiers[identifier] = cellClass;
}

- (void)registerNib:(NSNib *)nib forCellWithReuseIdentifier:(NSString *)identifier
{
    
}

- (void)registerClass:(Class)viewClass
forSupplementaryViewOfKind:(NSString *)elementKind
  withReuseIdentifier:(NSString *)identifier
{
    NSString *kindAndIdentifier = [NSString stringWithFormat:@"%@-%@",elementKind,identifier];
    _classIdentifiers[kindAndIdentifier] = viewClass;
}

- (void)registerNib:(NSNib *)nib
forSupplementaryViewOfKind:(NSString *)kind
withReuseIdentifier:(NSString *)identifier
{

}

#pragma mark Public Method
- (id)dequeueReusableCellWithReuseIdentifier:(NSString *)identifier
                                forIndexPath:(NSIndexPath *)indexPath
{
    LZCollectionViewCell *reusableCell = nil;
    NSMutableSet *reuseQueue = _reuseableItems[identifier];
    if (reuseQueue != nil && [reuseQueue count] > 0) {
        reusableCell = [reuseQueue anyObject];
        [reuseQueue removeObject:reusableCell];
        _reuseableItems[identifier] = reuseQueue;
    }
    else{
        reusableCell = [[_classIdentifiers[identifier] alloc] init];
        reusableCell.reuseIdentifier = identifier;
    }
    return reusableCell;
}

- (id)dequeueReusableSupplementaryViewOfKind:(NSString *)elementKind
                         withReuseIdentifier:(NSString *)identifier
                                forIndexPath:(NSIndexPath *)indexPath
{
    NSString *kindAndIdentifier = [NSString stringWithFormat:@"%@-%@",elementKind,identifier];
    LZCollectionReusableView *reusableView = nil;
    NSMutableSet *reuseQueue = _reuseableItems[kindAndIdentifier];
    if (reuseQueue != nil && [reuseQueue count] > 0) {
        reusableView = [reuseQueue anyObject];
        [reuseQueue removeObject:reusableView];
        _reuseableItems[identifier] = reuseQueue;
    }
    else{
        reusableView = [[_classIdentifiers[kindAndIdentifier] alloc] init];
        reusableView.reuseIdentifier = kindAndIdentifier;
    }
    return reusableView;
}


- (NSInteger)numberOfSections
{
    return [self numberOfSectionsInCollectionView:self];
}

- (NSInteger)numberOfItemsInSection:(NSInteger)section
{
    return [self collectionView:self numberOfItemsInSection:section];
}

- (NSArray *)visibleCells
{
    return [_keyedVisibleItems allValues];
}

- (NSArray *)indexPathsForVisibleItems
{
    return [_keyedVisibleItems allKeys];
}

- (NSArray *)indexPathsForSelectedItems
{
    return [_selectedItems allValues];
}

- (NSIndexPath *)indexPathForCell:(LZCollectionViewCell *)cell
{
    __block NSIndexPath *indexPath = nil;
    [_keyedVisibleItems enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        if ([cell isEqual:(LZCollectionViewCell *)obj]) {
            indexPath = (NSIndexPath *)key;
            *stop = YES;
        } ;
    }];
    return indexPath;
}

- (LZCollectionViewCell *)cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    LZCollectionViewCell *cell = [_keyedVisibleItems objectForKey:indexPath];
    if ([cell isKindOfClass:[LZCollectionViewCell class]]) {
        return cell;
    }
    return nil;
}


- (NSIndexPath *)indexPathForItemAtPoint:(NSPoint)location
{
    NSPoint point = [self convertPoint:location fromView:nil];
    __block NSIndexPath *indexPath = nil;
    [_keyedVisibleItems enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        NSRect cellFrame = [[self.collectionViewLayout layoutAttributesForItemAtIndexPath:(NSIndexPath *)key] frame];
        if (NSPointInRect(point, cellFrame)) {
            indexPath = (NSIndexPath *)key;
            *stop = YES;
        } ;
    }];
    return indexPath;
}

- (LZCollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return [self.collectionViewLayout layoutAttributesForItemAtIndexPath:indexPath];
}

- (LZCollectionViewLayoutAttributes *)layoutAttributesForSupplementaryElementOfKind:(NSString *)kind
                                      atIndexPath:(NSIndexPath *)indexPath
{
    return [self.collectionViewLayout layoutAttributesForSupplementaryViewOfKind:kind
                                                                     atIndexPath:indexPath];
}

#pragma mark Reload Data

- (void)reloadData
{
    NSLog(@">>> %@",NSStringFromSelector(_cmd));

    _isInitialCall = YES;
    [self _reloadData];
    _isInitialCall = NO;
}

- (void)reloadSections:(NSIndexSet *)sections
{
    NSLog(@">>> %@",NSStringFromSelector(_cmd));

    NSUInteger index = [sections firstIndex];
    while (YES) {
        if (index >= [sections count]) {
            break;
        }
        [self _reloadSection:index];
        index = [sections indexGreaterThanIndex:index];
    }
}

- (void)reloadItemsAtIndexPaths:(NSArray *)indexPaths
{
    NSLog(@">>> %@",NSStringFromSelector(_cmd));
    
    [indexPaths enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        [self _reloadItemsAtIndexPath:(NSIndexPath *)obj];
    }];
}

#pragma mark - Selection Handling


#pragma mark Private Method

- (NSMutableArray *)_updateIndexPathsForVisibleItems
{
    NSMutableArray *result = [[NSMutableArray alloc] init];
    NSArray *attributes = [self.collectionViewLayout layoutAttributesForElementsInRect:[self visibleRect]];
    
    [attributes enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        LZCollectionViewLayoutAttributes *attribute = (LZCollectionViewLayoutAttributes *)obj;
        _keyedVisibleItemAttributes[attribute.indexPath] = attribute;
        [result addObject:attribute.indexPath];
    }];
    
    return result;
}

- (BOOL)_isVisibleForIndexPath:(NSIndexPath *)indexPath
{
    BOOL isVisible = NO;
    LZCollectionViewLayoutAttributes *attributes = [self layoutAttributesForItemAtIndexPath:indexPath];
    NSRect cellFrame = attributes.frame;
    NSRect clippedRect = [self visibleRect];
    if (NSIntersectsRect(cellFrame,clippedRect)) {
        isVisible = YES;
    }
    return isVisible;
}

- (void)_reloadData
{
    _numberOfSections = [self numberOfSections];
    
    //1
    [[NSAnimationContext currentContext] setDuration:0.5f];
    [NSAnimationContext runAnimationGroup: ^(NSAnimationContext *context) {
        [_keyedVisibleItems enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
            LZCollectionViewCell *cell = (LZCollectionViewCell *)obj;
            [[cell animator] setAlphaValue:0.0];
            [[cell animator] removeFromSuperview];
        }];
    }completionHandler:nil];
    
    //2
//    [_keyedVisibleItems enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
//        LZCollectionViewCell *cell = (LZCollectionViewCell *)obj;
//        [cell removeFromSuperview];
//    }];
    
    
    
    [_keyedVisibleItems removeAllObjects];
    [_reuseableItems removeAllObjects];
    [self refreshCollectionView];
    
    NSLog(@">>> %@ end",NSStringFromSelector(_cmd));
}

- (void)_reloadSection:(NSInteger)section
{
    NSInteger numberOfItemsInSection = [self numberOfItemsInSection:section];
    for (NSInteger index = 0; index < numberOfItemsInSection; index++) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:index inSection:section];
        [self _reloadItemsAtIndexPath:indexPath];
    }
}

- (void)_reloadItemsAtIndexPath:(NSIndexPath *)indexPath
{
    dispatch_async(dispatch_get_main_queue(), ^{
        if ([self _isVisibleForIndexPath:indexPath]) {
            [self updateReuseableItemAtIndexPath:indexPath];
            [self updateVisibleItemAtIndexPath:indexPath];
        }
    });
}

- (NSRect)_clippedRect
{
    return [[[self enclosingScrollView] contentView] bounds];
}

#pragma mark Private Helper
- (void)_scrollViewDidScroll
{
    NSLog(@">>> %@",NSStringFromSelector(_cmd));

    [self updateVisibleRect];
    
    NSLog(@">>> %@ end",NSStringFromSelector(_cmd));
}

- (void)_viewDidResize
{
    NSLog(@">>> %@",NSStringFromSelector(_cmd));
    
    if (_isInitialCall) {
        return;
    }
    
    _isInitialCall = YES;
    
    [_collectionViewLayout prepareLayout];
    NSSize size = self.collectionViewLayout.collectionViewContentSize;
    [self setFrameSize:size];
    
    __weak typeof(self) wSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        
        NSMutableArray *visibleItemIndexPaths = [wSelf _updateIndexPathsForVisibleItems];
        NSArray *lastVisibleItemIndexPaths = [wSelf indexPathsForVisibleItems];
        
        [lastVisibleItemIndexPaths enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            [wSelf updateReuseableItemAtIndexPath:(NSIndexPath *)obj];
        }];
        
        [visibleItemIndexPaths enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            [wSelf updateVisibleItemAtIndexPath:(NSIndexPath *)obj];
        }];
        
        [_keyedVisibleItemAttributes removeAllObjects];
    });
    
    _isInitialCall = NO;
    
    NSLog(@">>> %@ end",NSStringFromSelector(_cmd));
}

- (void)refreshCollectionView
{
    NSLog(@">>> %@",NSStringFromSelector(_cmd));
    [_collectionViewLayout prepareLayout];
    NSSize size = self.collectionViewLayout.collectionViewContentSize;
    [self setFrameSize:size];

    [self updateVisibleRect];
    
    NSLog(@">>> %@ end",NSStringFromSelector(_cmd));
}

- (void)updateVisibleRect
{
    NSLog(@">>> %@",NSStringFromSelector(_cmd));
//    __weak typeof(self) wSelf = self;
//    dispatch_async(dispatch_get_main_queue(), ^{
    
        //  当前可见范围
        NSMutableArray *visibleItemindexPaths = [self _updateIndexPathsForVisibleItems];
        NSArray *lastVisibleItemIndexPaths = [self indexPathsForVisibleItems];
        
        //  从keyedVisibleItems 中移除不可见的item,并添加到reuseableItems
        [lastVisibleItemIndexPaths enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            NSIndexPath *indexPath = (NSIndexPath *)obj;
            if (![visibleItemindexPaths containsObject:indexPath]) {
                [self updateReuseableItemAtIndexPath:indexPath];
            }
        }];
        
        //  移除已加载的，只加载未加载的
        [visibleItemindexPaths removeObjectsInArray:lastVisibleItemIndexPaths];
        
        //  从reuseableItems 中取出一个可用的item,并添加到keyedVisibleItems,再显示到界面
        [visibleItemindexPaths enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            [self updateVisibleItemAtIndexPath:(NSIndexPath *)obj];
        }];
        
        [_keyedVisibleItemAttributes removeAllObjects];
        
        //[self arrangeItemsAnimated:YES];
//    });
}

- (void)updateReuseableItemAtIndexPath:(NSIndexPath *)indexPath
{
    LZCollectionReusableView *cell = _keyedVisibleItems[indexPath];
    
    if (cell == nil) {
        return;
    }
    
    //1
    [NSAnimationContext beginGrouping];
    [[NSAnimationContext currentContext] setDuration:0.5f];
    [[cell animator] setAlphaValue:0.0];
    [[cell animator] removeFromSuperview];
    [NSAnimationContext endGrouping];

    //2
//    [cell removeFromSuperview];
    
    
    [cell prepareForReuse];
    
    [_keyedVisibleItems removeObjectForKey:indexPath];
    
    NSMutableSet *reuseQueue = _reuseableItems[cell.reuseIdentifier];
    if (reuseQueue == nil) {
        reuseQueue = [NSMutableSet set];
    }
    [reuseQueue addObject:cell];
    _reuseableItems[cell.reuseIdentifier] = reuseQueue;
}


- (void)updateVisibleItemAtIndexPath:(NSIndexPath *)indexPath
{
    LZCollectionViewLayoutAttributes *attributes = _keyedVisibleItemAttributes[indexPath];
    switch (attributes.representedElementCategory) {
        case LZCollectionElementCategoryCell:
            [self _displayCellAtIndexPath:indexPath];
            break;
            
        case LZCollectionElementCategorySupplementaryView:
            [self _displaySupplementaryViewForElementKind:attributes.representedElementKind atIndexPath:indexPath];
            break;
            
        case LZCollectionElementCategoryDecorationView:
            [self _displayDecorationViewAtIndexPath:indexPath];
            break;
            
        default:
            break;
    }
}

- (void)arrangeItemsAnimated:(BOOL)animated
{
    if (!animated) {
        return;
    }
    
    if ([[_keyedVisibleItems allKeys] count] > 0) {
        
        [[NSAnimationContext currentContext] setDuration:0.5f];
        [NSAnimationContext runAnimationGroup: ^(NSAnimationContext *context) {
            [_keyedVisibleItems enumerateKeysAndObjectsUsingBlock: ^(id key, LZCollectionViewCell *item, BOOL *stop) {
                [[item animator] setAlphaValue:1.0];
            }];
        }completionHandler:nil];
    }
}

- (void)arrangeItemAnimated:(LZCollectionViewCell *)item Animated:(BOOL)animated
{
    if (!animated || item == nil) {
        return;
    }
    
    [NSAnimationContext beginGrouping];
    [[NSAnimationContext currentContext] setDuration:0.5f];
    [[item animator] setAlphaValue:1.0];
    [NSAnimationContext endGrouping];
}

- (void)_displayCellAtIndexPath:(NSIndexPath *)indexPath
{
    LZCollectionViewCell *cell = [self collectionView:self cellForItemAtIndexPath:indexPath];
    if (cell && indexPath) {
        [cell setAlphaValue:0.0];
        
        
        NSRect rect = [[self.collectionViewLayout layoutAttributesForItemAtIndexPath:indexPath] frame];
        rect.origin.x -= rect.size.width;
        [cell setFrame:rect];
        
//        [cell setFrame:[[self.collectionViewLayout layoutAttributesForItemAtIndexPath:indexPath] frame]];
//        [cell setAutoresizingMask:NSViewMaxXMargin | NSViewMaxYMargin];
        
        
        [self collectionView:self willDisplayCell:cell forItemAtIndexPath:indexPath];
        [_keyedVisibleItems setObject:cell forKey:indexPath];
        [self addSubview:cell];
        
        [NSAnimationContext beginGrouping];
        [[NSAnimationContext currentContext] setDuration:0.5f];
        [[cell animator] setAlphaValue:1.0];
        [[cell animator] setFrame:[[self.collectionViewLayout layoutAttributesForItemAtIndexPath:indexPath] frame]];
        [[cell animator] setAutoresizingMask:NSViewMaxXMargin | NSViewMaxYMargin];
        [NSAnimationContext endGrouping];
        
        //[self arrangeItemAnimated:cell Animated:YES];
    }
}

- (void)_displaySupplementaryViewForElementKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    LZCollectionReusableView *supplementaryView = [self collectionView:self viewForSupplementaryElementOfKind:kind atIndexPath:indexPath];
    if (supplementaryView && indexPath) {
        //rect
        NSRect afterRect = [[self.collectionViewLayout layoutAttributesForSupplementaryViewOfKind:kind atIndexPath:indexPath] frame];
        NSRect beforeRect = afterRect;
        beforeRect.origin.x -= beforeRect.size.width;
        
        //before
        [supplementaryView setFrame:beforeRect];
        [supplementaryView setAlphaValue:0.0];
        
        //after
        [NSAnimationContext beginGrouping];
        [[NSAnimationContext currentContext] setDuration:0.5f];
        
        [[supplementaryView animator] setFrame:afterRect];
        [[supplementaryView animator] setAlphaValue:1.0];
        
        [supplementaryView setAutoresizingMask:NSViewMaxXMargin | NSViewMaxYMargin];
        [NSAnimationContext endGrouping];
        
        //
        [self collectionView:self willDisplaySupplementaryView:supplementaryView forElementKind:kind atIndexPath:indexPath];
        [_keyedVisibleItems setObject:supplementaryView forKey:indexPath];
        [self addSubview:supplementaryView];
    }
}

- (void)_displayDecorationViewAtIndexPath:(NSIndexPath *)indexPath
{
    //
}

#pragma mark DataSource and delegate
- (NSInteger)collectionView:(LZCollectionView *)collectionView numberOfItemsInSection:(NSInteger)section;
{
    if (_dataSource && [_dataSource respondsToSelector:_cmd]) {
        return [_dataSource collectionView:collectionView numberOfItemsInSection:section];
    }
    return 0;
}

- (LZCollectionViewCell *)collectionView:(LZCollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath;
{
    if (_dataSource && [_dataSource respondsToSelector:_cmd]) {
        return [_dataSource collectionView:collectionView cellForItemAtIndexPath:indexPath];
    }
    return nil;
}

- (NSInteger)numberOfSectionsInCollectionView:(LZCollectionView *)collectionView;
{
    if (_dataSource && [_dataSource respondsToSelector:_cmd]) {
        return [_dataSource numberOfSectionsInCollectionView:collectionView];
    }
    return 0;
}

- (LZCollectionReusableView *)collectionView:(LZCollectionView *)collectionView
           viewForSupplementaryElementOfKind:(NSString *)kind
                                 atIndexPath:(NSIndexPath *)indexPath
{
    if (_dataSource && [_dataSource respondsToSelector:_cmd]) {
        return [_dataSource collectionView:collectionView viewForSupplementaryElementOfKind:kind atIndexPath:indexPath];
    }
    return nil;
}

- (void)collectionView:(LZCollectionView *)collectionView
       willDisplayCell:(LZCollectionViewCell *)cell
    forItemAtIndexPath:(NSIndexPath *)indexPath;
{
    if (_delegate && [_delegate respondsToSelector:_cmd]) {
        return [_delegate collectionView:collectionView willDisplayCell:cell forItemAtIndexPath:indexPath];
    }
}

- (void)collectionView:(LZCollectionView *)collectionView
willDisplaySupplementaryView:(LZCollectionReusableView *)view
        forElementKind:(NSString *)elementKind
           atIndexPath:(NSIndexPath *)indexPath
{
    if (_delegate && [_delegate respondsToSelector:_cmd]) {
        return [_delegate collectionView:collectionView willDisplaySupplementaryView:view forElementKind:elementKind atIndexPath:indexPath];
    }
}


@end

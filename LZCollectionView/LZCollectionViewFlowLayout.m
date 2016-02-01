//
//  LZCollectioViewFlowLayout.m
//  CustomControl
//
//  Created by liww on 14-9-30.
//  Copyright (c) 2014年 liww. All rights reserved.
//

#import "LZCollectionViewFlowLayout.h"
#import "LZCollectionViewLayoutAttributes.h"
#import "LZCollectionView.h"

#define ITEM_MAX_WIDTH          150.0
#define ITEM_MAX_HEIGHT         150.0
#define INSET_SECTION           5.0
#define MINI_LINE_SPACING       5.0
#define MINI_INTERITEM_SPACING  5.0

#define KeyCollectionViewSection            @"Section"
#define KeyCollectionViewItem               @"Item"
#define KeyCollectionViewItemFrame          @"ItemFrame"
#define KeyCollectionViewElementCategory    @"ElementCategory"
#define KeyCollectionElementKind            @"ElementKind"


NSString *const  LZCollectionElementKindSectionHeader = @"LZCollectionElementKindSectionHeader";
NSString *const  LZCollectionElementKindSectionFooter = @"LZCollectionElementKindSectionFooter";


@interface LZCollectionViewLayoutAttributes ()
@property(nonatomic, readwrite) LZCollectionElementCategory representedElementCategory;
@property(nonatomic, readwrite) NSString *representedElementKind;
@end

@interface LZCollectionViewFlowLayout(){
    NSInteger               _sections;
    NSSize                  _contentSize;
    NSMutableDictionary     *_itemAttributes;
    NSMutableArray          *_indexPaths;
    id<LZCollectionViewFlowLayoutDelegate> _delegate;
}
- (void)_prepareForLayout;
@end

@implementation LZCollectionViewFlowLayout

- (id)init
{
    self = [super init];
    if (self) {
        _minimumLineSpacing         = MINI_LINE_SPACING;
        _minimumInteritemSpacing    = MINI_INTERITEM_SPACING;
        _itemSize                   = NSMakeSize(ITEM_MAX_WIDTH, ITEM_MAX_HEIGHT);
        _sectionInset               = LZEdgeInsetsMake(INSET_SECTION,INSET_SECTION,INSET_SECTION,INSET_SECTION);

        _itemAttributes             = [[NSMutableDictionary alloc] init];
        _indexPaths                 = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)setDelegate:(id<LZCollectionViewFlowLayoutDelegate>)delegate
{
    _delegate = delegate;
}

#pragma mark - public

+ (Class)layoutAttributesClass
{
    return [self class];
}

- (void)prepareLayout
{
    [super prepareLayout];
    
    NSLog(@">>> Start prepareLayout %@",[NSDate date]);
   
    [self _prepareForLayout];

    NSLog(@">>> End prepareLayout %@",[NSDate date]);
}


- (NSSize)collectionViewContentSize
{
    return _contentSize;
}

- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect
{
    /* 循环遍历
    NSMutableArray *layoutAttributes = [NSMutableArray array];
    [_itemAttributes enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        NSDictionary *itemDic = _itemAttributes[(NSString *)key];
        NSRect itemFrame = NSRectFromString(itemDic[KeyCollectionViewItemFrame]);
        
        if (NSIntersectsRect(rect,itemFrame)) {
            NSInteger section = [itemDic[KeyCollectionViewSection] integerValue];
            NSInteger item = [itemDic[KeyCollectionViewItem] integerValue];
            NSIndexPath *indexPath = [NSIndexPath indexPathForItem:item inSection:section];
            LZCollectionViewLayoutAttributes *attributes = [LZCollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
            attributes.center = NSMakePoint(itemFrame.origin.x + itemFrame.size.width / 2,
                                            itemFrame.origin.y + itemFrame.size.height / 2);
            attributes.size = NSMakeSize(itemFrame.size.width, itemFrame.size.height);
            attributes.frame = itemFrame;
            
            [layoutAttributes addObject:attributes];
        }
    }];
    
    return layoutAttributes;
    */
    
    // 二分查找
    NSMutableArray *layoutAttributes = [[NSMutableArray alloc] init];
    
    NSInteger midIndex = 0;
    NSInteger startIndex = 0;
    NSInteger endIndex = [_indexPaths count] - 1;
     
    do {
        midIndex = (startIndex + endIndex) / 2;
        NSDictionary *itemDic = _itemAttributes[_indexPaths[midIndex]];
        NSIndexPath *midIndexPath = [NSIndexPath indexPathForItem:[itemDic[KeyCollectionViewItem] integerValue]
                                                        inSection:[itemDic[KeyCollectionViewSection] integerValue]];
        
        LZCollectionViewLayoutAttributes *midAttributes = [self _layoutAttributesForItemAtIndexPath:midIndexPath];
        NSRect midCellFrame = midAttributes.frame;
        if (NSMaxY(midCellFrame) < NSMinY(rect)) {
            startIndex = midIndex + 1;
        }
        else if (NSMinY(midCellFrame) > NSMaxY(rect)) {
            endIndex = midIndex - 1;
        }
        else{
            if (NSIntersectsRect(rect, midCellFrame)) {
                [layoutAttributes addObject:midAttributes];
            }
            break;
        }
    }while (startIndex <= endIndex);
     
    for (NSInteger index = midIndex - 1; index >= startIndex; index--) {
        NSDictionary *itemDic = _itemAttributes[_indexPaths[index]];
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:[itemDic[KeyCollectionViewItem] integerValue]
                                                     inSection:[itemDic[KeyCollectionViewSection] integerValue]];
 
        NSRect itemFrame = NSRectFromString(itemDic[KeyCollectionViewItemFrame]);
        if (NSIntersectsRect(itemFrame,rect)) {
            LZCollectionViewLayoutAttributes *attributes = [self _layoutAttributesForItemAtIndexPath:indexPath];
            [layoutAttributes addObject:attributes];
        }
        else{
            continue;
        }
    }
 
    for (NSInteger index = midIndex + 1; index <= endIndex; index++) {
        NSDictionary *itemDic = _itemAttributes[_indexPaths[index]];
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:[itemDic[KeyCollectionViewItem] integerValue]
                                                     inSection:[itemDic[KeyCollectionViewSection] integerValue]];
 
        NSRect itemFrame = NSRectFromString(itemDic[KeyCollectionViewItemFrame]);
        if (NSIntersectsRect(itemFrame,rect)) {
            LZCollectionViewLayoutAttributes *attributes = [self _layoutAttributesForItemAtIndexPath:indexPath];
            [layoutAttributes addObject:attributes];
        }
        else{
            continue;
        }
    }
    
    return layoutAttributes;
}

- (LZCollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *itemKey = [NSString stringWithFormat:@"%ld-%ld",indexPath.section,indexPath.item];
    NSDictionary *itemDic = _itemAttributes[itemKey];
    NSRect itemFrame = NSRectFromString(itemDic[KeyCollectionViewItemFrame]);
    
    LZCollectionViewLayoutAttributes *attributes = [LZCollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    attributes.center = NSMakePoint(itemFrame.origin.x + itemFrame.size.width / 2,
                                    itemFrame.origin.y + itemFrame.size.height / 2);
    attributes.size = NSMakeSize(itemFrame.size.width, itemFrame.size.height);
    attributes.frame = itemFrame;
    attributes.bounds = NSMakeRect(0.0, 0.0, itemFrame.size.width, itemFrame.size.height);
    attributes.representedElementCategory = LZCollectionElementCategoryCell;

    return attributes;
}

- (LZCollectionViewLayoutAttributes *)layoutAttributesForSupplementaryViewOfKind:(NSString *)kind
                                                                     atIndexPath:(NSIndexPath *)indexPath
{
    NSString *itemKey = [NSString stringWithFormat:@"%ld-%ld",indexPath.section,indexPath.item];
    NSDictionary *itemDic = _itemAttributes[itemKey];
    NSRect itemFrame = NSRectFromString(itemDic[KeyCollectionViewItemFrame]);
    
    LZCollectionViewLayoutAttributes *attributes = [LZCollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    attributes.center = NSMakePoint(itemFrame.origin.x + itemFrame.size.width / 2,
                                    itemFrame.origin.y + itemFrame.size.height / 2);
    attributes.size = NSMakeSize(itemFrame.size.width, itemFrame.size.height);
    attributes.frame = itemFrame;

    attributes.representedElementCategory = LZCollectionElementCategorySupplementaryView;
    attributes.representedElementKind = kind;
    return attributes;
}

- (LZCollectionViewLayoutAttributes *)layoutAttributesForDecorationViewOfKind:(NSString *)decorationViewKind
                                                                  atIndexPath:(NSIndexPath *)indexPath
{
    return nil;
}

- (NSArray *)indexPathsToInsertForSupplementaryViewOfKind:(NSString *)kind
{
    return nil;
}

- (NSArray *)indexPathsToInsertForDecorationViewOfKind:(NSString *)kind
{
    return nil;
}

#pragma mark - private

- (void)_prepareForLayout
{
    [_indexPaths removeAllObjects];
    [_itemAttributes removeAllObjects];
    
    CGFloat yPosition = 0.0;
    NSRect visibleRect = [[self collectionView] visibleRect];
    _sections = [self.collectionView numberOfSections];
    
    for (NSInteger section = 0; section < _sections; section++) {
        LZEdgeInsets sectionInset = [self collectionView:self.collectionView layout:self insetForSectionAtIndex:section];
        NSInteger minimumLineSpacing = [self collectionView:self.collectionView layout:self minimumLineSpacingForSectionAtIndex:section];
        NSInteger minimumInteritemSpacing = [self collectionView:self.collectionView layout:self minimumInteritemSpacingForSectionAtIndex:section];
        
        NSInteger headerIndex = -1;
        NSSize referenceSizeForHeader = [self collectionView:self.collectionView layout:self referenceSizeForHeaderInSection:section];
        if (!NSEqualSizes(referenceSizeForHeader, NSZeroSize) ) {
            
            NSRect itemFrame = NSMakeRect((visibleRect.size.width - referenceSizeForHeader.width)/2,
                                          yPosition,
                                          referenceSizeForHeader.width,
                                          referenceSizeForHeader.height);
            
            NSDictionary *itemAttribute = @{KeyCollectionViewSection:@(section),
                                            KeyCollectionViewItem:@(headerIndex),
                                            KeyCollectionViewItemFrame:NSStringFromRect(itemFrame),
                                            KeyCollectionViewElementCategory:@(LZCollectionElementCategorySupplementaryView),
                                            KeyCollectionElementKind:LZCollectionElementKindSectionHeader};

            NSString *itemKey = [NSString stringWithFormat:@"%ld-%ld",section,headerIndex];
            _itemAttributes[itemKey] = itemAttribute;
            [_indexPaths addObject:itemKey];
            
            yPosition += referenceSizeForHeader.height;
        }
        
        yPosition += sectionInset.top;
        
        NSInteger xPosition = sectionInset.left;
        NSInteger numberOfItemsInSection = [self.collectionView numberOfItemsInSection:section];
        for (NSInteger index = 0; index < numberOfItemsInSection; index++) {
            
            NSIndexPath *indexPath = [NSIndexPath indexPathForItem:index inSection:section];
            NSSize itemSize = [self collectionView:self.collectionView layout:self sizeForItemAtIndexPath:indexPath];
            
            NSInteger heightOfItem = (ITEM_MAX_HEIGHT - itemSize.height > 0) ? itemSize.height : ITEM_MAX_HEIGHT;
            NSInteger widthOfItem = itemSize.width / itemSize.height * heightOfItem;
            
            if (xPosition + widthOfItem > visibleRect.origin.x + visibleRect.size.width - sectionInset.right) {
                xPosition = sectionInset.left;
                yPosition += minimumLineSpacing + ITEM_MAX_HEIGHT;
            }
            
            //居中
            NSRect itemFrame = NSMakeRect(xPosition,
                                          yPosition + (ITEM_MAX_HEIGHT - heightOfItem) / 2,
                                          widthOfItem,
                                          heightOfItem);
            
            NSDictionary *itemAttribute = @{KeyCollectionViewSection:@(section),
                                            KeyCollectionViewItem:@(index),
                                            KeyCollectionViewItemFrame:NSStringFromRect(itemFrame),
                                            KeyCollectionViewElementCategory:@(LZCollectionElementCategoryCell),
                                            KeyCollectionElementKind:@""};
            
            NSString *itemKey = [NSString stringWithFormat:@"%ld-%ld",section,index];
            _itemAttributes[itemKey] = itemAttribute;
            [_indexPaths addObject:itemKey];
            
            xPosition += widthOfItem + minimumInteritemSpacing;
        }
        
        yPosition += ITEM_MAX_HEIGHT;
        yPosition += sectionInset.bottom;
        
        NSInteger footerIndex = numberOfItemsInSection;
        NSSize referenceSizeForFooter = [self collectionView:self.collectionView layout:self referenceSizeForFooterInSection:section];
        if (!NSEqualSizes(referenceSizeForFooter, NSZeroSize) ) {
            
            NSRect itemFrame = NSMakeRect((visibleRect.size.width - referenceSizeForFooter.width)/2,
                                          yPosition,
                                          referenceSizeForFooter.width,
                                          referenceSizeForFooter.height);
            
            NSDictionary *itemAttribute = @{KeyCollectionViewSection:@(section),
                                            KeyCollectionViewItem:@(footerIndex),
                                            KeyCollectionViewItemFrame:NSStringFromRect(itemFrame),
                                            KeyCollectionViewElementCategory:@(LZCollectionElementCategorySupplementaryView),
                                            KeyCollectionElementKind:LZCollectionElementKindSectionFooter};
            
            NSString *itemKey = [NSString stringWithFormat:@"%ld-%ld",section,footerIndex];
            _itemAttributes[itemKey] = itemAttribute;
            [_indexPaths addObject:itemKey];
            
            yPosition += referenceSizeForFooter.height;
        }
    }
    
    _contentSize = [[[self.collectionView enclosingScrollView] contentView] bounds].size;
    _contentSize.height = yPosition;
}

- (BOOL)_isVisibleForIndexPath:(NSIndexPath *)indexPath
{
    BOOL isVisible = NO;
    NSString *itemKey = [NSString stringWithFormat:@"%ld-%ld",indexPath.section,indexPath.item];
    NSDictionary *itemDic = _itemAttributes[itemKey];
    NSRect itemFrame = NSRectFromString(itemDic[KeyCollectionViewItemFrame]);

    NSRect visibleRect = [self.collectionView visibleRect];
    if (NSIntersectsRect(itemFrame,visibleRect)) {
        isVisible = YES;
    }
    return isVisible;
}

- (LZCollectionViewLayoutAttributes *)_layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *itemKey = [NSString stringWithFormat:@"%ld-%ld",indexPath.section,indexPath.item];
    NSDictionary *itemDic = _itemAttributes[itemKey];
    LZCollectionElementCategory elementCategory = [itemDic[KeyCollectionViewElementCategory] intValue];
    NSString *elementKind = itemDic[KeyCollectionElementKind];
    if (elementCategory == LZCollectionElementCategoryCell) {
        return [self layoutAttributesForItemAtIndexPath:indexPath];
    }
    else if (elementCategory == LZCollectionElementCategorySupplementaryView) {
        return [self layoutAttributesForSupplementaryViewOfKind:elementKind atIndexPath:indexPath];
    }
    else if (elementCategory == LZCollectionElementCategoryDecorationView) {
        return [self layoutAttributesForDecorationViewOfKind:elementKind atIndexPath:indexPath];
    }
    
    return [LZCollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
}

#pragma mark - delegate

- (NSSize)collectionView:(LZCollectionView *)collectionView
                  layout:(LZCollectionViewLayout *)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (_delegate && [_delegate respondsToSelector:_cmd]) {
        return [_delegate collectionView:collectionView layout:collectionViewLayout sizeForItemAtIndexPath:indexPath];
    }
    return _itemSize;
}

- (LZEdgeInsets)collectionView:(LZCollectionView *)collectionView
                        layout:(LZCollectionViewLayout *)collectionViewLayout
        insetForSectionAtIndex:(NSInteger)section
{
    if (_delegate && [_delegate respondsToSelector:_cmd]) {
        return [_delegate collectionView:collectionView layout:collectionViewLayout insetForSectionAtIndex:section];
    }
    return _sectionInset;
}

- (CGFloat)collectionView:(LZCollectionView *)collectionView
                   layout:(LZCollectionViewLayout *)collectionViewLayout
minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    if (_delegate && [_delegate respondsToSelector:_cmd]) {
        return [_delegate collectionView:collectionView layout:collectionViewLayout minimumLineSpacingForSectionAtIndex:section];
    }
    return _minimumLineSpacing;
}

- (CGFloat)collectionView:(LZCollectionView *)collectionView
                   layout:(LZCollectionViewLayout *)collectionViewLayout
minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    if (_delegate && [_delegate respondsToSelector:_cmd]) {
        return [_delegate collectionView:collectionView layout:collectionViewLayout minimumInteritemSpacingForSectionAtIndex:section];
    }
    return _minimumInteritemSpacing;
}

- (NSSize)collectionView:(LZCollectionView *)collectionView
                  layout:(LZCollectionViewLayout *)collectionViewLayout
referenceSizeForHeaderInSection:(NSInteger)section
{
    if (_delegate && [_delegate respondsToSelector:_cmd]) {
        return [_delegate collectionView:collectionView layout:collectionViewLayout referenceSizeForHeaderInSection:section];
    }
    return _headerReferenceSize;
}

- (NSSize)collectionView:(LZCollectionView *)collectionView
                  layout:(LZCollectionViewLayout *)collectionViewLayout
referenceSizeForFooterInSection:(NSInteger)section
{
    if (_delegate && [_delegate respondsToSelector:_cmd]) {
        return [_delegate collectionView:collectionView layout:collectionViewLayout referenceSizeForFooterInSection:section];
    }
    return _footerReferenceSize;
}
@end

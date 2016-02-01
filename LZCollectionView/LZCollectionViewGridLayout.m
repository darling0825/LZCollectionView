//
//  LZCollectioViewFlowLayout.m
//  CustomControl
//
//  Created by liww on 14-9-30.
//  Copyright (c) 2014年 liww. All rights reserved.
//

#import "LZCollectionViewGridLayout.h"
#import "LZCollectionViewLayoutAttributes.h"
#import "LZCollectionView.h"
#import "LZIndexPath.h"

#define ITEM_SIZE_WIDTH         80.0
#define ITEM_SIZE_HEIGHT        80.0
#define INSET_SECTION           5.0
#define MINI_LINE_SPACING       5.0
#define MINI_INTERITEM_SPACING  5.0


@interface LZCollectionViewGridLayout(){
    NSInteger   _sections;
    NSSize      _contentSize;
    id<LZCollectionViewFlowLayoutDelegate> _delegate;
}
- (CGFloat)_heightForSections:(NSInteger)sections;
@end

@implementation LZCollectionViewGridLayout

- (id)init
{
    self = [super init];
    if (self) {
        _minimumLineSpacing         = MINI_LINE_SPACING;
        _minimumInteritemSpacing    = MINI_INTERITEM_SPACING;
        _itemSize                   = NSMakeSize(ITEM_SIZE_WIDTH, ITEM_SIZE_HEIGHT);
        _sectionInset               = LZEdgeInsetsMake(INSET_SECTION,INSET_SECTION,INSET_SECTION,INSET_SECTION);
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
    _sections = [self.collectionView numberOfSections];
    
    _contentSize = self.collectionView.frame.size;
    _contentSize.height = [self _heightForSections:_sections];
}

- (NSSize)collectionViewContentSize
{
    return _contentSize;
}

- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect
{
    NSMutableArray *layoutAttributes = [NSMutableArray array];
    NSArray *indexPaths = [self indexPathsOfItemsInRect:rect];
    
    [indexPaths enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        LZIndexPath *indexPath = (LZIndexPath *)obj;
        LZCollectionViewLayoutAttributes *attributes = [self layoutAttributesForItemAtIndexPath:indexPath];
        [layoutAttributes addObject:attributes];
    }];
    
    return layoutAttributes;
}

- (LZCollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(LZIndexPath *)indexPath
{
    NSInteger section = indexPath.section;
    NSInteger index = indexPath.item;
    
    CGFloat height = [self _heightForSections:section];
    
    NSUInteger columns = [self columnsForSection:section];
    CGFloat x = _sectionInset.left + _minimumInteritemSpacing /2;
    x += (index % columns) * (_itemSize.width + _minimumInteritemSpacing);
    CGFloat y = _sectionInset.top;
    y += (index / columns) * (_minimumLineSpacing + _itemSize.height) + height;
    
    LZCollectionViewLayoutAttributes *attributes = [LZCollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    
    attributes.frame = NSMakeRect(x,
                                  y,
                                  _itemSize.width,
                                  _itemSize.height);
    
    attributes.center = NSMakePoint(x + _itemSize.width / 2,
                                    y + _itemSize.height / 2);
    return attributes;
}

- (LZCollectionViewLayoutAttributes *)layoutAttributesForSupplementaryViewOfKind:(NSString *)kind
                                                                     atIndexPath:(LZIndexPath *)indexPath
{
    return nil;
}

- (LZCollectionViewLayoutAttributes *)layoutAttributesForDecorationViewOfKind:(NSString *)decorationViewKind
                                                                  atIndexPath:(LZIndexPath *)indexPath
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
- (CGFloat)_heightForSections:(NSInteger)sections
{
    CGFloat height = 0;
    for (NSInteger i = 0; i < sections; i++) {
        NSUInteger rows = [self rowsForSection:i];
        height += rows * (_minimumLineSpacing + _itemSize.height) + _sectionInset.top + _sectionInset.bottom;
    }
    return height;
}

- (NSUInteger)columnsForSection:(NSUInteger)section
{
    NSRect visibleRect = self.collectionView.frame;
    
    NSUInteger columns = floorf((NSWidth(visibleRect) - _sectionInset.left - _sectionInset.right) / (_minimumInteritemSpacing + _itemSize.width));
    columns = (columns < 1 ? 1 : columns);
    return columns;
}

- (NSUInteger)rowsForSection:(NSUInteger)section
{
    NSUInteger columns = [self columnsForSection:section];
    NSInteger numbersOfSection = [self.collectionView numberOfItemsInSection:section];
    NSUInteger rows = ceilf(numbersOfSection * 1.0 / columns);
    return rows;
}

- (NSArray *)indexPathsOfItemsInRect:(NSRect)rect
{
    NSMutableArray *indexPaths = [[NSMutableArray alloc] init];
    
    for (NSInteger section = 0; section < _sections; section++) {
        for (NSInteger item = 0; item < [self.collectionView numberOfItemsInSection:section]; item++) {
            LZIndexPath *indexPath = [LZIndexPath indexPathForItem:item inSection:section];
            
            NSRect frame = [[self layoutAttributesForItemAtIndexPath:indexPath] frame];
            if (NSIntersectsRect(rect,frame)) {
                [indexPaths addObject:indexPath];
            }
        }
    }
    return indexPaths;
}


#pragma mark - delegate

- (NSSize)collectionView:(LZCollectionView *)collectionView
                  layout:(LZCollectionViewLayout *)collectionViewLayout
  sizeForItemAtIndexPath:(LZIndexPath *)indexPath
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

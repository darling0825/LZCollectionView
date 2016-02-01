//
//  CircleLayout.m
//  CustomControl
//
//  Created by liww on 14-9-30.
//  Copyright (c) 2014年 liww. All rights reserved.
//

#import "CircleLayout.h"
#import "LZCollectionView.h"
#import "LZCollectionViewLayoutAttributes.h"
#import "NSIndexPath+Additions.h"

#define ITEM_SIZE 70

@implementation CircleLayout

-(void)prepareLayout
{
    [super prepareLayout];

    NSSize size = self.collectionView.frame.size;
    _cellCount = [[self collectionView] numberOfItemsInSection:0];
    _center = NSMakePoint(size.width / 2.0, size.height / 2.0);
    _radius = MIN(size.width, size.height) / 2.5;
}

-(CGSize)collectionViewContentSize
{
    return [self collectionView].frame.size;
}

- (LZCollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)path
{
    LZCollectionViewLayoutAttributes* attributes = [LZCollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:path];
    attributes.size = NSMakeSize(ITEM_SIZE, ITEM_SIZE);
    attributes.center = NSMakePoint(_center.x + _radius * cosf(2 * path.item * M_PI / _cellCount),
                                    _center.y + _radius * sinf(2 * path.item * M_PI / _cellCount));
    attributes.frame = NSMakeRect(attributes.center.x - attributes.size.width,
                                  attributes.center.y - attributes.size.height,
                                  attributes.size.width,
                                  attributes.size.height);
    return attributes;
}

-(NSArray*)layoutAttributesForElementsInRect:(NSRect)rect
{
    NSMutableArray* attributes = [NSMutableArray array];
    for (NSInteger i=0 ; i < self.cellCount; i++) {
        NSIndexPath* indexPath = [NSIndexPath indexPathForItem:i inSection:0];
        [attributes addObject:[self layoutAttributesForItemAtIndexPath:indexPath]];
        }
    return attributes;
}

- (LZCollectionViewLayoutAttributes *)initialLayoutAttributesForInsertedItemAtIndexPath:(NSIndexPath *)itemIndexPath
{
    LZCollectionViewLayoutAttributes* attributes = [self layoutAttributesForItemAtIndexPath:itemIndexPath];
    attributes.alpha = 0.0;
    attributes.center = NSMakePoint(_center.x, _center.y);
    return attributes;
}

- (LZCollectionViewLayoutAttributes *)finalLayoutAttributesForDeletedItemAtIndexPath:(NSIndexPath *)itemIndexPath
{
    LZCollectionViewLayoutAttributes* attributes = [self layoutAttributesForItemAtIndexPath:itemIndexPath];
    attributes.alpha = 0.0;
    attributes.center = NSMakePoint(_center.x, _center.y);
    attributes.transform3D = CATransform3DMakeScale(0.1, 0.1, 1.0);
    return attributes;
}

@end

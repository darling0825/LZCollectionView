//
//  LZCollectionViewLayoutAttributes.m
//  CustomControl
//
//  Created by liww on 14-9-30.
//  Copyright (c) 2014年 liww. All rights reserved.
//

#import "LZCollectionViewLayoutAttributes.h"
#import "NSIndexPath+Additions.h"

@implementation LZCollectionViewLayoutAttributes

- (void)setRepresentedElementCategory:(LZCollectionElementCategory)representedElementCategory
{
    _representedElementCategory = representedElementCategory;
}

- (void)setRepresentedElementKind:(NSString *)representedElementKind
{
    _representedElementKind = representedElementKind;
}

+ (instancetype)layoutAttributesForCellWithIndexPath:(NSIndexPath *)indexPath
{
    LZCollectionViewLayoutAttributes *attributes = [[LZCollectionViewLayoutAttributes alloc] init];
    attributes.indexPath = indexPath;
    return attributes;
}

+ (instancetype)layoutAttributesForSupplementaryViewOfKind:(NSString *)elementKind
                                             withIndexPath:(NSIndexPath *)indexPath
{
    LZCollectionViewLayoutAttributes *attributes = [[LZCollectionViewLayoutAttributes alloc] init];
    attributes.representedElementKind = elementKind;
    attributes.indexPath = indexPath;
    return attributes;
}

+ (instancetype)layoutAttributesForDecorationViewOfKind:(NSString *)decorationViewKind
                                          withIndexPath:(NSIndexPath *)indexPath
{
    LZCollectionViewLayoutAttributes *attributes = [[LZCollectionViewLayoutAttributes alloc] init];
    //  decorationViewKind
    attributes.indexPath = indexPath;
    return attributes;
}

- (BOOL)isEqual:(LZCollectionViewLayoutAttributes *)attributes
{
    if ([attributes.indexPath isEqual:_indexPath]) {
        return YES;
    }
    return NO;
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"<LZCollectionViewLayoutAttributes>{Section:%ld Item:%ld,frame:%@}",_indexPath.section, _indexPath.item, NSStringFromRect(self.frame)];
}
@end

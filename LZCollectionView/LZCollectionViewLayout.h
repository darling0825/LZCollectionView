//
//  LZCollectioViewLayout.h
//  CustomControl
//
//  Created by liww on 14-9-30.
//  Copyright (c) 2014年 liww. All rights reserved.
//

#import <Foundation/Foundation.h>
@class LZCollectionView;
@class LZCollectionViewLayoutAttributes;

@interface LZCollectionViewLayout : NSObject
@property(nonatomic, readonly) LZCollectionView *collectionView;
+ (Class)layoutAttributesClass;
- (NSSize)collectionViewContentSize;

- (void)prepareLayout;
- (NSArray *)layoutAttributesForElementsInRect:(NSRect)rect;
- (LZCollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath;
- (LZCollectionViewLayoutAttributes *)layoutAttributesForSupplementaryViewOfKind:(NSString *)kind
                                                                     atIndexPath:(NSIndexPath *)indexPath;
- (LZCollectionViewLayoutAttributes *)layoutAttributesForDecorationViewOfKind:(NSString *)decorationViewKind
                                                                  atIndexPath:(NSIndexPath *)indexPath;
- (NSArray *)indexPathsToInsertForSupplementaryViewOfKind:(NSString *)kind;
- (NSArray *)indexPathsToInsertForDecorationViewOfKind:(NSString *)kind;
@end

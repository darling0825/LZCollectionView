//
//  LZCollectionViewLayoutAttributes.h
//  CustomControl
//
//  Created by liww on 14-9-30.
//  Copyright (c) 2014年 liww. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LZCollectionViewDefinitions.h"
#import <QuartzCore/QuartzCore.h>

@interface LZCollectionViewLayoutAttributes : NSObject
@property(nonatomic, retain) NSIndexPath *indexPath;
@property(nonatomic, readonly) LZCollectionElementCategory representedElementCategory;
@property(nonatomic, readonly) NSString *representedElementKind;
@property(nonatomic) NSRect frame;
@property(nonatomic) NSRect bounds;
@property(nonatomic) NSPoint center;
@property(nonatomic) NSSize size;
@property(nonatomic) CATransform3D transform3D;
@property(nonatomic) CGAffineTransform transform;
@property(nonatomic) CGFloat alpha;
@property(nonatomic) NSInteger zIndex;
@property(nonatomic, getter=isHidden) BOOL hidden;

+ (instancetype)layoutAttributesForCellWithIndexPath:(NSIndexPath *)indexPath;
+ (instancetype)layoutAttributesForSupplementaryViewOfKind:(NSString *)elementKind
                                             withIndexPath:(NSIndexPath *)indexPath;
+ (instancetype)layoutAttributesForDecorationViewOfKind:(NSString *)decorationViewKind
                                          withIndexPath:(NSIndexPath *)indexPath;
@end

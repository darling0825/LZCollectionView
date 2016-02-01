//
//  LZCollectionReusableView.h
//  CustomControl
//
//  Created by liww on 14-9-30.
//  Copyright (c) 2014年 liww. All rights reserved.
//

#import <Cocoa/Cocoa.h>
@class LZCollectionViewLayoutAttributes;
@class LZCollectionViewLayout;

@interface LZCollectionReusableView : NSView

@property (nonatomic, readonly, copy) NSString *reuseIdentifier;

- (void)prepareForReuse;
- (void)applyLayoutAttributes:(LZCollectionViewLayoutAttributes *)layoutAttributes;
- (void)willTransitionFromLayout:(LZCollectionViewLayout *)oldLayout toLayout:(LZCollectionViewLayout *)newLayout;
- (void)didTransitionFromLayout:(LZCollectionViewLayout *)oldLayout toLayout:(LZCollectionViewLayout *)newLayout;

@end

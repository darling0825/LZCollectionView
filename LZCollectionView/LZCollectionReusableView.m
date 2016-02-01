//
//  LZCollectionReusableView.m
//  CustomControl
//
//  Created by liww on 14-9-30.
//  Copyright (c) 2014年 liww. All rights reserved.
//

#import "LZCollectionReusableView.h"
#import "LZCollectionViewLayoutAttributes.h"
#import "LZCollectionViewLayout.h"

@interface LZCollectionReusableView (){
    NSString *_reuseIdentifier;
}
@end

@implementation LZCollectionReusableView

- (void)setReuseIdentifier:(NSString *)reuseIdentifier
{
    _reuseIdentifier = reuseIdentifier;
}

- (void)prepareForReuse
{
    
}

- (void)applyLayoutAttributes:(LZCollectionViewLayoutAttributes *)layoutAttributes
{
    
}

- (void)willTransitionFromLayout:(LZCollectionViewLayout *)oldLayout
                        toLayout:(LZCollectionViewLayout *)newLayout
{
    
}

- (void)didTransitionFromLayout:(LZCollectionViewLayout *)oldLayout
                       toLayout:(LZCollectionViewLayout *)newLayout
{
    
}

@end

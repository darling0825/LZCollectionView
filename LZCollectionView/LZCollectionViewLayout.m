//
//  LZCollectioViewLayout.m
//  CustomControl
//
//  Created by liww on 14-9-30.
//  Copyright (c) 2014年 liww. All rights reserved.
//

#import "LZCollectionViewLayout.h"
#import "LZCollectionView.h"

#define kExceptionFormat    @"%@ not implemented in subclass %@"
#define kExceptionName      @"Not Implemented"

@implementation LZCollectionViewLayout

- (id)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (NSSize)collectionViewContentSize
{
    return self.collectionView.frame.size;
}

+ (Class)layoutAttributesClass
{
    return [self class];
}

- (void)prepareLayout
{
    
}

- (void)setCollectionView:(LZCollectionView *)collectionView
{
    _collectionView = collectionView;
}

- (NSArray *)layoutAttributesForElementsInRect:(NSRect)rect
{
    NSString *reason = [NSString stringWithFormat:kExceptionFormat, NSStringFromSelector(_cmd), [self class]];
	@throw [NSException exceptionWithName:kExceptionName
                                   reason:reason
                                 userInfo:nil];
}
- (LZCollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *reason = [NSString stringWithFormat:kExceptionFormat, NSStringFromSelector(_cmd), [self class]];
	@throw [NSException exceptionWithName:kExceptionName
                                   reason:reason
                                 userInfo:nil];
}

- (LZCollectionViewLayoutAttributes *)layoutAttributesForSupplementaryViewOfKind:(NSString *)kind
                                                                     atIndexPath:(NSIndexPath *)indexPath
{
    NSString *reason = [NSString stringWithFormat:kExceptionFormat, NSStringFromSelector(_cmd), [self class]];
	@throw [NSException exceptionWithName:kExceptionName
                                   reason:reason
                                 userInfo:nil];
    return nil;
}

- (LZCollectionViewLayoutAttributes *)layoutAttributesForDecorationViewOfKind:(NSString *)decorationViewKind
                                                                  atIndexPath:(NSIndexPath *)indexPath
{
    NSString *reason = [NSString stringWithFormat:kExceptionFormat, NSStringFromSelector(_cmd), [self class]];
	@throw [NSException exceptionWithName:kExceptionName
                                   reason:reason
                                 userInfo:nil];
    return nil;
}

- (NSArray *)indexPathsToInsertForSupplementaryViewOfKind:(NSString *)kind
{
    NSString *reason = [NSString stringWithFormat:kExceptionFormat, NSStringFromSelector(_cmd), [self class]];
	@throw [NSException exceptionWithName:kExceptionName
                                   reason:reason
                                 userInfo:nil];
}

- (NSArray *)indexPathsToInsertForDecorationViewOfKind:(NSString *)kind
{
    NSString *reason = [NSString stringWithFormat:kExceptionFormat, NSStringFromSelector(_cmd), [self class]];
	@throw [NSException exceptionWithName:kExceptionName
                                   reason:reason
                                 userInfo:nil];
}

@end

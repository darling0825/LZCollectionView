//
//  LZIndexPath.m
//  CustomControl
//
//  Created by liww on 15-11-4.
//  Copyright (c) 2015年 liww. All rights reserved.
//

#import "LZIndexPath.h"

@implementation LZIndexPath

+ (LZIndexPath *)indexPathForItem:(NSInteger)item inSection:(NSInteger)section
{
    LZIndexPath *index =[[LZIndexPath alloc ] init];
    [index setItem:item];
    [index setSection:section];
    return  index;
}

- (BOOL)isEqual:(LZIndexPath *)indexPath
{
    if (indexPath.section == self.section &&
        indexPath.item == self.item) {
        return YES;
    }
    return NO;
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"<LZIndexPath>{Section:%ld Item:%ld}",self.section,self.item];
}

@end

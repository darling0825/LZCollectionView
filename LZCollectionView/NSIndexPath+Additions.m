//
//  NSIndexPath+Additions.m
//  CustomControl
//
//  Created by liww on 14-9-30.
//  Copyright (c) 2014年 liww. All rights reserved.
//

#import <objc/runtime.h>
#import "NSIndexPath+Additions.h"
static const void *Section = &Section;
static const void *Item = &Item;

@implementation NSIndexPath (Additions)
@dynamic item;
@dynamic section;

-(NSInteger)section
{
    return [objc_getAssociatedObject(self, Section) intValue];
}

-(void)setSection:(NSInteger)section
{
    NSNumber *number= [[NSNumber alloc] initWithInteger:section];
    objc_setAssociatedObject(self, Section, number, OBJC_ASSOCIATION_COPY);
}

-(NSInteger)item
{
    return [objc_getAssociatedObject(self, Item) intValue];
}

-(void)setItem:(NSInteger)item
{
    NSNumber *number = [[NSNumber alloc] initWithInteger:item];
    objc_setAssociatedObject(self, Item, number, OBJC_ASSOCIATION_COPY);
}

+(NSIndexPath *)indexPathForItem:(NSInteger)item inSection:(NSInteger)section
{
    NSIndexPath *index =[[NSIndexPath alloc ] init];
    [index setItem:item];
    [index setSection:section];
    return  index;
}

- (BOOL)isEqual:(NSIndexPath *)indexPath
{
    if (indexPath.section == self.section &&
        indexPath.item == self.item) {
        return YES;
    }
    return NO;
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"<NSIndexPath>{Section:%ld Item:%ld}",self.section,self.item];
}

@end
